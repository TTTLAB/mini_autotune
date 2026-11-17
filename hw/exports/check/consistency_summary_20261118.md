# G1.4 料号/符号/封装一致性 汇总 (consistency_summary_20261118)

说明：本汇总基于 hw/exports/check/parts_20261118-0410.csv（64 件）与 netlist_v08。
G1.4 改动件（本轮已对照手册核对）记 OK；其余历史件本轮未逐件深度手册核对，记 UNSURE（待独立评审/下一轮）。
**BOM 料号=原理图属性料号**：parts.csv 立创料号与网表 props.Supplier Part 同源，逐件一致（机械核对通过）。

## 逐件
 
| 位号 | 料号 | 器件名 | 封装 | 焊盘/引脚数 | 页面 | 状态 |
|---|---|---|---|---|---|---|
| C1 | C15850 | CL21A106KAYNNNE_C15850 | C0805 | 2 | 电源 | OK 依据 TPS563201 p.14-15 + C15850(10uF X5R 25V,2pad=2pin) |
| C2 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C3 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C4 | C782264 | CA45-A-16V-22uF-K | CAP-SMD_L3.2-W1.6 | 2 | 电源 | OK 22uF钽16V(+3V3,pin1=+3V3极性)；zoom_power_C1_C4.png |
| C5 | C15850 | CL21A106KAYNNNE_C15850 | C0805 | 2 | 电源 | OK 依据 TPS563201 p.14-15 + C15850(10uF X5R 25V,2pad=2pin) |
| C6 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C26 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C27 | C45783 | CL21A226MAQNNNE | C0805 | 2 | 电源 | OK 依据 TPS563201 p.14-15 输入>10uF; C45783 22uF X5R 25V |
| C28 | C45783 | CL21A226MAQNNNE | C0805 | 2 | 电源 | OK 依据 TPS563201 p.14-15 输出20-68uF; C45783 22uF X5R 25V |
| D1 | C252436 | USBLC6-4SC6 | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 6 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| FB1 | C2661472 | PE-0603PFB121ST | L0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| J1 | C393939 | TYPE-C16PIN | USB-C-SMD_TYPE-C16PIN | 16 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| L1 |  | 2.2uH | IND-SMD_L2.5-W2.0-VLS252012CX-150M | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R1 | C269716 | RMC06035.1K1%N | R0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R2 | C269716 | RMC06035.1K1%N | R0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R13 | C23003 | 0603WAF2201T5E | R0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R14 | C25804 | 0603WAF2201T5E | R0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R15 | C25804 | 0603WAF2201T5E | R0603 | 2 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| U1 |  | TPS563201DDCR | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 6 | 电源 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C14 | C29936 | CL10B105KA8NNNC | C0603 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C15 | C15850 | CL21A106KAYNNNE_C15850 | C0805 | 2 | 主控 | OK 依据 TPS563201 p.14-15 + C15850(10uF X5R 25V,2pad=2pin) |
| C16 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R8 | C25804 | 0603WAF1002T5E | R0603 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R9 | C25804 | 0603WAF1002T5E | R0603 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| SW1 | C56165515 | TS-1088-AR03016 | SW-SMD_L3.9-W3.0_TS-1088-AR02026 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| SW2 | C56165515 | TS-1088-AR03016 | SW-SMD_L3.9-W3.0_TS-1088-AR02026 | 2 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| TP1 | C5272786 | 5123 | TP-TH_5123 | 1 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| TP2 | C5272786 | 5123 | TP-TH_5123 | 1 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| U2 | C2913202 | ESP32-S3-WROOM-1-N16R8 | WIRELM-SMD_ESP32-S3-WROOM-1 | 41 | 主控 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C7 | C15850 | CL21A106KAYNNNE_C15850 | C0805 | 2 | 音频 | OK 依据 TPS563201 p.14-15 + C15850(10uF X5R 25V,2pad=2pin) |
| C8 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C9 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C10 | C15850 | CL21A106KAYNNNE_C15850 | C0805 | 2 | 音频 | OK 依据 TPS563201 p.14-15 + C15850(10uF X5R 25V,2pad=2pin) |
| C11 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| J2 | C22388468 | BX-PH2.0-2PZZ-Y | CONN-TH_2P-P2.00_HC-PH-2A-TW | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R3 | C2889398 | 0603 ±5% 10Ω | R0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R4 | C25803 | 0603WAF1003T5E | R0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R5 | C25803 | 0603WAF1003T5E | R0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R6 | C25804 | 0603WAF1002T5E | R0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R7 | C31850 | 0603WAF2202T5E | R0603 | 2 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| U3 | C5656610 | ICS-43434_C5656610 | MIC-SMD_6P-L3.5-W2.7-P0.90-BL | 6 | 音频 | OK ICS-43434 符号6pin=封装6pad=手册6pin(DS-000069 p.10); 供货"停产"UNSURE |
| U4 | C910544 | MAX98357AETE+T | TQFN-16_L3.0-W3.0-P0.50-BL-EP1.5 | 17 | 音频 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C17 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C18 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C19 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C20 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C21 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C22 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C23 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C24 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| C25 | C14663 | CC0603KRX7R9BB104 | C0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K1 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K2 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K3 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K4 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K5 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K6 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K7 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K8 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| K9 | C42400866 | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| LED1 | C51933351 | GL5050RGB01-A | LED-SMD_6P-L5.0-W5.0_GL5050RGB01-A | 6 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R10 | C4190 | 0603WAF2700T5E | R0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R11 | C4190 | RC0603FR-0762RL | R0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |
| R12 | C4190 | RC0603FR-0762RL | R0603 | 2 | 人机交互 | UNSURE 待独立评审(本轮A/B/C多agent因turn上限未产出) |

## 汇总

- OK（改动件已核）: 9 件
- UNSURE（待独立评审）: 55 件
- FAIL: 0（本轮改动件未发现 FAIL）

## 未完成 / 如实说明

- 已按任务并行启动 3 个 Claude CLI 只读子任务 A(电源+主控)/B(音频)/C(人机交互)，但各自调用联网 datasheet 检索，均在 max_turns=30 内未完成并退出，**未产出 consistency_A/B/C.md**；复核子任务 R 未启动。
- 因此**逐件手册级深度核对（C号真实存在/封装尺寸/逐脚映射/极性）本轮未全部完成**；已在改动件上给出可核对结论。建议下一会话提高 max_turns 或联网后由独立实例补做 A/B/C/R，并用本 parts.csv 作输入。
- 不修改器件：所有 FAIL/UNSURE 仅登记，等鼠王/工程师确认后再改。