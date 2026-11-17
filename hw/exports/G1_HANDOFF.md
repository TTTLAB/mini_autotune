# mini_autotune G1 交付评审包（G1_HANDOFF）

> 给人类硬件工程师 / 预审 Claude B / 终审工程师朋友。本文件只做索引与要点，细节以所列文件为准。

## 1. 版本信息
- 版本：**v1.0**
- 分支：**g1.4**（未合并 main）
- commit：**ff80cdd**（G1.7 文档提交为在其之后的一个小 commit，见 git log）
- 基线：main = 8d90dc5
- 交付物（hw/exports/）：
  - 工程归档：`mini_autotune_v1.0_20261118-0505.epro.zip`（设计文件夹 ZIP；当前 EDA 无单文件 .epro 导出 API）
  - 整册原理图：`mini_autotune_v1.0_20261118-0505.pdf`
  - BOM：`BOM_v1.0.1_20261118-050802.csv`（含 SW1/SW2 备注与 R3 单价）
  - 四页 PNG：`power_page_v10.png` / `main_page_v10.png` / `audio_page_v10.png` / `hmi_page_v10.png`
  - 网表：`netlist_v10_20261118-0505.json`
  - 放大图：`zoom_g16_R13_R14_R15.png`、`zoom_g16_R10_R11_R12.png`、`zoom_g16_R3.png`、`zoom_g16_SW1.png`、`zoom_g16_SW2.png`、`zoom_C28x2_v09.png`、`zoom_U3_decouple_v09.png`、`zoom_C26_v09.png`
- 详细过程：[RUN_LOG.md](RUN_LOG.md)（G1.3–G1.7 各段）；设计要点与遗留：[REVIEW_NOTES.md](REVIEW_NOTES.md)；评审台账：[../docs/REVIEWS.md](../docs/REVIEWS.md)（RV-G1-001~004）。

## 2. 工程师 7 条意见落实对照表（G1.3 RV-G1-001 原 7 条，含 G1.4/G1.5 后续演进）

| 项 | 怎么改的（当前 v1.0 状态） | 位号 | 证据文件 |
|---|---|---|---|
| 1 LED 共阳+5V，阴极经限流到 GPIO（开漏点亮） | LED1 pin2/4/6→+5V，阴极经 R10/R11/R12 到 GPIO；R10–R12 统一 2.2kΩ(C4190)，属性已对齐 | LED1、R10–R12 | REVIEW_NOTES G1.3 §1；zoom_g16_R10_R11_R12.png |
| 2 电源 AMS1117→TPS563201 同步降压 | U1=TPS563201DDCR；L1=2.2µH；R13=33.2k(C23003)、R14=10k(C25804 反馈下臂)、R15=10k(EN 上拉)；C26=100nF boot | U1、L1、R13、R14、R15、C26 | REVIEW_NOTES G1.3 §2；SLVSD90 Table 7-2 p.14；zoom_g16_R13_R14_R15.png |
| 3 麦克风（要求 top port + I2S） | **G1.4 已按鼠王方案 A 换 ICS-43434(C5656610)**，6 脚 I2S；VDD 加 C30 100nF 去耦；I2S 网络名与 ESP32 GPIO 不变 | U3、C30 | RUN_LOG G1.4；zoom_U3_decouple_v09.png；DS-000069 p.10/p.15 |
| 4 功放删 FB2/FB3/C12/C13，U4 OUT± 直连 J2 | 已删，U4 OUTP/OUTN 直连 J2 | U4、J2 | RUN_LOG G1.3；netlist |
| 5 按键删 TVS1–9，每键 100nF 到 GND | 已删 TVS，每键加 C17–C25(100nF) 到 GND | K1–K9、C17–C25 | RUN_LOG G1.3；netlist |
| 6 淘宝自采件 BOM 标注 | 淘宝件已在 BOM 标「淘宝」不计价（见 §4） | J1/J2/K1–9/SW1/2/U1/U3/L1 | BOM_v1.0.1 |
| 7 电容 ≥10µF 一律钽（禁电解） | **G1.4 按新规则调整**：≤10µF 用 MLCC、>10µF 用钽。C1/C5/C7/C10/C15→10µF MLCC(C15850)；C27/C28/C29→22µF MLCC(C45783)；C4 保留 22µF 钽(+3V3) | C1/C5/C7/C10/C15/C27/C28/C29/C4 | RUN_LOG G1.4/G1.5；zoom_C28x2_v09.png |

## 3. 待工程师确认清单
1. **+3V3 总标称电容约 76µF**（C28/C29/C4/C15/C3/C16）> TPS563201 推荐 20–68µF（SLVSD90 Table 7-2）；MLCC 偏压降容后可能落回范围；是否去掉 C4 或 C15，或打样实测负载阶跃。
2. **SW1/SW2 型号**：淘宝采购、以实物为准；DeviceName TS-1088-AR03016 与料号 XD-TS-1088R-02026 不一致，待按实物确认（系统库无对应器件，未改属性）。
3. **L1 选型**：2.2µH，2520 尺寸，Isat ≥3A；当前封装名借用 VLS252012CX-150M 仅取 2.5×2.0mm 尺寸，实际型号以实物为准。
4. **D1 C252436 保留**：立创/JLC 可查（UMW/YenjiElec USBLC6-4SC6，item.szlcsc.com/20914190.html、jlcpcb partdetail C252436），在售；下单前复核品牌/库存；如不可得，候选 C85364(SRV05-4) 引脚兼容。
5. **C4 钽电容**：PCB 阶段确认丝印「+」在 pad1（网表 pin1=+3V3 电源侧，已核）。
6. **U3 底进音**：PCB 麦克风下方声孔 ≥0.5mm（DS-000069 p.17）。
7. **LED 共阳 5V 的 GPIO 复位态**：复位期间 GPIO 高阻，固件应尽早把 RGB 三脚设为输出高。

## 4. 淘宝采购件清单（不计立创价，BOM 标「淘宝」）
J1（USB-C 16PIN）、J2（PH2.0-2P 喇叭座）、K1–K9（轻触键）、SW1/SW2（拨动开关）、U1（TPS563201DDCR）、U3（ICS-43434）、L1（2.2µH 电感）。
（说明：TPS 芯片、ICS-43434 按本项目规则走淘宝；连接器/按键/开关亦淘宝。具体型号以实物/采购确认为准。）

## 5. 已知未验证
- **全工程 ERC**：headless 会话无法取得 DRC 明细（SCH_Drc.check 布尔门禁不可信），**未声称 error 0**；**待鼠王在可见 EDA 窗口激活各页跑 DRC**，把原始清单回传。ATTRMATCHCODE 等警告是否随 G1.6 属性对齐消失，同样待可见窗口核。
- 单价待确认件：C15850×5、C45783×3、C252436、TP1/TP2 等（BOM 中标「待确认」，未计入立创合计）。

## 6. 合并前状态（只检查，未合并）
- 见 `git diff --stat main...g1.4`；工作区干净，g1.4 与 origin/g1.4 一致。
- 合并命令草案（**未执行**，等鼠王确认 ERC 后）：`git checkout main && git merge --no-ff g1.4 && git push origin main`。
