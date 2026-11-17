# G1.5 器件事务一致性核对 C2 组（18 个位号）

- 核对时间：2026-11-18
- 器件清单：`hw/exports/check/parts_20261118-0410.csv`
- 网表：`hw/exports/netlist_v08_20261118-040633.json`
- 辅助：`hw/exports/check/check_g15_fix3.md`（同一网表的器件清单表）
- 方式：只读核对，未修改工程/源文件，未执行 git/下单。
- 限制：本次会话 web_search / web_fetch 权限未授予，**所有外部手册均未能获取**；下表的"料号存在性 / 手册引脚数 / 手册尺寸"只能依据网表内嵌的立创库属性做本地交叉核对，不能替代在线手册复核。

判定口径：
- OK = 五项（料号存在、引脚数、封装尺寸、电源/地/极性映射、BOM 与原理图属性料号）全部有依据且一致。
- FAIL = 本地证据已能证明存在明确矛盾（无需手册即可判定不一致）。
- UNSURE = 本地一致或无法判定，但缺少外部手册/在线料号复核。

| 位号 | 判定 | 依据 |
|---|---|---|
| C21 | UNSURE | 料号 C14663（parts.csv = 网表 Supplier Part，YAGEO CC0603KRX7R9BB104，100nF/50V/X7R）；符号 2 脚 = 封装 C0603 焊盘 2 = 网表 pinInfoMap 2 条；pin1=KEY5、pin2=GND，无极性；封装 0603 与库属性 Supplier Footprint=0603 一致。手册 URL https://item.szlcsc.com/datasheet/CC0603KRX7R9BB104/15331.html **未能获取**（web 权限未授予），故手册引脚数/尺寸未独立复核。 |
| C22 | UNSURE | 同 C21（C14663 / CC0603KRX7R9BB104 / C0603）；pin1=KEY6、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/CC0603KRX7R9BB104/15331.html |
| C23 | UNSURE | 同 C21；pin1=KEY7、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/CC0603KRX7R9BB104/15331.html |
| C24 | UNSURE | 同 C21；pin1=KEY8、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/CC0603KRX7R9BB104/15331.html |
| C25 | UNSURE | 同 C21；pin1=KEY9、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/CC0603KRX7R9BB104/15331.html |
| K1 | UNSURE | 料号 C42400866（parts.csv = 网表 Supplier Part，HMTCONN TS50610-411-02028，单刀单掷立贴轻触开关）；符号 2 脚 = 封装 KEY-SMD_L3.9-W3.0-LS5.0_1 焊盘 2 = pinInfoMap 2 条；pin1=KEY1、pin2=GND，无极性；库属性尺寸 3.9×2.93×2mm、SMD 3.9×3mm，与封装名 L3.9-W3.0 吻合；BOM 料号一致。手册 URL https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html **未能获取**，手册焊盘图/引脚数未独立复核。 |
| K2 | UNSURE | 同 K1（C42400866 / TS50610-411-02028）；pin1=KEY2、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K3 | UNSURE | 同 K1；pin1=KEY3、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K4 | UNSURE | 同 K1；pin1=KEY4、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K5 | UNSURE | 同 K1；pin1=KEY5、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K6 | UNSURE | 同 K1；pin1=KEY6、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K7 | UNSURE | 同 K1；pin1=KEY7、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K8 | UNSURE | 同 K1；pin1=KEY8、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| K9 | UNSURE | 同 K1；pin1=KEY9、pin2=GND；BOM 料号一致。手册未能获取：https://item.szlcsc.com/datasheet/TS50610-411-02028/44355790.html |
| LED1 | FAIL | 料号 C51933351（parts.csv = 网表 Supplier Part，桂光 GL5050RGB01-A）；符号 6 脚 = 封装 LED-SMD_6P-L5.0-W5.0_GL5050RGB01-A 焊盘 6 = pinInfoMap 6 条，数量自洽。**极性矛盾**：网表库属性明确写 "共阴极"（LCSC Part Name "5050RGB 0.2w 共阴…"、Diode Configuration "共阴极"、Description "共阴…缺口负"），而原理图 pin2/pin4/pin6 接 **+5V**，配对侧 pin1=LED_BK、pin3=LED_RK、pin5=LED_GK 经 R10/R11/R12 接 GPIO。若按库属性"共阴"理解，+5V 侧即阴极，LED 反偏、灯不亮；若实物为共阳，则库属性/器件名与实物不符。6 脚 5050 也存在每色独立阳极/阴极对（如 1-2/3-4/5-6）的可能，具体分组需手册确认；无论哪种，库属性与当前接法必有其一为错。手册 URL https://item.szlcsc.com/datasheet/GL5050RGB01-A/54646047.html **未能获取**。 |
| R10 | FAIL | 料号 C4190（parts.csv = 网表 Supplier Part），网表 Value=2.2kΩ、LCSC Part Name=2.2kΩ ±1%、Manufacturer Part=0603WAF2201T5E（2.2kΩ）；但 **DeviceName=0603WAF2700T5E（270Ω）**，Datasheet 也指向 0603WAF2700T5E（https://item.szlcsc.com/datasheet/0603WAF2700T5E/23693.html）。同一行里 BOM 值/厂家料号与符号器件名/手册链接互相矛盾，违反"料号-符号-封装三者一致"。符号 2 脚 = 封装 R0603 焊盘 2；pin1=RGB_R、pin2=LED_RK。 |
| R11 | FAIL | 料号 C4190，Value=2.2kΩ、Manufacturer Part=0603WAF2201T5E；但 **DeviceName=RC0603FR-0762RL（YAGEO 62Ω）**，Datasheet 指向 https://item.szlcsc.com/datasheet/RC0603FR-0762RL/243490.html。且与同料号的 R10（DeviceName 0603WAF2700T5E）符号名不一致。符号 2 脚 = 封装 R0603 焊盘 2；pin1=RGB_G、pin2=LED_GK。 |
| R12 | FAIL | 同 R11：料号 C4190、Value=2.2kΩ、MPN=0603WAF2201T5E，但 DeviceName=RC0603FR-0762RL（62Ω）、Datasheet 指向 RC0603FR-0762RL。符号 2 脚 = 封装 R0603 焊盘 2；pin1=RGB_B、pin2=LED_BK。 |

## FAIL 汇总（4 项）

1. **R10**：C4190 对应 Value/MPN 为 2.2kΩ（0603WAF2201T5E），符号 DeviceName 却是 0603WAF2700T5E（270Ω），手册链接同错。
2. **R11**：C4190 / 2.2kΩ，符号 DeviceName 是 RC0603FR-0762RL（62Ω），手册链接同错。
3. **R12**：同 R11。
4. **LED1**：库属性标注"共阴"，原理图把 pin2/4/6 接 +5V；若按共阴理解则 +5V 侧为阴极，极性反接。需按手册确认引脚分组后改料号或改线。

补充观察（不计入本组判定）：同一 C4190 在 R10 与 R11/R12 上挂了两个不同 DeviceName（270Ω / 62Ω），三个符号名没有一个是 2.2kΩ（0603WAF2201T5E）；这不是显示问题，是符号库属性未随料号同步。

R10/R11/R12 判 FAIL 的直接规则依据：项目《器件规范》"换料号必须同步换符号和封装，三者一致才算完成"。`parts.csv` 第 63 行 R10 符号名 `0603WAF2700T5E`、第 64/65 行 R11/R12 符号名 `RC0603FR-0762RL`，均与同表料号 C4190、网表 Value/MPN `0603WAF2201T5E`（2.2kΩ）不符；应换库器件/同步符号属性，而不是改 Value。

## UNSURE 汇总（14 项）

- **C21–C25（5 项）**：C14663 / CC0603KRX7R9BB104 / C0603，本地"料号-符号 2 脚-封装 2 焊盘-pin1=KEYn/pin2=GND-无极性"全部自洽；仅因 web 手册未能获取，手册引脚数/尺寸未独立复核。另：C21–C25 的 pin1 分别为 KEY5–KEY9，与 K5–K9 一一对应，五路按键去耦是成对挂的，不是乱放。
- **K1–K9（9 项）**：C42400866 / TS50610-411-02028 / KEY-SMD_L3.9-W3.0-LS5.0_1，本地"料号-符号 2 脚-封装 2 焊盘-pin1=KEYn/pin2=GND-无极性-尺寸属性与封装名吻合"全部自洽；仅因 web 手册未能获取。

## 统计

- 总计：18
- OK：0
- FAIL：4（LED1、R10、R11、R12）
- UNSURE：14（C21–C25、K1–K9）

## 工具受限披露（按 Hard stop 1）

- Bash（grep / python 解析网表）被权限拒绝，未换 shell 绕过；改用 Read 工具逐段读取同一网表 JSON（5132 行）取证。
- magpie web_search、WebSearch、WebFetch 依次被拒绝（未授权），随即停止，未再尝试其他联网通道；因此四份外部手册均未获取，相关项只能标 UNSURE。
- 除本报告外未修改任何文件；未执行 git、未下单。

## 未完成 / 待补

- 需授权联网后复核四份手册：C14663（CC0603KRX7R9BB104）、C42400866（TS50610-411-02028）、C51933351（GL5050RGB01-A）、C4190（确认真实阻值与对应 MPN）。
- 手册到手后重点裁决两处：LED1 的引脚分组/共阴共阳；R10–R12 应使用的正确库器件（2.2kΩ 0603）。
