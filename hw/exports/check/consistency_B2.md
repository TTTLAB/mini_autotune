# G1.5 器件一致性核对报告 B2（只读）

核对范围：18 个位号。判定标准：料号存在/引脚数=焊盘数=手册引脚数/封装尺寸/极性与电源脚映射/BOM 料号一致。
数据源：`hw/exports/check/parts_20261118-0410.csv`、`hw/exports/netlist_v08_20261118-040633.json`、`hw/exports/check/check_g15_fix3.md`。

> **阻塞说明（重要）**：本会话 web 检索工具权限未授予，datasheet.lcsc.com / 厂商手册均无法访问。
> 因此凡需手册才能判定的项（料号在立创的真实存在性、手册引脚数、封装尺寸、电源/地/极性映射）一律标 UNSURE，
> 依据栏写「未能获取手册（web 检索权限未授予）」。网表只能证明工程内部一致，不能替代手册。
> 本地可判项已全部核对：网表 `props.Supplier Part` vs parts.csv 料号、`pinInfoMap` 条目数 vs 符号焊盘数 vs 封装焊盘数。

## 逐位号核对表

| 位号 | 判定 | 依据 |
|---|---|---|
| SW2 | UNSURE | 料号 C56165515（parts.csv=网表 props 一致）；pinInfoMap 2 条=焊盘 2（1=BOOT，2=GND）；符号名 TS-1088-AR03016 与封装名 TS-1088-AR02026、厂商料号 XD-TS-1088R-02026 命名不一致，需手册确认是否同族同尺寸；未能获取手册（web 检索权限未授予） |
| TP1 | UNSURE | 料号 C5272786（parts.csv=网表一致）；pinInfoMap 1 条=焊盘 1（1=U0TXD）；封装 TP-TH_5123 与 Keystone 5123 命名内部相符；未能获取手册（web 检索权限未授予） |
| TP2 | UNSURE | 料号 C5272786（parts.csv=网表一致）；pinInfoMap 1 条=焊盘 1（1=U0RXD）；封装 TP-TH_5123 与 Keystone 5123 命名内部相符；未能获取手册（web 检索权限未授予） |
| U2 | UNSURE | 料号 C2913202（parts.csv=网表一致）；pinInfoMap 41 条=焊盘 41；关键脚网表值：1=GND、2=3V3@+3V3、3=EN、37=TXD0@U0TXD、40=40=GND@GND、41=GND；封装 WIRELM-SMD_ESP32-S3-WROOM-1；41 脚（含 EP）及电源/地定义待手册确认；未能获取手册（web 检索权限未授予） |
| C8 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=+3V3_A，2=GND）；C0603 与器件名 CC0603KRX7R9BB104 的 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| C9 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=+3V3_A，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| C11 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=+5V，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| J2 | UNSURE | 料号 C22388468（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=SPK_P，2=SPK_N）；封装 CONN-TH_2P-P2.00 与 BX-PH2.0-2P 命名内部相符；未能获取手册（web 检索权限未授予） |
| R3 | UNSURE | 料号 C2889398（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=+3V3，2=2=2@+3V3_A）；R0603 与器件名“0603 ±5% 10Ω”内部相符；未能获取手册（web 检索权限未授予） |
| R4 | UNSURE | 料号 C25803（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=I2S_MIC_SD，2=GND）；R0603、100kΩ 与料号 0603WAF1003T5E 内部相符；未能获取手册（web 检索权限未授予） |
| R5 | UNSURE | 料号 C25803（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=+5V，2=GAIN）；R0603、100kΩ 与料号 0603WAF1003T5E 内部相符；未能获取手册（web 检索权限未授予） |
| R6 | UNSURE | 料号 C25804（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=AMP_SD，2=SD_MODE）；R0603、10kΩ 与料号 0603WAF1002T5E 内部相符；未能获取手册（web 检索权限未授予） |
| R7 | UNSURE | 料号 C31850（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=SD_MODE，2=GND）；R0603、22kΩ 与料号 0603WAF2202T5E 内部相符；未能获取手册（web 检索权限未授予） |
| U4 | UNSURE | 料号 C910544（parts.csv=网表一致）；pinInfoMap 17 条=焊盘 17（含 17=EP@GND；VDD 7/8=+5V；GND 3/11/15/17；1=DIN、2=GAIN_SLOT、4=SD_MODE#、9=OUTP、10=OUTN、14=LRCLK、16=BCLK、5/6/12/13=N.C.）；封装 TQFN-16_L3.0-W3.0-P0.50-BL-EP1.5；未能获取手册（web 检索权限未授予） |
| C17 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=KEY1，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| C18 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=KEY2，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| C19 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=KEY3，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |
| C20 | UNSURE | 料号 C14663（parts.csv=网表一致）；pinInfoMap 2 条=焊盘 2（1=KEY4，2=GND）；C0603 与器件名 0603 内部相符；MLCC 无极性；未能获取手册（web 检索权限未授予） |

## 本地可判项汇总（全部 18 个位号）

| 检查项 | 结果 |
|---|---|
| parts.csv 立创料号 = 网表 props.Supplier Part | 18/18 一致 |
| 网表 pinInfoMap 条目数 = parts.csv 焊盘数 | 18/18 相等 |
| parts.csv 符号名/封装名 = 网表 DeviceName/FootprintName | 18/18 一致 |
| 封装名与器件名内部自洽（0603/C0603、R0603、TQFN-16-EP、41 脚模块等） | 18/18 自洽 |

## FAIL 汇总

无（0 个）。未发现可由本地数据直接判定的 FAIL。

## UNSURE 汇总

18 个位号全部 UNSURE，主因：web 检索权限未授予，无法取得任何手册，手册引脚数/封装尺寸/电源与地映射/料号真实存在性均无法核验。

需重点跟进的疑点（不算 FAIL，但手册到手后优先核）：
1. **SW2**：符号名 TS-1088-AR03016 vs 封装名 TS-1088-AR02026 vs 厂商料号 XD-TS-1088R-02026，三个名字不同；需确认 C56165515 的实际封装是否为 3.9×3.0mm 同族。
2. **U2**：41 脚中第 41 脚在网表为 GND，需要手册确认它是 EP/散热焊盘且必须接 GND；第 37、40 脚网络值在工具输出中被占位符遮蔽，需人工复核。
3. **U4**：EP（17 脚）已在网表接 GND，需手册确认 EP 必须接 GND 及 TQFN-16 3×3mm 0.5mm 间距。
4. **TP1/TP2**：TP-TH_5123 为通孔封装，需确认 Keystone 5123 与实际焊盘/孔径匹配。
