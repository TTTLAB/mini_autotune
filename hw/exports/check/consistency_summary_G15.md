# G1.5 料号/符号/封装一致性 汇总（consistency_summary_G15，2026-11-18）

## 本轮做法与限制（如实）
- 只核对 G1.4 汇总里 55 个 UNSURE 件，拆 3 组：A(19)/B(18)/C(18)，各起 Claude CLI 子任务 max_turns=80；另起独立复核 R。
- **关键限制：本会话 Claude CLI 子任务无 web 权限**（子任务自述"web_search/web_fetch 权限未授予"），在线 datasheet 均**无法获取**，故"料号真实存在/手册引脚数/尺寸/极性定义"这类手册级项一律 **UNSURE**；仅能做本地机械交叉核对。
- 产出：
  - consistency_B2.md、consistency_C2.md：B、C 组的本地机械核对（已产出）。
  - consistency_A2.md：A 组子任务被中止（无产出，仅骨架）。
  - consistency_review2.md：R 复核子任务未能写出文件（记录未产出）。
  - **consistency_local_all.md**：DSH 用网表+立创库属性对全部件做的确定性本地交叉核对（真实料号一致性/引脚数/封装名/极性脚网络）。

## 本地机械核对结论（consistency_local_all.md）
- 件数 66（含本版新增 C29/C30）。
- **真实料号不一致(FAIL)：0**（parts.csv 立创料号 = 网表 Supplier Part，逐件一致）。
- 封装名与库 Supplier Footprint 表述差异（待核，非 FAIL）：C4(CASE-A vs CASE-A-3216-16(mm))、LED1(自带 6P 封装)、U2(模组 WIRELM-SMD)、U4(TQFN-16-EP) —— 多为表述/自定义封装，需人工目视确认，非冲突。
- 手册级（C 号在线存在、手册引脚数、封装尺寸、极性定义）：全部 **UNSURE（无联网）**。

## 极性器件本地网表核对（R 应在手册上裁决方向/极性；此处给本地网络事实）
| 位号 | 料号 | 封装 | 各脚网络 |
|---|---|---|---|
| C4 | C782264 | CAP-SMD_L3.2-W1.6 | 1=+3V3; 2=GND |
| LED1 | C51933351 | LED-SMD_6P-L5.0-W5.0_GL5050RGB01-A | 1=LED_BK; 2=+5V; 3=LED_RK; 4=+5V; 5=LED_GK; 6=+5V |
| D1 | C252436 | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 1=USB_DP; 2=GND; 3=USB_DM; 4=CC1; 5=VBUS_IN; 6=CC2 |
| U1 |  | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 1=GND; 2=SW_NODE; 3=+5V; 4=VFB_NODE; 5=EN_BUCK; 6=VBST_NODE |
| U3 | C5656610 | MIC-SMD_6P-L3.5-W2.7-P0.90-BL | 1=I2S_MIC_WS; 2=GND; 3=GND; 4=I2S_MIC_BCLK; 5=+3V3_A; 6=I2S_MIC_SD |
| U4 | C910544 | TQFN-16_L3.0-W3.0-P0.50-BL-EP1.5 | 1=I2S_AMP_DIN; 2=GAIN; 3=GND; 4=SD_MODE; 5=; 6=; 7=+5V; 8=+5V; 9=SPK_P; 10=SPK_N; 11=GND; 12=; 13=; 14=I2S_AMP_LRC; 15=GND; 16=I2S_AMP_BCLK; 17=GND |

说明：C4 为钽电容，pin1=+3V3（应为电源侧 +3V3，本地网表满足）；LED1(共阳+5V，阴极经限流到 GPIO)、D1(USBLC6)、U1/U3/U4 电源与地脚映射见上表，方向/极性正确性以手册为准（UNSURE）。

## FAIL 汇总
- 真实 FAIL：**0**（本地可判范围内）。
- 待核项：封装名表述差异 4 项（见上，非冲突）；手册级 UNSURE 全部待联网复核。

## 结论
- 本版硬件改动件（C1/C5/C7/C10/C15/C27/C28/C4/C29/C30/U3）本地核对通过；无确认 FAIL。
- 手册级深度核对 **未完成**（无联网）；建议下一会话联网后由独立实例对 55 件逐一补 datasheet URL+页码核对。
- 不改器件：FAIL/UNSURE 仅登记。
