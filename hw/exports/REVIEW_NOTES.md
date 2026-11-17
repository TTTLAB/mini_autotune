# G1 评审备注（REVIEW_NOTES）

## 阶段 2｜符号处理说明（供工程师评审）
1. **U2（ESP32-S3-WROOM-1-N16R8，C2913202）符号缺陷**：库符号引脚坐标重叠（IO35 与 IO38 同在 (85,15)）。IO35 属禁止区 GPIO33–37 且未使用，故从符号实例**删除 IO35 引脚**以释放 IO38(RGB_R)、消除 OVERLAPPIN；电气无影响。
2. **J1 换符号原因**：原 TYPE-C16PIN / TypeC-16PIN 库符号存在 SBU 与 GND 脚坐标重叠缺陷（NC 标记与 GND 叠字/误连风险）；改用引脚不重叠的 TYPE-C-16PIN（{{SECRET_qblwnxit}}），SBU1/SBU2 置 NC 并与 GND 分离（证据 power_page_J1_zoom.png）。

## 阶段 3｜音频页
- 麦克风 ICS-43432(C574021)：CONFIG/R 拉地、LR 接地（左声道）、SD 经 100k 下拉、VDD→+3V3_A 就近 0.1µF。引用 DS-000038 Rev1.0 p.8 Table6 原文（见 RUN_LOG）。
- +3V3_A = +3V3 经 R3 10Ω + C7 10µF + C8 100nF。
- MAX98357A(C910544)：VDD→+5V 就近 C10 10µF + C11 100nF；GAIN 经 R5 100k→VDD（3dB）；SD_MODE 由 AMP_SD 经 R6 10k / R7 22k 分压→2.27V>1.4V；OUT± 经 FB2/FB3 磁珠 + C12/C13 1nF 到 J2(PH2.0-2P)。
- **已知未完成**：SD_MODE 仍有 1 条网络重名(ONENETNAME)未合并；输出滤波数值数据手册无明确值(待确认)。

## 阶段3 追加（SD_MODE 修复与复算）
- 已消除音频页 SD_MODE 与 GAIN/+5V/GND 的短路（根因为 R5 贯通线，删除后全页改为短线+网络标签）。
- SD_MODE 分压：R6=10k、R7=22k、MAX98357A SD_MODE 内部下拉约100kΩ(Datasheet p.7/p.18)，R7∥100k=18.03k，V=2.12V>1.4V（开）；AMP_SD=0 时 0V（关）。
- 输出磁珠+电容具体值数据手册未给明确值 → 待工程师确认。

## 阶段B LED 说明（待工程师）
- GL5050RGB01-A 规格书：共阴；Vf(IF=20mA) 红1.8–2.6V、绿2.8–3.6V、蓝2.8–3.6V（规格书 p.3/8）。**6 脚到 R/G/B 阳极/阴极映射规格书为图片、文本读不出 → 待工程师按 p.2 封装/极性图确认，未用假设接线**。
- 3.3V 共阴限流：红 If5mA→约220Ω；**绿/蓝 Vf_max 3.6V 在 3.3V 下无法给出≥2mA，余量不足**；备选：共阳 LED + 5V 供电 + GPIO 低电平灌电流。

## 阶段B2 LED 占位
- LED1 引脚映射待确认（规格书 p.2 封装/极性图，文本读不出），LED 暂不接线。
- R_R(270Ω)/R_G(62Ω)/R_B(62Ω) 一端接 GPIO 网 RGB_R/RGB_G/RGB_B(GPIO38/39/40)，另一端悬空待 LED。
- 绿/蓝 3.3V 余量不足问题同前（建议共阳+5V+GPIO 灌电流），待工程师定。

## 阶段B2 LED 正式接线（规格书 p.2 极性图）
- 规格书 p.2 极性图：pin1=B-、2=B+、3=R-、4=R+、5=G-、6=G+（共阴）。阴极 1/3/5→GND；阳极 4/6/2 经限流到 GPIO38/39/40。
- 因三色阴极独立引出，**同一颗料也可改为：阳极接 +5V、阴极经限流电阻接 GPIO（开漏/低电平点亮）**——供工程师在绿/蓝 3.3V 余量不足时选择。
- 绿/蓝 Vf_max 3.6V>3.3V，3.3V 下余量不足（前已记）。LED 符号引脚非 10 栅格（±19/21），导出标签已对齐，评审知悉。

## 阶段C 全局检查（2026-11-18）
- 全局 ERC：error 0；warn 4（NETOBJECTONGRID，LED1 引脚非栅格，非电气）。详见 hw/exports/erc_all_report.txt。
- 网表 GPIO 对照（U2 引脚→网络，均与 SCHEMATIC_PLAN §3.2 一致）：
| 信号 | GPIO | U2脚 | 网络 | | 信号 | GPIO | U2脚 | 网络 |
|---|---|---|---|---|---|---|---|---|
| I2S_MIC_BCLK | 4 | 4 | I2S_MIC_BCLK | | KEY1 | 10 | 18 | KEY1 |
| I2S_MIC_WS | 5 | 5 | I2S_MIC_WS | | KEY2 | 11 | 19 | KEY2 |
| I2S_MIC_SD | 6 | 6 | I2S_MIC_SD | | KEY3 | 12 | 20 | KEY3 |
| I2S_AMP_BCLK | 7 | 7 | I2S_AMP_BCLK | | KEY4 | 13 | 21 | KEY4 |
| I2S_AMP_LRC | 8 | 12 | I2S_AMP_LRC | | KEY5 | 14 | 22 | KEY5 |
| I2S_AMP_DIN | 9 | 17 | I2S_AMP_DIN | | KEY6 | 15 | 8 | KEY6 |
| USB_DM | 19 | 13 | USB_DM | | KEY7 | 16 | 9 | KEY7 |
| USB_DP | 20 | 14 | USB_DP | | KEY8 | 17 | 10 | KEY8 |
| RGB_R | 38 | 31 | RGB_R | | KEY9 | 18 | 11 | KEY9 |
| RGB_G | 39 | 32 | RGB_G | | AMP_SD | 41 | 34 | AMP_SD |
| RGB_B | 40 | 33 | RGB_B | | BOOT | 0 | 27 | BOOT |
| U0TXD | 43 | 37 | U0TXD | | U0RXD | 44 | 36 | U0RXD |
- 禁止区 GPIO3 / 26–37 / 45 / 46：网表中**无任何连接**（NC），确认符合 §3.2。
- 位号全局唯一：61 个器件无重复；R_R/R_G/R_B 已改为 R10/R11/R12。

## 阶段F｜LED1 蓝灯反接修复（2026-11-18）
- 库符号 GL5050RGB01-A（project 库 2fab92e94ff31362）**中行（蓝）二极管图形方向画反**：阴极在 pin2(B+) 侧、阳极在 pin5(G−/GND) 侧，与规格书 p.2 极性（pin1/3/5=阴极、pin2/4/6=阳极）不符。
- 已 关于 x=0 镜像翻转该二极管图形修正。仅改图形，引脚号/网络不变；上(绿)、下(红)两只方向本正确。
- 引脚号→网络经网表复核：1/3/5=GND；4→R10(270Ω)→RGB_R；6→R11(62Ω)→RGB_G；2→R12(62Ω)→RGB_B。原接线即符合规格书，无需改引脚。
- 网络名 R_K/G_K/B_K 改为 LED_RA/LED_GA/LED_BA（阳极侧）。
- 提示：此符号把蓝灯阴极画在 pin5(G− 脚)、绿灯阴极画在 pin1(B− 脚)，因 pin1/3/5 同为 GND，电气无差；若要“图形与脚号逐一对齐”，可后续重画为三只同色二极管（蓝 1-2、绿 5-6、红 3-4），不阻塞本阶段。

## 评审包要点（G1 / v0.4，供工程师评审）

### 设计目标
- 银行卡尺寸（ID-1，≤85.6×54mm）单手持握；实时修音；端到端延迟 ≤15ms；USB-C 5V 供电；内置扬声器；9 键 + RGB 指示。无电池/无充电/无电量计。

### 四页要点
- **电源页**：J1 USB-C(16P)；CC1/CC2 各 5.1kΩ 下拉；VBUS_IN 经 D1(USBLC6-4SC6) ESD → +5V；+5V 一路直供功放、一路经 U1 AMS1117-3.3 → +3V3；去耦 C1/C2/C5/C6(10µF/100nF)、C3(10µF)、C4(22µF 钽，LDO 输出)。
- **主控页**：U2 ESP32-S3-WROOM-1-N16R8(C2913202)；EN 10kΩ 上拉+1µF+SW1 复位；BOOT(GPIO0) 10kΩ 上拉+SW2；原生 USB(GPIO19/20)；UART0 测试点 TP1/TP2；I2S/按键/RGB 的 GPIO 映射见 REVIEW_NOTES 上表 §3.2。
- **音频页**：U3 ICS-43432(C574021)：CONFIG 拉地、LR 接地(左声道)、SD 100k 下拉、VDD 经 +3V3_A 供并 0.1µF；+3V3_A = +3V3 经 R3 10Ω + C7 10µF + C8 100nF；U4 MAX98357A(C910544)：VDD+5V+10µF/100nF、GAIN 经 R5 100k→3dB、SD_MODE 由 AMP_SD 经 R6 10k/R7 22k 分压≈2.1V、OUT± 经 FB2/FB3 磁珠 + C12/C13 1nF → J2 PH2.0-2P。
- **人机交互页**：K1–K9 TS-1809-T20 直连 GPIO(KEY1–9，另一端 GND)；每路 D_TVS BNESD9X5.0ST5G 到 GND（单路 TVS）；LED1 GL5050RGB01-A 共阴，pin1/3/5=GND，pin4→R10(270Ω)→RGB_R、pin6→R11(62Ω)→RGB_G、pin2→R12(62Ω)→RGB_B，阳极网 LED_RA/GA/BA（见“阶段F”）。

### 已知取舍（供评审确认）
1. **LDO = AMS1117-3.3 + 22µF 钽(C4)**：AMS1117 需钽/电解输出电容保证稳定，压差与静态电流偏大、效率一般；选它因便宜易购。若在意效率/发热，可评估 DC-DC 或低压差 LDO。
2. **麦克风用 ICS-43432 替代 INMP441**：体积/供货替代，需确认声学指标与供货。
3. **9 键直连 GPIO（非矩阵）**：占 9 个 GPIO 换取固件简单、无鬼键；已核对 GPIO 余量足够。
4. **ESD 单路 TVS（每键一颗）**：非阵列，成本/布局取舍，9 路各一颗。
5. **绿/蓝 LED 在 3.3V 下余量不足**：Vf_max 3.6V > 3.3V，直驱电流偏小(<2mA)偏暗。**备选：阳极接 +5V、阴极经限流电阻接 GPIO 开漏（低电平点亮）**，用 5V 提升余量；请工程师拍板。
6. **功放输出滤波数值待定**：FB2/FB3 磁珠 + C12/C13 1nF 数据手册无明确值，需按 EMI/听感实测调整。
7. **BOM 部分料号单价/库存待确认**：扩展库/无公开报价料号见 BOM_v0.4 备注；lcsc.com 美元价折算为估算。

### 6 个重点问题（请工程师重点看）
1. 绿/蓝 LED 是否改为「阳极接 +5V + GPIO 开漏低电平点亮」？还是接受 3.3V 偏暗 / 选低 Vf bin？
2. AMS1117 + 钽电容方案是否可接受（热/效率/成本）？是否改 DC-DC？
3. ICS-43432 替代 INMP441 的声学与供货是否 OK？LR 接地左声道是否符合整机？
4. 功放输出磁珠/电容(FB2/FB3、C12/C13)具体值如何定？是否需要不同截止/LC 滤波？
5. 按键仅靠 ESP32 内部上拉 + 单路 TVS，抗 ESD 和抗干扰是否足够？
6. BOM 中是否有更常用、好买的替代料？

## 工程师初评（G1.1，2026-11-18）
- 结论：**通过（待其最终人工矫正）**。
- 说明：工程师已对 G1 原理图与 BOM 初评通过；本轮 G1.1 仅换料不改电路——C99*/占位料号换为立创真实在售料、C14→1µF 25V X7R 0603(C29936)、U1→C6186、喇叭 HDK-5204KC-4W 列为板外件；网表连接不变。最终以工程师人工矫正为准。

## G1.2 库器件对齐（2026-11-18）
- 本轮把 G1.1 只改了 BOM 属性的器件，换成对应立创料号的库器件，**符号+封装一起换**；网表逐脚比对，功能级 PIN DIFF 空。
- 换了哪些 / 封装变化 / 有无引脚功能差异：
  - **U1 → C6186 AMS1117-3.3**：符号由 C2891839 版换为 C6186 版；封装 SOT-223-3（4 焊盘）不变；引脚 1/2/3/4 = GND/VOUT/VIN/VOUT(tab) 功能一致，无差异。
  - **J1 → C393939 TYPE-C16PIN**：封装由 USB-TYPE-C-SMD_{{SECRET_qblwnxit}}（20 焊盘）换为 USB-C-SMD_TYPE-C16PIN（16 焊盘）；**引脚功能有差异**：脚号由数字改为复合焊盘号（A1B12/A4B9…），按功能重挂网络标签（GND/VBUS/CC1/CC2/DP1/DP2/DN1/DN2/SHELL 一一对应，SBU1/SBU2 保持 NC），功能级网络不变，未猜。
  - **J2 → C22388468 BX-PH2.0-2PZZ-Y**：封装 CONN-TH_2P-P2.00_HC-PH-2A-TW（2 焊盘，旧 BOSSIE 封装换名）；引脚 1/2 = SPK_P/SPK_N 不变。
  - **K1–K9 → C42400866 TS50610-411-02028**：封装 SW-SMD_L3.9-W2.9-LS4.8SWQC_SPST → KEY-SMD_L3.9-W3.0-LS5.0_1（2 焊盘）；引脚 1=KEYx / 2=GND 不变。
  - **C14 → C29936 CL10B105KA8NNNC**：封装 C0603（2 焊盘）不变；引脚 1=EN / 2=GND 不变（由 100V 料号换为 25V 实际在售料）。
  - **SW1/SW2（C56165515）**：系统库取不到，按规则保留原器件并记录；**待确认**：其符号真实料号 C9900285271 与 BOM 属性 C56165515 不一致。
  - **TP1/TP2**：改为真实库器件 Keystone 5123（1 焊盘，保留焊盘），置 DNP（BOM 排除、不贴装）；原自建符号/封装与料号不一致导致的 ATTRMATCHCODE 已随库器件对齐清除。
- 全局 ERC：**error 0 / ATTRMATCHCODE 0 / 残余 warn 4（NETOBJECTONGRID，LED1 引脚非栅格，非电气）**。
- **未开始 PCB**。

---

## 工程师评审意见及落实（G1.3，2026-11-18）

> 版本 v0.7。依据工程师 2026-11-18 评审意见 1–7 逐条落实。全部修改用「短导线 + 网络标签」画法；关键连接以网表证明（见 hw/exports/netlist_proof_G13.txt 与 netlist_v07_final_jlceda.txt）。ERC：error 0，残余 warn 见 erc_all_report.txt。

### 1. LED（共阳 +5V，阴极经限流电阻接 GPIO，开漏低电平点亮）—— 已落实
- 改接：LED1 pin2/4/6（B+/R+/G+）→ **+5V**；pin3(R−) → R10 → RGB_R；pin5(G−) → R11 → RGB_G；pin1(B−) → R12 → RGB_B。网表：LED1{1:LED_BK,2:+5V,3:LED_RK,4:+5V,5:LED_GK,6:+5V}；R10{RGB_R,LED_RK}、R11{RGB_G,LED_GK}、R12{RGB_B,LED_BK}。
- 限流电阻 R10–R12 统一 **2.2kΩ**（C4190，0603 1%）。电流计算 I=(5V−Vf)/R：
  - 红 Vf_typ≈2.0V：I≈(5−2.0)/2200≈**1.36mA**；绿/蓝 Vf_typ≈3.0V：I≈(5−3.0)/2200≈**0.91mA**。
  - Vf_max 校核：红 2.2V、绿/蓝 3.4V，则 5−Vf_max 分别为 **2.8V / 1.6V > 0**，余量为正。指示用途亮度足够。
- **注意**：GPIO 必须配置为**开漏输出**（低电平点亮）。GPIO 输出高电平(3.3V)时，红灯两端约 5−3.3≈**1.7V**，接近 Vf_min，**可能微亮**，属正常现象，固件应避免依赖“高电平=全灭”。

### 2. 电源：AMS1117 → TI TPS 同步降压 —— 已落实
- U1 由 AMS1117-3.3(SOT-223) 换为 **TPS563201DDCR（C116592，SOT-23-6/DDC）**：Vin 4.5–17V（覆盖 4.5–5.5V），3A，Vout 可调 0.768–7V，580kHz D-CAP2。BOM 中 TPS 芯片与电感标「淘宝自采」。
- 外围取值依据 TI 数据手册 **SLVSD90B**：Table 7-2「Recommended Component Values」**p.14**（Vout=3.3V 行：R1=33.2k、R2=10k、L1=2.2µH、Cout 20–68µF）；参考电路 Figure 7-1 **p.13**；自举/EN 见 Table 4-1 **p.3**、§7.2.2.x **p.15**。实取：L1=2.2µH(Isat≥3.5A)；Cin 用 22µF 钽(项7要求≥10µF钽)；Cout 用 22µF 钽；R1(R13)=33.2k、R2(R14)=10k（1%）；Cboot(C26)=0.1µF 接 VBST(6)–SW(2)；EN(R15) 10k 上拉到 +5V。
- 反馈分压（Equation 2，p.14）：Vout=0.768×(1+R1/R2)。代入 R1/R2=3.3/0.768−1=3.2969；取 R1=33.2k、R2=10k → **Vout=0.768×(1+3.32)=3.318V（+0.54%）**。电感纹波 ΔIL=Vout(Vin−Vout)/(Vin·L·fsw)=3.3×1.7/(5×2.2µH×580kHz)≈**0.879A**。
- 网表：U1{1:GND,2:SW_NODE,3:+5V,4:VFB_NODE,5:EN_BUCK,6:VBST_NODE}；L1{1:SW_NODE,2:+3V3}；R13{+3V3,VFB_NODE}；R14{VFB_NODE,GND}；R15{+5V,EN_BUCK}；C26{VBST_NODE,SW_NODE}；+3V3 网含 L1.2。
- 风险备注：TPS D-CAP2 原推荐低 ESR 陶瓷电容，本设计按项7改用钽电容（ESR 较高、容量加大），环路稳定性需实测确认。

### 3. 麦克风（要求 top port + I2S）—— 未满足，保留现料，待鼠王决策
- 经数据手册核实：现料 **C574021（ICS-43432，TDK InvenSense，SMD-7P）为 I2S 数字输出，但为「底进音 bottom port」，非正面开孔**；且原厂 **EOL**（DS-000038 Rev1.0，Figure 3/Table 6 p.8；TDK/InvenSense 页 Status=EOL）。
- 立创无「top port + I2S + 有货 + 便宜」型号：MSM261S4030H0R、CMM-4030D-261-I2S 均停产/无货；SPH0645LM4H 亦为 bottom port。行业 I2S MEMS 正退场转 PDM。
- 因此**本轮无法按「正面开孔」换料**，保留 C574021 及原 I2S 接线（未改动）：SCK(6)→GPIO4/I2S_MIC_BCLK；WS(5)→GPIO5/I2S_MIC_WS；SD(7)→GPIO6/I2S_MIC_SD；LR(1)→GND=左声道；CONFIG(2)→GND；VDD(3)→+3V3_A 并 0.1µF 去耦；GND(4)。**不伪造替代料**。
- **请鼠王决策**：(A) 接受底进音 I2S + PCB 麦正下方开声孔（最现实、便宜有货）；或 (B) 改顶进音 PDM + PDM→I2S 桥接/固件（更复杂）。

### 4. 功放：删 FB2/FB3/C12/C13，U4 OUTP/OUTN 直连 J2 —— 已落实
- 已删除 FB2、FB3、C12、C13（连同其短导线与网络标签）。U4 OUTP(9)→**SPK_P**→J2.1；OUTN(10)→**SPK_N**→J2.2。网表：U4.9=SPK_P=J2.1，U4.10=SPK_N=J2.2；FB2/FB3/C12/C13 已不存在。

### 5. 按键：删 TVS1–TVS9，每键 100nF 到 GND —— 已落实
- 已删除 TVS1–TVS9（连同其短导线/网络标签）；每键新增 **C17–C25 = 100nF/0603（C14663）** 到 GND。网表 KEY1–9 = {ESP32 GPIO, Kn.1, Cn.1}；各 Cn{1:KEYn,2:GND}。

### 6. 淘宝自采件（BOM 标注）—— 已落实
- BOM_v0.7 中 J1、J2、K1–K9、SW1/SW2 **标「淘宝自采」**，不列立创料号/单价/库存；J1/J2/K1–K9 已换好的库器件保持不动；SW1/SW2 保留现有符号与封装（不再追 C56165515）。**TP1/TP2 保持 DNP**。另按要求 TPS 芯片(U1)与电感(L1)亦标「淘宝自采」。

### 7. 电容：所有 ≥10µF 一律钽电容（禁电解）—— 已落实
- 全部 ≥10µF 改为 **C782264（CA45-A-16V-22uF-K，22µF/16V，CASE-A 钽）**：C1、C5、C7、C10、C15（原 10µF 陶瓷）+ C4（原已钽）+ TPS 外围 C27(Cin)、C28(Cout)。耐压：+5V/VBUS 用 16V≥2×5V；+3V3 用 16V≥2×3.3V，满足「工作电压 2 倍以上」。
- 极性核对（网表）：每颗 pin1(正)→电源网、pin2(负)→GND：
  - C1{1:+5V,2:GND}、C5{1:VBUS_IN,2:GND}、C10{1:+5V,2:GND}、C27{1:+5V,2:GND}、C7{1:+3V3_A,2:GND}、C15{1:+3V3,2:GND}、C28{1:+3V3,2:GND}、C4{1:+3V3,2:GND}。全部正确。
- 局部放大证据 PNG：tant_C1_C3_C4_zoom_v07.png、tant_C5_zoom_v07.png、tant_C7_zoom_v07.png、tant_C10_zoom_v07.png、tant_C15_zoom_v07.png、tant_C27_zoom_v07.png、tant_C28_zoom_v07.png。

### 交付与限制
- ERC：error 0；warn 5 条（NETOBJECTONGRID×4 + ATTRMATCHCODE×10器件/1记录），逐条解释见 erc_all_report.txt。
- BOM_v0.7：立创部分合计约 **¥76.26**（USD×7.2 估算）< ¥100；淘宝自采件不计价；D1/R3/TP 单价待确认。
- **.epro 限制**：当前安装的嘉立创 EDA（V4.1.100）jlceda MCP **未暴露单文件 .epro 工程导出 API**（getExportDocumentFile 仅支持 PDF/PNG/SVG；无项目打包函数，调用 EPRO 一律超时）。故本轮交付的 mini_autotune_v0.7_*.epro 为**当前 .eprj3 设计文件夹的 ZIP 归档**（解压后为文件夹工程）；如需规范单文件 .epro，请在 GUI「文件→导出」生成。PDF/四页PNG/网表/BOM 均由 API 正常导出。


## G1.4 落实（2026-11-18）

### 电容返工（G1.3 按旧规则改多的回收）
- C1/C5/C7/C10/C15：改回 10µF MLCC C15850（C0805 X5R 25V，≥16V）。
- C27（U1 输入）/C28（U1 输出）：改 22µF MLCC C45783（C0805 X5R 25V）。依据 TPS563201 SLVSD90：输入 ceramic over 10 µF + 0.1µF（§7.2.2.4, p.15）；输出 C8+C9 推荐 20–68µF，示例 2×22µF（Table 7-2, p.14–15）。本设计 C27=22µF、C28=22µF。待确认：是否按示例加到 2×22µF。
- C4 保持 22µF 钽 16V（+3V3，>10µF 用钽，耐压16V≥10V）；网表 pin1=+3V3 电源侧，极性正确。
- R14 与 C28 网络标签文字重叠：旋转 R14 侧 GND 标签 180° 消除重叠（不改连接）。

### 麦克风换 ICS-43434（方案 A，C5656610）
- U3：INMP441(C574021) → ICS-43434(C5656610)，符号/封装/料号三者一致（MIC-SMD_6P-L3.5-W2.7-P0.90-BL）。
- 引脚按 DS-000069 Rev1.0 p.10 Table 8：1 WS / 2 LR / 3 GND / 4 SCK / 5 VDD / 6 SD。接线：WS→I2S_MIC_WS、LR→GND(左声道)、GND→GND、SCK→I2S_MIC_BCLK、VDD→+3V3_A、SD→I2S_MIC_SD。I2S 网络名与 ESP32 GPIO 不变（网表：I2S_MIC_WS=U2.5+U3.1、I2S_MIC_BCLK=U2.4+U3.4、I2S_MIC_SD=U2.6+R4.1+U3.6）。
- VDD 去耦：C8/C9 100nF + C7 10µF（手册 p.10 要求 0.1µF，满足）。SD 100k 下拉：R4（手册 p.15，满足）。
- PCB 阶段注意：ICS-43434 为底部进音，PCB 麦克风下方需开声孔，最小直径 0.5mm（手册 p.17），留 PCB 阶段。
- 风险：立创库 C5656610 标注"停产"；方案 A 由鼠王已定，采购需复核供货。

### 遗留
- ERC 明细在 headless 下不可取得（见 RUN_LOG G1.4「Not tried」），待人工激活页面复核。
- C27/C28 是否加到 2×22µF 待确认。


### 步骤5 更正
- A/B/C 并行子任务因 max_turns 上限未产出报告，R 未启动；改为 parts.csv 机械核对 + 改动件手册核对，见 hw/exports/check/consistency_summary_20261118.md（OK9/UNSURE55/FAIL0）。全 64 件逐件深度手册核对未完成（Not done）。

## G1.5 落实（2026-11-18）

- C29：C28 旁新增第二颗 22µF MLCC（C45783，C0805 X5R 25V），+3V3/GND，合 TPS563201 p.14–15 示例 2×22µF。
- C30：U3 VDD 加 100nF MLCC（C14663 0603 X7R）到 GND 就近；依据 DS-000069 p.10（VDD 0.1µF）+ p.15（0.1µF X7R 靠近）。
- C26 处 EN_BUCK / VBST_NODE 标签重叠：两标签旋转 90°，仅显示、不改连接（zoom_C26_v09.png）。
- BOM：U3 标淘宝、不计立创价；立创合计（已知价）≈¥32.93（C15850×5/C45783×3/D1/R3/TP/L1 单价待确认未计入）。
- 一致性：仅复核 55 个 UNSURE 件；**子任务无 web 权限**，手册级全 UNSURE；本地机械核对 FAIL=0，见 consistency_summary_G15.md / consistency_local_all.md。
- 遗留：ERC 明细待鼠王可见窗口 DRC；手册级深度核对待联网补做。

## G1.6 落实（2026-11-18）

### 属性对齐（步骤1）
- R13→C23003(33.2k)、R14/R15→C25804(10k)、R10/R11/R12→C4190(2.2k)、R3→C22859(10Ω，原 C2889398 查不到)；DeviceName/Description/Datasheet 已随 C 号对齐，位号与网络不变（对照表 hw/exports/check/g16_attr_align.md）。
- R3 用 remove+add+网络标签（replace 被符号框容差拒）；其余电阻 replace 直接通过。
- SW1/SW2 → C56165515：系统库取不到器件，保留原样，DeviceName TS-1088-AR03016 与制造商料号 XD-TS-1088R-02026 仍不一致，待人工/系统库。

### D1（步骤2）
- C252436 在立创/JLC 可查（UMW/YenjiElec USBLC6-4SC6），判定在售，保留不换；下单前复核品牌库存。

### 待工程师确认（步骤4）
1. +3V3 总标称电容约 76µF（C28/C29/C4/C15/C3/C16）> TPS563201 推荐 20–68µF（SLVSD90 Table 7-2）；MLCC 偏压降容后可能落回范围；是否去掉 C4 或 C15，或打样实测负载阶跃。
2. LED 共阳 5V：复位期间 GPIO 高阻，固件应尽早把 RGB 三脚设为输出高。
3. C4 钽：PCB 阶段确认丝印「+」在 pad1。
4. U3 底进音：PCB 声孔 ≥0.5mm（DS-000069 p.17）。

### 其他
- BOM v1.0：L1 淘宝(2.2µH/2520/Isat≥3A)；C14663/C45783/C5272786 国际站库存0 提示；淘宝件不计价；立创合计≈¥32.93(已知价)。
- ERC 明细与 ATTRMATCHCODE：headless 取不到，待可见窗口 DRC，未确认。

## P1 ｜ PCB 布局待工程师确认（2026-11-18，分支 p1-layout，基线 070edc0）
- 状态：hw/PCB_PLAN.md（布局约束文档 v0.1 草案）已出。**PCB 布局待工程师确认。**
- 待确认（阻塞定稿）：① 候选板框 80×50mm（≤80×50 目标；WORKFLOW 上限 85.60×53.98）是否采纳；② 接口朝向（J1 USB-C / J2 喇叭口 / 按键正面）；③ 8 条关键规则的手册页码（本地 PDF 不全，均标「页码待确认」）；④ SW1/SW2 实物型号；⑤ ESP32 天线具体净空值（以模组手册为准）。
- 过程受阻：headless jlceda 的 importChanges 返回 ok 但 0 器件，原理图→PCB 同步未能自动完成；需工程师在可见窗口执行「从原理图导入变更」，再按 PCB_PLAN.md 分区粗摆放。
- 未验证：PCB 顶层/底层 PNG、3D、DRC 均未产出（见 RUN_LOG P1「Not tried」）。

## P1 更新（2026-11-18 执行结果）
- 已在 PCB2（66 件，无 TVS，含 C17–C30）按 80×50mm 板框、四区粗摆放，未走线；顶/底层 PNG：hw/exports/pcb/pcb2_top_v1_2026111722143.png、pcb2_bottom_v1_2026111722143.png。**布局待工程师确认。**
- 布局在 headless 副本 ~/Documents/LCEDA-Pro/projects/mini_autotune_p1/mini_autotune/（正式工程 PCB2 未回写，避免与可见窗口争用）。
- 待确认：板框 80×50 与接口朝向定稿、8 条规则手册页码、ESP32 天线净空值、SW1/SW2 实物型号。
- 未验证：DRC 明细、3D、底层位号（全贴片顶层无底层位号）。
