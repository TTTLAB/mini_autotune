# mini_autotune 原理图方案（G1 第 1 步）

| 项 | 内容 |
|---|---|
| 文档版本 | v0.2 |
| 日期 | 2026-11-17 |
| 状态 | 方案 v0.2（已并入数据手册核实与嘉立创料号，待鼠王确认后进入画图） |
| 依据 | `docs/REQUIREMENTS.md` v1.0（G0 冻结）、`docs/DECISIONS.md` v0.2、`docs/WORKFLOW.md` v0.2、`CLAUDE.md` |
| 范围 | 仅原理图方案。本步不画图、不碰嘉立创 EDA、不做 ERC、不建 `hw/` 导出物；料号/价格为方案参考，非采购核价 |

> 数字标注约定：**有出处**（注明文档/章节）、**估算**（写明算法）、**待确认**（没有可靠出处，不得当事实用）。三类不混写。

---

## 1. 分页方案

四页原理图，页间只通过网络名连接，不跨页画长线。

| 页 | 名称 | 主要内容 | 对外网络 |
|---|---|---|---|
| 1 | 电源 | USB-C 接口、ESD、CC 下拉、5 V→3.3 V LDO、去耦 | `VBUS_IN`、`+5V`、`+3V3`、`GND` |
| 2 | 主控 | ESP32-S3-WROOM-1、EN/RESET、BOOT、原生 USB、UART0 测试点 | `+3V3`、`USB_DP`、`USB_DM`、`I2S_MIC_*`、`I2S_AMP_*`、`KEY1–9`、`RGB_R/G/B`、`AMP_SD` |
| 3 | 音频 | INMP441 麦克风、MAX98357A 功放、扬声器接口、输出滤波 | `+5V`、`+3V3`、`+3V3_A`、`I2S_MIC_*`、`I2S_AMP_*`、`SPK_P`、`SPK_N` |
| 4 | 人机交互 | 9 键、RGB LED 与限流电阻 | `KEY1–9`、`RGB_R/G/B`、`+3V3` |

### 1.1 页 1：电源

- **J1 USB-C 母座**（16 pin，USB 2.0）：VBUS、GND、CC1/CC2、D+/D-、SHIELD。
- **CC1/CC2 各接 5.1 kΩ 下拉到 GND**（sink 声明，FR-07 验收项 3）。不接任何上拉，不做 PD 协商。
- **`VBUS_IN`（J1 的 VBUS）→ ESD/TVS → `+5V`**：ESD 需覆盖 VBUS、D+、D-、CC1、CC2（器件组合见第 5 节，具体型号待确认）。
- **`+5V` 分两路**：一路直供 MAX98357A（页 3）；一路进 LDO（U1）产 `+3V3`。
- **去耦**：`VBUS_IN` 10 µF + 100 nF；`+3V3` 22 µF + 100 nF（LDO 输出电容按数据手册稳定性要求，待核对）；模组 3V3 脚就近 10 µF + 100 nF。
- **不设**电源开关、电池、充电管理、升压、电量计（ADR-0006、ADR-0012）。不另加电源指示灯——上电后 RGB 待机蓝色呼吸即上电指示（REQUIREMENTS 附录 A.1）。

### 1.2 页 2：主控

- **U2 ESP32-S3-WROOM-1**：3V3、GND、EN。
- **RESET**：EN 经 10 kΩ 上拉到 `+3V3`，1 µF 到 GND，按键短接 EN 到 GND（RC 复位延时具体值按 Espressif 硬件设计指南，待复核）。
- **BOOT**：GPIO0 经 10 kΩ 上拉，按键短接到 GND（GPIO0 本身是 strapping 脚，见 3.1）。
- **原生 USB**：GPIO19 = `USB_DM`、GPIO20 = `USB_DP`，经页 1 的 ESD 后直连 J1。ESP32-S3 内置 USB Serial/JTAG，**烧录不需要 CH340 类桥片，也不需要 DTR/RTS 三极管自动下载电路**；BOOT + RESET 人工进入下载模式作为兜底（最坏情况按两次键）。若实测工具链必须 UART 自动下载，再评估加管电路（不阻塞本方案）。
- **UART0 测试点**：GPIO43 = U0TXD、GPIO44 = U0RXD，留焊盘/排针，用于日志与兜底烧录。
- **天线净空**：模组天线区下方与周边禁止走线、铺铜、放器件，具体尺寸按模组数据手册，G4 布局落实。

### 1.3 页 3：音频

- **U3 INMP441**：VDD 接 `+3V3_A`（由 `+3V3` 经 10 Ω + 10 µF + 100 nF 滤波，见 6.2），GND；SCK←`I2S_MIC_BCLK`，WS←`I2S_MIC_WS`，SD→`I2S_MIC_SD`；**L/R 接 GND 选左声道**。
- **U4 MAX98357A**：VDD 接 `+5V`，GND；BCLK←`I2S_AMP_BCLK`，LRC←`I2S_AMP_LRC`，DIN←`I2S_AMP_DIN`；SD_MODE 与 GAIN 按第 6 节处理；OUT+/OUT- 经磁珠 + 电容滤波后到 J2。
- **J2 扬声器接口**：接 4 Ω 单声道扬声器（座型与线规待确认，G4 定腔体与固定）。
- 功放 5 V 就近放 10 µF + 100 nF；麦克风 3.3 V 就近放 1 µF + 100 nF。

### 1.4 页 4：人机交互

- **K1–K9**：每个按键一端接对应 GPIO，另一端接 GND；上拉与去抖见第 4 节。BOOT 与 RESET 属主控页，不计入这 9 键。
- **D1 RGB LED**：共阴 5050/3528 类，3 个 GPIO 各串限流电阻驱动（见 5.2）。

---

## 2. 电源树

### 2.1 拓扑

```
USB-C 5V（充电宝）
  │ VBUS_IN
  ├─ ESD/TVS ──► +5V ─┬─► MAX98357A VDD（功放，class-D）
  │                    └─► LDO 5V→3.3V ──► +3V3 ─┬─► ESP32-S3-WROOM-1
  │                                               ├─► 10Ω+10µF+100nF ──► +3V3_A ──► INMP441
  │                                               └─► RGB LED（3× 限流电阻）
  └─ CC1/CC2 ──► 5.1kΩ ──► GND
```

整机无储能单元，插电即开、拔电即关（ADR-0006、ADR-0012）。

### 2.2 各路电流估算

| 负载 | 轨 | 电流 | 类别 | 出处 / 算法 |
|---|---|---|---|---|
| ESP32-S3 芯片 Wi-Fi 802.11b@21dBm 发射峰值 | 3.3 V | 340 mA（Peak，100% duty，VDD 3.3V） | 有出处 | ESP32-S3 Datasheet v2.2「Current Consumption for Wi-Fi (2.4GHz) in Active Mode」Table 5-7（旧 Table 4-7） |
| ESP32-S3-WROOM-1 模组 Wi-Fi 802.11b@20.5dBm 峰值 / 供电能力建议 | 3.3 V | 355 mA / ≥500 mA | 有出处 | WROOM-1 Datasheet v1.8 Table 6-4 (p.28) / Table 6-2 (p.27)；Espressif Schematic Checklist（3.3V 供电电流 ≥500 mA） |
| INMP441（3.3 V） | 3.3 V | 典型 2.2 mA（最大 2.5 mA；1.4 mA 是 1.8 V 时的值） | 有出处 | INMP441 Datasheet Table 1 (p.4) POWER SUPPLY：1.4 mA@1.8V / 2.2 mA@3.3V |
| RGB（3 通道） | 3.3 V | ≤60 mA（每通道 20 mA 上限；设计按每通道 10 mA） | 估算 | 型号 C51933351（见 5.3）；Vf 待实测 |
| **3.3 V 合计** | 3.3 V | 峰值约 417 mA；设计取 0.5 A，最坏核算按 0.56 A | 估算 | 355 + 2.2 + 60 ≈ 417 mA；设计取 0.5 A，最坏按 0.56 A（约 34% 瞬态余量） |
| MAX98357A | 5 V | 0.7–0.9 A | 估算 | P/(V×η)：3.2 W/(5 V×0.8–0.9) ≈ 0.71–0.80 A；考虑音乐瞬态与效率下降，取 0.7–0.9 A 作设计包络；3.2 W 出处 MAX98357A 数据手册（5 V/4 Ω/10% THD） |
| **5 V 合计（最坏叠加）** | 5 V | 标称约 1.1–1.4 A；包络上限约 1.46 A | 估算 | 功放 0.71–0.80 A（标称）或 0.9 A（包络）+ LDO 支路 0.42–0.56 A（线性 LDO 输入电流≈输出电流） |

### 2.3 结论

- **3.3 V LDO 额定 ≥800 mA，建议 1 A**；3.3 V 轨按 ≥500 mA 设计（覆盖模组推荐值与峰值）。
- **5 V 轨能力底线 ≥1 A**；因功放包络与 LDO 支路可能叠加（最坏约 1.46 A，估算），器件与走线按 **1.5 A 能力**核算，不以 1 A 为设计上限（待实测）。
- 5 V 峰值只在最大音量、低阻抗、高占空比时出现；实际音乐峰值占空比低，但电源器件不能按平均值选。
- 充电宝小电流自动断电是 FR-07 的验收项：本机工作电流约 0.15–1.4 A（估算，随音量变化），接近部分充电宝的关机阈值边界，必须实测 3 款（见第 7 节）。

### 2.4 输入保护与去耦（画图时落实）

- VBUS 入口：TVS/ESD + 10 µF + 100 nF；总输入电容不宜过大，避免插拔瞬间触发充电宝过流保护（估算风险，实测确认）。
- LDO 输入 10 µF、输出 22 µF + 100 nF；AMS1117 类对输出电容 ESR 有稳定性要求，须按最终选定器件的数据手册核对（待确认）。
- 功放 VDD 就近 10 µF + 100 nF，与 LDO 支路分开走线，在 `+5V` 入口处汇合（见 6.2）。

---

## 3. GPIO 分配

### 3.1 禁区与保留引脚

| 类别 | 引脚 | 处理 | 出处 |
|---|---|---|---|
| Strapping 引脚 | GPIO0、GPIO3、GPIO45、GPIO46 | GPIO0 仅作 BOOT 按键（本就是启动用途）；GPIO3/45/46 不作普通 IO。**修正：GPIO46 不是仅输入，是双向 I/O（Datasheet Table 2-4 Type=I/O/T；复位默认弱下拉）；网上部分引脚图称其 input-only 属过时错误** | ESP32-S3 Datasheet v2.2 Table 3-3 (p.33)、Table 2-4；ESP-IDF GPIO 文档（GPIO0/3/45/46 为 strapping） |
| SPI Flash（SPI0/1） | GPIO26–GPIO32 | 一律不分配 | ESP32-S3 Datasheet Table 2-10；ESP-IDF GPIO 文档 |
| Octal PSRAM 模组 | GPIO33–GPIO37 | 保守全部不分配；使用 Octal（1.8V/3.3V、in-package 或 off-package）flash/PSRAM 时 GPIO33–GPIO37 被占用不可他用；1.8V Octal 变体的 GPIO47/48 作 SPICLK_P/N 也需避开 | Espressif Schematic Checklist (ESP32-S3)「Flash and PSRAM」；ESP32-S3 Datasheet Table 2-10 |
| 原生 USB | GPIO19 = USB_D-，GPIO20 = USB_D+ | 固定给 USB，不作他用 | ESP32-S3 数据手册 |
| UART0 | GPIO43 = U0TXD，GPIO44 = U0RXD | 调试测试点，不作普通 IO | ESP32-S3 数据手册引脚定义 |
| 不存在的引脚 | GPIO22–GPIO25 | 没有这四个脚（ESP32-S3 共 45 个 GPIO：0–21、26–48） | ESP-IDF GPIO 文档「GPIO Summary」 |
| 默认 JTAG（不是禁区） | GPIO39 = MTCK、GPIO40 = MTDO、GPIO41 = MTDI、GPIO42 = MTMS | 本方案占用了 39/40/41（RGB 与 AMP_SD），**等于放弃排针 JTAG**，调试走 USB-JTAG；若工程师要求保留排针 JTAG，按 3.3 的备选调整 | ESP32-S3 Datasheet Table 2-10、§3.4（默认 JTAG 实际走 USB Serial/JTAG，GPIO19/20） |

### 3.2 分配表

引脚定义依据 ESP32-S3-WROOM-1 数据手册；strapping、Flash/PSRAM 占用依据 ESP32-S3 系列数据手册。

| 信号 | GPIO | 方向 | 说明 |
|---|---|---|---|
| I2S 输入 BCLK（INMP441 SCK） | GPIO4 | 输出 | 麦克风位时钟 |
| I2S 输入 WS（INMP441 WS） | GPIO5 | 输出 | 左右声道时钟 |
| I2S 输入 SD（INMP441 SD） | GPIO6 | 输入 | 麦克风数据；L/R 接地选左声道 |
| I2S 输出 BCLK（MAX98357A BCLK） | GPIO7 | 输出 | 功放位时钟 |
| I2S 输出 LRC（MAX98357A LRC） | GPIO8 | 输出 | 功放声道时钟 |
| I2S 输出 DIN（MAX98357A DIN） | GPIO9 | 输出 | 功放数据 |
| 按键 K1–K9 | GPIO10–GPIO18 | 输入 | 直连，按下接地；上拉见第 4 节 |
| USB D- | GPIO19 | 双向 | 原生 USB，直连 J1 |
| USB D+ | GPIO20 | 双向 | 原生 USB，直连 J1 |
| RGB R | GPIO38 | 输出 | PWM（LEDC） |
| RGB G | GPIO39 | 输出 | PWM；默认 JTAG 的 MTCK |
| RGB B | GPIO40 | 输出 | PWM；默认 JTAG 的 MTDO |
| 功放 SD_MODE（可选） | GPIO41 | 输出 | 默认 JTAG 的 MTDI；电平阈值风险见 6.1 |
| BOOT | GPIO0 | 输入 | strapping，按键到 GND |
| RESET | EN（模组 EN 脚） | — | 按键到 GND，10 kΩ 上拉 + 1 µF |
| U0TXD 测试点 | GPIO43 | 输出 | 调试/兜底烧录 |
| U0RXD 测试点 | GPIO44 | 输入 | 调试/兜底烧录 |

### 3.3 余量与取舍

- 已用：GPIO0、4–20、38–41、43–44。剩余可用：**GPIO1、2、21、42、47、48（6 根）**；GPIO33–37 按 R8 模组保守预留。
- **取舍一（待确认）**：GPIO39/40/41 被 RGB 与 AMP_SD 占用，排针 JTAG 不可用（USB-JTAG 仍可用）。若工程师要求保留 JTAG，备选：RGB 改 GPIO47/48/21，SD_MODE 不占 GPIO（用电阻固定电平），使 39–42 四根 JTAG 全部空出（GPIO38 本就是普通 IO）。两套引脚在 G2 前定稿。
- **取舍二（待确认）**：9 键直连占 9 根 IO 是本方案最大的一笔 GPIO 开销；若后续需要加外设（如额外测试点），优先从 GPIO1/2/21/47/48 取，不得动 3.1 的禁区。

---

## 4. 9 键电气方案

### 4.1 结论

**采用 9 键直连 GPIO，不用 3×3 矩阵。** 本方案给出 Q-16 的电气选型建议；Q-16 还含物理排列，排列在 G1 内随结构与按键选型确认。Q-16 的正式关闭随本方案经鼠王确认、由编排者更新 REQUIREMENTS 9.2 生效；本步不改其他文件。

### 4.2 理由

1. **GPIO 够用**：避开禁区后仍有 6 根空闲（3.3），9 根直连可满足。
2. **无鬼键**：直连每键独立，键 9 + 音名这类两键同按可靠；矩阵无二极管时三键组合可能鬼键（RISK-04）。
3. **固件最简**：无需扫描时序与矩阵去抖，调试成本低，符合「实时音频优先」的固件预算。
4. **成本与布线**：不加二极管、不做矩阵布线，BOM 与走线更短。

若将来 GPIO 紧张再评估矩阵；v1 不采用。

### 4.3 按键电路

- 每个按键：GPIO ↔ 轻触开关 ↔ GND。
- 上拉：优先用 ESP32-S3 内部上拉（阻值约 45 kΩ，待复核）；若抗干扰不足，改外部 10 kΩ 上拉到 `+3V3`（BOM 增加 9 颗电阻，待样机确认）。
- 去抖：可选每键 100 nF 到 GND（RC 时间常数与内部上拉配合，具体值样机确认）；固件仍需 20–50 ms 去抖，满足 FR-03「响应 ≤50 ms」。
- ESD：NFR-08（SHOULD）要求**原理图含按键的 ESD 器件**。每个按键线需加 ESD 钳位（多路 ESD 阵列，或串阻 + TVS）；3.3 V 电源轨的 TVS 不能替代按键线保护。具体器件在 G2 定。

### 4.4 与机械的接口

按键物理排列（3×3 或其它）属 Q-16 的一部分，建议在 G1 内按 ID-1 尺寸与按键选型定；电气上 9 根独立 IO 与排列无关。间距与手感在 G4 打样验证（RISK-04）。

---

## 5. LDO 选型、RGB 方案与关键器件

### 5.1 LDO（Q-17）

**基线：5 V→3.3 V、1 A 级线性 LDO（AMS1117-3.3 类，SOT-223）。**

| 项 | 内容 |
|---|---|
| 压差 | 输入最低 4.75 V（NFR-04）时余量 1.45 V；AMS1117 数据手册：dropout 最大 1.3 V@1 A，0.56 A 下更低——可用但余量不算宽裕。基线器件立创 C6186（AMS1117-3.3，SOT-223，基础库；国内人民币价待确认，同规格 UMW 友台 C347222 ¥0.145 可备选） |
| 功耗（最坏） | (5.0−3.3) V × 0.56 A ≈ **0.95 W**（估算）；4.75 V 输入时约 0.81 W |
| 散热 | SOT-223 的 θJA 与铺铜强相关（约 60–100 °C/W，估算），0.95 W 对应温升约 57–95 °C，**结温余量偏紧，不能只写「铺铜散热」了事**；画图阶段必须做热核算，必要时改 DPAK/加大铜箔/换 Buck |
| 稳定性 | 输出电容按最终器件数据手册选（AMS1117 类常要求 22 µF 级、注意 ESR），待确认 |

**备选：5 V→3.3 V 同步 Buck（MP2315 类）+ 后级 LC 滤波。** 效率高、发热小，但开关噪声可能耦合进音频（RISK-06），需工程师会签；具体型号在画图时（G1 内）定。

**结论：本方案建议关闭 Q-17——3.3 V 轨采用 1 A 级线性 LDO（AMS1117-3.3 类为基线），Buck 作备选。型号与封装在画图时（G1 内）从基线系列选定并完成热核算，作为 G1 产出；温升实测只能在打样回板后（G6 下单之后）做，若超标按变更流程回退到 Buck 或换封装。Q-17 的正式关闭随本方案经鼠王确认生效。**

### 5.2 RGB 方案

- **器件**：3× PWM RGB LED（共阴优先，5050/3528 类；共阳也可，但共阴更适合 GPIO 拉高驱动）。3.3 V 供电、3.3 V 电平直驱，**无需电平转换**（与 ADR-0005 一致）。
- **限流电阻**：`R = (3.3 V − Vf) / If`。
  - 红：Vf 约 1.8–2.2 V，If = 10 mA → 110–150 Ω（估算）。
  - 绿/蓝：Vf 约 2.8–3.2 V，If = 10 mA → 10–50 Ω；**若 Vf 接近 3.2 V，裕量只剩 0.1 V，亮度对 Vf 与 3.3 V 波动极敏感**。对策：选低 Vf（≤2.8 V @ If）器件、把 If 降到 5 mA、或加小 MOS 管做恒流/升压裕量（待确认）。
  - 每通道按 ≤10 mA 设计（电源预算按 20 mA 留上限），远低于 GPIO 驱动上限。
- **PWM**：ESP-IDF LEDC，三通道独立；附录 A.1/A.2 的颜色与闪烁由固件实现。

### 5.3 关键器件清单

> 料号/价格/库存为 2026-11-17 在立创商城（item.szlcsc.com）与 LCSC 全球站查询所得（子代理 lcsc-parts 抓取，主 Claude 抽查 4 条确认，见第 8 节）。单价为 1+ 档，随批量与时间变动，下单前复核。

| 器件 | 型号 / 规格 | 封装 | 嘉立创料号 | 基础库 | 单价（¥,1+） | 库存 | 来源 / 备注 |
|---|---|---|---|---|---|---|---|
| 主控模组 | ESP32-S3-WROOM-1-N16R8 | 模组 SMD 25.5×18mm | C2913202 | 否（扩展库） | 21.52 | 9,888 | item.szlcsc.com/3198300.html；备选 N8R2=C2913204、N8R8=C2913201 |
| 麦克风 | INMP441（I2S MEMS 24bit） | SMD-9 | C5438445 | 否（扩展库） | 58.00 起（缺货参考价） | 0（缺货） | item.szlcsc.com/6315022.html；全渠道缺货，Q-13 关键风险，须定替代料 |
| 功放 | MAX98357AETE+T | TQFN-16-EP(3×3) | C910544 | 否（扩展库） | 4.91 | 25,688 | item.szlcsc.com/978950.html；5V/4Ω 3.2W |
| LDO | AMS1117-3.3（AMS 原厂） | SOT-223 | C6186 | 是（基础库） | 待确认（LCSC US$0.1062） | 877,830（LCSC 全球站） | lcsc.com/product-detail/C6186.html；国内人民币价待确认；UMW 友台 C347222 ¥0.145/809,549/扩展库 item.szlcsc.com/323882.html |
| USB-C 母座 | SHOU HAN TYPE-C 16PIN 2MD(073)，USB2.0 sink | SMD 卧贴 | 见来源链接（页面 sku） | 否（扩展库） | 0.2512 | 980,951 | item.szlcsc.com/2901843.html |
| ESD 阵列 | USBLC6-2SC6（TWGMC） | SOT-23-6 | C5250994 | 否（扩展库） | 0.2768 | 224 | item.szlcsc.com/5967330.html；数据线 ESD；VBUS/CC 另配 TVS |
| RGB LED | GL5050RGB01-A（桂光）5050 共阴 0.2W | 5050 | C51933351 | 否（扩展库） | 0.082 | 20,974 | item.szlcsc.com/54646047.html；Vf 待实测，见 5.2 |
| 轻触开关 ×9 | TS-118516020A（汉电）SPST 1.6N | SMD | C7471790 | 否（扩展库） | 待确认（LCSC US$0.04） | 2,190（LCSC 全球站） | lcsc.com/product-detail/C7471790.html；国内人民币价待确认 |
| 扬声器 | HDK-5204KC-4W，4Ω±5% 3W 200Hz 92.5dB | — | C53325602 | 否（扩展库） | 2.61 | 37 | item.szlcsc.com/56414340.html；库存偏少 |
| 5.1kΩ 电阻 | 0603WAF5101T5E 0603 ±1% | 0603 | C23186 | 是（基础库） | 0.0042 | 13,575,256 | item.szlcsc.com/23913.html；USB-C CC 下拉 |
| 10µF 电容 | CL10A106MA8NRNC 0603 X5R 25V | 0603 | C96446 | 是（基础库） | 0.115 | 1,099,925 | item.szlcsc.com/97651.html |
| 100nF 电容 | CC0603KRX7R9BB104 0603 X7R 50V | 0603 | C14663 | 是（基础库） | 0.0162 | 24,000,000 | item.szlcsc.com/15331.html |

---

## 6. 防啸叫的电路层措施（RISK-03，最高风险）

### 6.1 功放增益与 SD_MODE

- **GAIN 引脚（决定增益，防啸叫关键）**：MAX98357A 在 I2S 模式有 5 档（Datasheet Gain Settings / ADI 设计笔记 GAIN_SLOT 表）：GND 经 100 kΩ→15 dB；GND→12 dB；悬空→9 dB；VDD→6 dB；VDD 经 100 kΩ→3 dB。**本方案取最低档 3 dB：GAIN 经 100 kΩ 接 VDD**；响度不足再按档提高，避免环路增益过大。
- **SD_MODE 三电平（已按数据手册确认，不是按 VDD 比例）**：绝对电压阈值 B0≈0.16 V、B1≈0.77 V、B2≈1.4 V（不随 VDD 缩放）：<0.16 V=关断；0.16–0.77 V=(L+R)/2；0.77–1.4 V=右声道；>1.4 V=左声道；内部约 100 kΩ 下拉，悬空即关断。**5 V 供电时 3.3 V 逻辑兼容**：3.3 V 判为高（>1.4 V，选左声道），0 V 判为低（关断）；仅当 VDD<3.0 V 而逻辑为 3.3 V 时才需在 SD_MODE 串约 2 kΩ 限流。本方案：SD_MODE 用电阻固定到确定高电平选左声道（常开）；若需软静音，用 GPIO41 经分压保证 >1.4 V（细节 G2 定）。出处 MAX98357A Datasheet p.7/p.18。
- **上电/插拔爆音**：MAX98357A 自带 click/pop 抑制，但 FR-07 要求插拔无爆音，仍需实测；若 SD_MODE 可软控，固件在初始化完成前保持关断。

### 6.2 电源与地隔离

- **麦克风单独供电**：`+3V3` → 10 Ω → `+3V3_A`，配 10 µF + 100 nF；10 Ω 上的压降约 2.2 mA×10 Ω ≈ 22 mV（估算，可忽略）。
- **走线分开**：麦克风电源/地与功放 5 V 功率线分开走，不从功放回流路径下方穿过。
- **单点汇合**：功放/5 V 功率地与麦克风/数字信号地在 **LDO 输入处（VBUS 接地点）** 单点汇合；地平面具体分割方式在 G4 布局落实，不在原理图阶段过度设计。
- **去耦就近**：每颗芯片电源脚旁 100 nF，功放 10 µF、麦克风 1 µF。

### 6.3 功放输出

- 按 MAX98357A 数据手册加 **磁珠 + 电容**输出滤波（具体参数按数据手册与应用笔记，待确认）；OUT+/OUT- 走线短、成对，远离麦克风与 I2S 敏感线。
- 扬声器线不要与麦克风信号线并行；J2 位置在 G4 与麦克风开孔错开。

### 6.4 声学措施（G4 落实，原理图只留接口）

- 扬声器腔体密封、前后腔隔离；麦克风开孔加胶垫/密封圈，避免壳体漏声。
- 麦克风与扬声器尽量拉开距离、指向错开（进音孔不正对扬声器）。
- 外壳结构在 G4 评审时按 FR-05「≤10 cm 正对不啸叫」验收。

### 6.5 固件兜底（二级措施，不能替代电路与结构）

- 输出限幅、啸叫频点陷波、自动降增益；异常时切旁通或降音量。
- 这些是兜底，不作为通过 FR-05 的主要手段。

---

## 7. 风险与待确认

| 风险 / 待确认项 | 影响 | 缓解 | 阻塞阶段 |
|---|---|---|---|
| LDO 散热：SOT-223 在 0.95 W 下结温余量偏紧 | 过温、寿命、NFR-04/NFR-10 | G1 内完成热核算 + 铺铜设计；样板阶段实测，超标则换 DPAK 或改 Buck（RISK-06 会签） | **G2 前完成热核算；样机实测** |
| 嘉立创料号/基础库/单价（本步已查多数） | 成本、可制造性、NFR-03/NFR-09 | 2026-11-17 已查多数 C 料号/单价/库存（见 5.3）；C6186、C7471790 国内人民币价待确认；INMP441 缺货需定替代；价格随批量/时间变动，G3 逐项复核 | G3 BOM |
| INMP441 生命周期与供货（Q-13） | 选型失败、BOM 返工 | G3 前核实是否 NRND/停产；备选 ICS-43434 类 | G3 BOM |
| 啸叫（RISK-03，最高风险） | 无法正常使用 | 6.1–6.5 全套；FR-05 ≤10 cm 实测 | G2/G5 + 样机 |
| class-D 开关噪声（RISK-06） | 本底噪声升高 | 输出滤波、地分割、远置、实测 | G4/G5 |
| USB 烧录：原生 USB-JTAG 的工具链兼容性 | 烧录不顺 | 本方案不用桥片；BOOT/RESET 兜底；打样后实测 3 次（FR-08） | G2 / 样机 |
| 模组天线净空 | 射频性能（本项目关闭 Wi-Fi/BLE，但模组仍要求净空） | 按模组数据手册留净空，G4 检查 | G4 |
| 充电宝 5 V 电流能力与小电流自动断电 | 工作中断（FR-07） | 3 款充电宝实测；整机电流估算 0.15–1.4 A | G2/G3 + 样机实测 |
| Strapping 引脚上电电平（GPIO0/3/45/46） | 启动模式错误 | 只把 GPIO0 用于 BOOT，其余不接负载；上电时序实测 | G2 |
| SD_MODE 电平（5 V 供电，3.3 V 逻辑） | 功放常关/声道错误 | 已确认兼容（绝对阈值 B2≈1.4 V，3.3 V 判为高）；本方案电阻固定选左声道，软静音可选 GPIO41 经分压，G2 落地 | G2 |
| RGB 蓝/绿 Vf 裕量（3.3 V 轨） | 亮度不足/批次差异 | 选低 Vf 器件、降 If、必要时加恒流管 | G2 |
| GPIO39/40/41 占用导致排针 JTAG 不可用 | 调试手段受限 | 走 USB-JTAG；或按 3.3 备选改引脚 | G2 定稿 |
| 按键上拉/去抖与 ESD 细节未定 | 误触、ESD 损伤 | 样机验证内部上拉；必要时外部 10 kΩ + TVS | G2/G4 |

**本步边界**：本文件只是方案，**未画原理图、未做 ERC、未核对封装**；料号/价格为方案阶段参考，最终采购价在 G3 复核。表中标为 G2 的项必须在 G2 前逐项关闭或书面接受；标为 G3/G4 的项按其阶段关闭。任何一项不得无记录跳过。

---

## 8. 研究来源与抽查记录

### 8.1 数据手册来源（子代理 ds-pins 只读核查）
- ESP32-S3 Series Datasheet v2.2 — https://documentation.espressif.com/esp32-s3_datasheet_en.pdf（Table 2-3/2-4、2-10、3-3、3-4、§3.2/3.4）
- ESP32-S3-WROOM-1/WROOM-1U Datasheet v1.8 — https://documentation.espressif.com/esp32-s3-wroom-1_wroom-1u_datasheet_en.pdf（Table 3、4-2、6-2 p.27、6-4 p.28）
- ESP-IDF GPIO & RTC GPIO (ESP32-S3) v6.0.1 — https://docs.espressif.com/projects/esp-idf/en/v6.0.1/esp32s3/api-reference/peripherals/gpio.html
- Espressif Hardware Design Guidelines – Schematic Checklist (ESP32-S3) — https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32s3/schematic-checklist.html
- INMP441 Datasheet (TDK InvenSense) — https://invensense.tdk.com/wp-content/uploads/2015/02/INMP441.pdf（Table 1, p.4）
- MAX98357A/MAX98357B Datasheet (ADI) — https://www.analog.com/media/en/technical-documentation/data-sheets/MAX98357A-MAX98357B.pdf（Gain Settings；SD_MODE p.7/p.18）
- ADI 设计笔记 GAIN_SLOT 表 — https://www.analog.com/cn/resources/design-notes/optimize-cost-size-and-performance-with-max98357-wlp.html

### 8.2 嘉立创查询（子代理 lcsc-parts）
查询时间 2026-11-17；站点 item.szlcsc.com、www.lcsc.com。结果见 5.3。未核实项：C6186、C7471790 的国内人民币价；INMP441 缺货。

### 8.3 抽查结果（主 Claude 复查 ≥3 条，已打开来源页确认）
1. C910544 = MAX98357AETE+T，¥4.91，TQFN-16 — 已核（item.szlcsc.com/978950.html）✓
2. C2913202 = ESP32-S3-WROOM-1-N16R8，¥21.52 — 已核（item.szlcsc.com/3198300.html）✓
3. C96446 = CL10A106MA8NRNC 10µF 0603，¥0.115 — 已核（item.szlcsc.com/97651.html）✓
4. C5438445 = INMP441，¥58，SMD-9 — 已核（item.szlcsc.com/6315022.html）✓
5. strapping = GPIO0/3/45/46、ESP32-S3 无 GPIO22–25 — 已核（ESP-IDF GPIO 文档）✓
6. Octal flash/PSRAM 占 GPIO33–37、3.3V 供电 ≥500 mA — 已核（Espressif Schematic Checklist）✓

---

本文件为 G1 第 1 步方案，待鼠王回复「确认」后才进入第 2 步（用 jlceda skill 画图）。
