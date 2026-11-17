# RUN_LOG（无人值守执行日志）

执行日期：2026-11-17（Asia/Shanghai）

## 阶段完成情况
- 阶段1 电源页收尾：**完成**。删除 J1 上未用的 SBU1/SBU2 NC 视觉冲突（移出 GND 脚区域），确认 GND 未连 SBU1；导出整页 power_page.png + 局部放大 power_page_J1_zoom.png。commit e606542。
- 阶段2 主控页整理：**完成**。U2 左/底部引出线加长（rot=180/270 → L=50），网络名不再压引脚名；REVIEW_NOTES.md 记录 U2 删 IO35、J1 换符号原因。commit c5d310a。
- 阶段3 音频页：**基本完成，有 1 残留**。已按 §1.3/§6 放置并接线：麦克风 ICS-43432（CONFIG 接地、LR 接地、SD 经 100k 下拉、VDD 接 +3V3_A 并 0.1µF）；+3V3_A 由 +3V3 经 10Ω+10µF+100nF；MAX98357A（VDD+5V、10µF+100nF、GAIN 100k 接 VDD=3dB、SD_MODE 由 AMP_SD 经 10k/22k 分压、OUT±经磁珠+1nF 到 J2）。导出 audio_page.png。**残留**：1 条 ONENETNAME（SD_MODE 网络重名，未完全合并）。commit 8916c7f。
- 阶段4 人机交互页：**未执行**（未画 9 键/ESD/RGB）。
- 阶段5 全局 ERC 清零 + 网表核对 GPIO：**未执行**（因阶段4未画，全局不可能清零；网表核对未做）。
- 阶段6 BOM：**部分**。已导出 BOM_v0.3_20261117-2156.csv（含已画三页；缺人机交互页，故不完整）；总价与超预算风险、缺货标签**未完成核对**（BOM 无单价列，需逐料核价）。
- 阶段7 评审包：**部分**。已导出 .epro（mini_autotune_v0.3_20261117-2156.epro，130489B）与整册 PDF（sch_all_v0.3_20261117-2156.pdf，172798B）；REVIEW_NOTES 已建但未含人机交互页要点；docs/REVIEWS.md 的 RV-G1-001 **未写入**（G1 未完成）。

## 停止原因（如实）
本次无人值守执行在完成阶段1–3后，受**执行资源/时间上限**限制，未能继续完成阶段4–7。**未发生**权限拒绝、工具连续 3 次报错、或关键数据手册查不到的情形（属资源上限，不是上述三类阻断）。按诚实原则不伪造未完成内容。

## 未解决项清单
1. 人机交互页未画（9 键+ESD 阵列+RGB+限流电阻）。
2. 音频页 SD_MODE 网络重名（ONENETNAME×1）未消除。
3. 全局 ERC 未清零；网表未核对 SCHEMATIC_PLAN §3.2 GPIO 表。
4. BOM 不完整、无单价列，未算总价/超预算/缺货标注。
5. docs/REVIEWS.md RV-G1-001 未添加；G1 未达评审条件。
6. 个别新料号（J2 C9900095162、R3 C2889398 等）库存/单价未核实。

## 数据手册引用（阶段3）
- ICS-43432 Datasheet，Document DS-000038 Rev1.0，**Page 8 of 20（TABLE 6 PIN FUNCTION DESCRIPTIONS）**：`2 CONFIG Input Pull to ground. The state of this pin is used at power-up.`；`3 VDD Power, 1.62 to 3.63 V ... decoupled to GND with a 0.1 μF capacitor.`；`7 SD ... 100 kΩ pull down resistor ...`；`1 LR ... When set low ... left channel ...`
- MAX98357A Datasheet（ADI）：GAIN 引脚 100kΩ→VDD = 3 dB（Gain Settings / ADI 设计笔记 GAIN_SLOT 表）；SD_MODE 绝对阈值 B2≈1.4 V（>1.4V=左声道），5V 供电时 3.3 V 逻辑兼容（Datasheet p.7/p.18）。SD_MODE 分压：AMP_SD(3.3V) 经 R6=10k、R7=22k 下拉 → 3.3×22/(10+22)=2.27 V > 1.4 V（开），AMP_SD=0 时 0 V（关）。输出滤波磁珠+电容的具体数值**数据手册未给明确值 → 待确认**。

## 2026-11-18 续跑（步骤A）
- 步骤A 修音频页 SD_MODE ONENETNAME：连续 4 次尝试（重连后重画 SD_MODE 网、改名 AMP_SDMODE、改走线避让 R5/电源网络），DRC 仍报 ONENETNAME，且新走线反复与 GAIN / +5V / GND 网络合并（音频页布局过密、走线空间不足）。按「同一工具/同一问题连续多次未清除」停在步骤 A。
- 步骤 B–E 未开始。
- 数据手册：MAX98357A SD_MODE 内部下拉约 100kΩ（见 ds-pins 核查，Datasheet p.7/p.18）；分压重算：R7=22k ∥ 内部100k = 18.03k，V=3.3×18.03/(10+18.03)=2.12V>1.4V（若 AMP_SD=3.3V）。输出滤波磁珠+电容具体值数据手册未给明确值 → 待工程师确认。

## 2026-11-18 步骤A 完成（音频页 SD_MODE 修复）
- 人工确认根因：R5 输出贯通线经 U4 pin1-4 的竖线，把 DIN/GAIN_SLOT/GND/SD_MODE 与 GAIN(+5V 经R5) 短成一网。已删除音频页全部 46 根导线及多余连接点。
- 改法：全音频页「短导线(10) + 网络标签」，器件之间不拉长线。DRC 音频页 = 0 条。
- 网表(PADS)证据：GAIN={U4.2,R5.2}；SD_MODE={U4.4,R6.2,R7.1}；+5V={U4.7,U4.8,R5.1,C10.1,C11.1,FB1.2,U1.3,C1.1,C2.1}；I2S_AMP_DIN={U2.17,U4.1}；GND 含 U4.3/U4.11/U4.15/U4.17 且未与 SD_MODE 混。
- SD_MODE 分压复算：MAX98357A SD_MODE 内部下拉约 100kΩ（Datasheet p.7/p.18）；R7=22k∥100k=18.03kΩ；V=3.3×18.03/(10+18.03)=2.12V > 1.4V。
- 输出滤波磁珠+电容具体数值：数据手册未给明确值 → 待工程师确认。
- FB2/FB3：输入端 OUTP(U4.9)/OUTN(U4.10)，输出端 SPK_P/SPK_N 接 J2.1/J2.2。

## 2026-11-18 步骤B（人机交互页）— 未完成（预算边界停止）
- 已在 HMI 页放置器件：K1–K9(TS-1088-AR03016/C9900285271)、ESD1–ESD3(USBLC6-4SC6/C252436 4路阵列×3，覆盖12路)、LED1(GL5050RGB01-A/C51933351，6脚)、R_R(270Ω 0603/C22966)。R_G/R_B 62Ω 已定位候选(C245989 RC0603FR-0762RL 等)。
- 未完成：LED 6 脚映射（R/G/B/共阴）待确认，故未接线；未跑 HMI ERC；未导出 hmi_page.png。
- 计划画法：短导线+网络标签（按要求，不拉长线）。K_i pin1=KEYi、pin2=GND；ESD 通道接 KEY、GND/VBUS 接 GND/+3V3；RGB 限流 R_R=270Ω(红,If5mA,Vf~2.0→(3.3-2.0)/0.005=260→270)、R_G/R_B=62Ω(绿蓝,If5mA,Vf~3.0→60→62)。
- 停止原因：执行预算到边界（非权限/工具3连错/数据手册缺参）。C/D/E 未开始。

## 2026-11-18 步骤B — 未通过（连续3次ERC未清零，停止）
- 已删除 ESD1–3(USBLC6-4SC6)，改用单路 TVS：**BNESD9X5.0ST5G (C19077972)**，DFN1006-2(0402级)、5V 单路 ESD，库存 6980、¥0.0112；每路 KEY1–9 各一颗 TVS 到 GND。LED1=GL5050RGB01-A(C51933351)；R_R=270Ω(C22966)、R_G/R_B=62Ω(C245989)。
- LED 引脚/ Vf：立创 C51933351 属性 Vf 红 2.0–2.3V、绿 2.9–3.2V、蓝 2.9–3.2V；共阴极。引脚 6 脚成对(1/6,2/5,3/4)，规格书未给出到具体色的脚位映射 → 采用假设「左 1/2/3=红/绿/蓝阳极，右 6/5/4=共阴接 GND」，**待工程师按规格书确认**。
- 限流：红 Vf_ty2.0,If5mA→R=(3.3-2.0)/0.005=260→E24 270Ω（Vf_max2.3→If≈3.7mA OK）。绿/蓝 Vf_ty≈3.0→R=(3.3-3.0)/0.005=60→62Ω；但按 Vf_max=3.2V：If=(3.3-3.2)/62≈1.6mA<2mA；若 Vf_max=3.4V 则几乎不导通 —— **3.3V 下绿/蓝电流余量不足，不硬凑，交工程师定**。备选：①绿蓝选低 Vf bin；②降到 If≈2mA(仍偏暗)；③改用 5V 供电+恒流/驱动管；④换共阳+低边驱动。
- 3 次 ERC 尝试均未清零：ONENETNAME×8(GND、KEY2..KEY9 短接，疑按键符号两脚过近/短接) + NETOBJECTONGRID×4(LED 标签不在栅格)。按规则停止，未导出/提交 hmi_page.png。
- 停止原因：同一页连续 3 次失败（非权限/工具3连错/数据手册缺参）。C/D/E 未开始。

## 2026-11-18 步骤B — 停在 LED 引脚映射（按指令：读不出规格书引脚图则停、不假设）
- 按键符号/键距/TVS 可改（授权已给），但 LED 映射先卡住。
- **规格书核查**：GL5050RGB01-A 规格书 PDF（汕头市桂光光电，8 页，https://atta.szlcsc.com/upload/public/pdf/source/20260724/2AD0E65AB149FA69EB06237A1CAB7351.pdf）：
  - 第 1 页：产品型号「GL5050RGB01-A 红 翠绿 蓝 RGB **共阴**」。
  - 第 3 页「电性参数」：Vf（IF=20mA）**红 1.8–2.6V、绿 2.8–3.6V、蓝 2.8–3.6V**。
  - **第 2 页「外观与尺寸」含封装/极性图为图片，文本层无「引脚编号→R/G/B 阳极/阴极」映射表**；8 页文本中无 Pin Configuration 表。→ **无法从规格书可靠读出 6 脚到色的映射，按指令停止，不用假设接线**。
- 限流（若按共阴 3.3V、If=5mA）：红取 Vf_nom≈2.2V→R=(3.3-2.2)/0.005=220Ω(E24；Vf_max2.6→If≈3.2mA 可)；绿/蓝 Vf_nom≈3.2V→R≈20Ω，但 **Vf_max=3.6V>3.3V → 几乎不导通/余量不足**，不硬凑。
- 备选（交工程师定）：改**共阳 LED + 5V 供电 + GPIO 低电平灌电流**（或 5V+恒流驱动管/低 Vf bin）。
- 步骤B 未完成（LED 未接线、未导出 hmi_page.png）；C/D/E 未开始。

## 2026-11-18 步骤B1 完成（按键+TVS）
- 按键换 TS-1809-T20(C9900021414, 2脚 pin1左/pin2右)；K1–K9 竖向一列、键距 60(6格)；TVSn=BNESD9X5.0ST5G(C19077972) 置于键旁；每脚短线20+网络标签，pin1左标KEYn、pin2右标GND，全部端点/标签在10栅格。HMI ERC 相关条目 0。
- 网表(PADS)证据：KEY1={U2.18,K1.1,TVS1.1}; KEY2={U2.19,K2.1,TVS2.1}; KEY3={U2.20,K3.1,TVS3.1}; KEY4={U2.21,K4.1,TVS4.1}; KEY5={U2.22,K5.1,TVS5.1}; KEY6={U2.8,K6.1,TVS6.1}; KEY7={U2.9,K7.1,TVS7.1}; KEY8={U2.10,K8.1,TVS8.1}; KEY9={U2.11,K9.1,TVS9.1}。
- 导出 hmi_page_keys.png。

## 2026-11-18 步骤B2 完成（LED 占位）
- LED1(GL5050RGB01-A/C51933351) 已放置、引脚暂不接线（引脚映射待规格书封装图确认，见 REVIEW_NOTES）。
- R_R/R_G/R_B 已放置：一端网络标签 RGB_R/RGB_G/RGB_B（=GPIO38/39/40，与主控页 U2 网络同名连接），另一端悬空待 LED 接线。
- HMI 残余 ERC：CHECKFLOATPIN×1（LED1 各脚 + 电阻悬空端，属“LED 待接线”，按规则不算失败）。全局 ERC 仅此 1 条。

## 2026-11-18 步骤B2 正式接线（LED，映射已人工确认）
- 规格书 p.2 极性图确认：pin1=B-、pin2=B+；pin3=R-、pin4=R+；pin5=G-、pin6=G+（颜色非顺序对应！）。
- 接法：pin1/3/5→GND；pin4(R+)→R_R(270Ω)→RGB_R(GPIO38)；pin6(G+)→R_G(62Ω)→RGB_G(GPIO39)；pin2(B+)→R_B(62Ω)→RGB_B(GPIO40)。（注：GPIO 网名沿用主控页 RGB_R/G/B，对应你所说 LED_R/G/B=GPIO38/39/40。）
- HMI 残余 ERC：NETOBJECTONGRID×4（LED 符号引脚坐标非栅格 ±19/21 所致，标签已对齐栅格；属库符号栅格问题，非电气）。
- 导出 hmi_page.png。

## 2026-11-18 F 插队修复（LED1 蓝灯反接）— 完成
- 症状：人工读图发现 LED1 中间那路（蓝）二极管阴极接 B_K、阳极接 GND，蓝灯反接。
- 网表证据（修复前，GL5050RGB01-A / C51933351）：LED1.1=GND, .2=B_K, .3=GND, .4=R_K, .5=GND, .6=G_K；R10(270Ω).1=RGB_R/.2=R_K，R11(62Ω).1=RGB_G/.2=G_K，R12(62Ω).1=RGB_B/.2=B_K。
- 库符号引脚图形位置（符号本地坐标，10mil/0.01in，y 上为正）：pin1 左(-19,30)、pin2 左(-20,6)、pin3 左(-19,-16)、pin6 右(20,30)、pin5 右(20,6)、pin4 右(21,-16)。三只二极管按行绘制：上行 pin1–pin6、中行 pin2–pin5、下行 pin3–pin4。
- 根因：库符号（project 库 2fab92e94ff31362）**中行二极管方向画反**——阴极在 pin2(B+) 侧、阳极在 pin5(G−/GND) 侧；而按规格书 p.2，pin1/3/5=阴极(−)、pin2/4/6=阳极(+)。上/下行方向本正确，仅中行反。
- 修复：翻转符号中行二极管图形（POLY e14/e15 关于 x=0 镜像：阴极由左(pin2)改到右(pin5=GND)，阳极由右(pin5)改到左(pin2=B+)），即蓝灯正向。仅改符号图形，引脚号与网络不变，电气/网表不受影响。
- 按规格书 p.2 以引脚号为准复核：pin1/3/5→GND；pin4→R10→RGB_R；pin6→R11→RGB_G；pin2→R12→RGB_B —— 原接线即符合，无需改引脚。
- 网络名 R_K/G_K/B_K → LED_RA/LED_GA/LED_BA（阳极侧网）。
- 修复后网表证据：LED1.1=GND, .2=LED_BA, .3=GND, .4=LED_RA, .5=GND, .6=LED_GA；R10.1=RGB_R/.2=LED_RA；R11.1=RGB_G/.2=LED_GA；R12.1=RGB_B/.2=LED_BA。
- 全局 ERC：error 0 / warn 4（均 NETOBJECTONGRID，LED 引脚非 10 栅格；与修复前基线一致，未新增错误）。
- 导出 hmi_page.png(3200×2731)、hmi_led_zoom.png(1600×987，框住 LED1+R10/R11/R12)。

## 2026-11-18 D ｜ BOM v0.4 — 完成
- 从 jlceda 四页整册导出完整 BOM（含 61 个器件、25 条料号），文件名 BOM_v0.4_20261118-0220.csv。
- 新增列：单价(USD)、单价(¥,估算)、库存、来源URL、备注。
- 价格/库存来源：lcsc.com（LCSC/立创）公开产品页 JSON-LD（SKU/price/availability/inventoryLevel）。国内 szlcsc.com 人民币价与库存接口受 ACL 限制（403），程序无法读取 → 标「待确认」。
- 结果：16 条料号取得报价（41 个器件），合计 10.1915 USD ≈ ¥73.38（按 1 USD≈7.2 CNY 估算，汇率待确认）；9 条料号（1nF/1µF 电容、USBLC6-4SC6、USB-C 座、PH2.0-2P、TS-1809 按键、10Ω、TS-1088 开关、测试点等扩展库/无公开报价料号）无公开报价 → 单价/库存标「待确认」。
- 对照 ¥100：已明确项 ¥73.38，明显低于 ¥100；待确认 9 条均为低价无源/连接器/开关/测试点/USBLC6/扩展库料，预计合计 <¥5；结论预算内（补齐 9 项 ¥价后定稿）。
- 缺货/停产：已取得报价的 16 项在 lcsc.com 均 InStock、库存>0；C252436(USBLC6-4SC6) 等未取到公开报价，是否停产待确认。

## 2026-11-18 E ｜ 评审包 — 完成（未开始 PCB）
- 音频页：将 U3/U4 左侧网络标签外移（不再压引脚号/名）；R6→R7 的 SD_MODE 由原“同名网络标签”改为一段短导线直连（R6.2↔R7.1，网表确认同一 SD_MODE），重复标签移至画布外消除网络别名；重导 audio_page.png(3200 宽)；audio_amp_zoom.png 真正框住 U4 + R5 + R6 + R7。
- 导出 mini_autotune_v0.4_20261118-0220.epro（epro 格式，109806B）。
- 导出四页 PNG：power_page.png / main_page.png / audio_page.png / hmi_page.png（均 3200 宽）。
- 导出整册 PDF：sch_all_v0.4_20261118-0220.pdf（4 页）。
- REVIEW_NOTES.md 补全：设计目标、四页要点、已知取舍（AMS1117+钽、ICS-43432、9 键直连、单路 TVS、绿/蓝 3.3V 余量不足及“阳极接+5V/开漏”备选、输出滤波数值待定）、5 个重点问题。
- docs/REVIEWS.md 新增 RV-G1-001（待 Claude B 预审 / 待工程师终审）。
- 全局 ERC 复核（E 完成后）：error 0 / warn 4（4 条均 NETOBJECTONGRID，在 HMI 页 LED1 引脚非 10 栅格；与基线一致，未新增错误）。
- 全部 commit+push；**未开始 PCB**。

## 2026-11-18 G1.1 ｜ BOM 清理（只换料不改电路）— 完成
- 换料（供应料号→立创真实在售，均保持原符号/封装/引脚；网表连接逐项比对不变）：
  - J1 USB-C → **C393939** SHOU HAN TYPE-C16PIN（16P 卧贴 SMD）
  - J2 → **C22388468** Bossie BX-PH2.0-2PZZ-Y（PH2.0 2P 直插）
  - K1–K9 → **C42400866** HMTCONN TS50610-411-02028（轻触开关 3.9×2.93 SMD，SPST）
  - SW1/SW2 → **C56165515** chxunda XD-TS-1088R-02026（轻触开关 3.9×3.0 SMD）
  - TP1/TP2 → **C5272786** Keystone 5123（测试点 3.2mm 通孔）
  - C14 → **C29936** SAMSUNG CL10B105KA8NNNC（1µF ±10% 25V X7R 0603，≥16V 达标，库存 401.9 万）
  - U1 AMS1117-3.3 → **C6186**（AMS 原厂，SOT-223，1A，库存 87.8 万；理由：经典在售、库存充足、SOT-223 与现封装一致）
- 换料后核验：17 个目标器件引脚-网络与换料前逐项比对**完全一致（PIN DIFF 空）**；BOM 中 C99*/占位料号清零。
- 喇叭 **HDK-5204KC-4W**（C=C53325602，Dragonstate 华龙，4Ω 3W 圆形）作为**板外件**写入 BOM（不贴板、不占 PCB）。
- 重导 **BOM_v0.5_20261118-0302.csv**：25 条板内料 + 1 条板外喇叭；单价/库存/来源 URL 均已填（国内 szlcsc ¥价/库存受 ACL 限制标待确认）。
- 总价：已明确单价合计 **$11.7536 ≈ ¥84.63**（按 1 USD≈7.2 估算，汇率待确认），对照 ¥100 **预算内**；待确认 3 条（1nF C2940049 / USBLC6 C252436 / 10Ω C2889398）均低价无源；**缺货**：TP 测试点 C5272786（lcsc.com 库存 0），建议核实国内现货或换替代。
- 全局 ERC：error 0 / warn 5（原 4 条 NETOBJECTONGRID 在 HMI LED；新增 1 条 ATTRMATCHCODE(U1)——因只换 BOM 属性未换库器件，属属性一致性提示，非电气错误；网表未变）。
- REVIEW_NOTES：第 5 问改为「按键仅靠 ESP32 内部上拉 + 单路 TVS，抗 ESD 和抗干扰是否足够？」；新增第 6 问「BOM 中是否有更常用、好买的替代料？」；新增「工程师初评：通过，待其最终人工矫正」节。
- 导出 mini_autotune_v0.5_20261118-0302.epro、四页 PNG、整册 PDF；commit+push。**未开始 PCB**。

