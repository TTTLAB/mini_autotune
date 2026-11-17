# mini_autotune G1.5 指定器件一致性核对（A2，只读）

- 生成时间：2026-11-18
- 数据源：`hw/exports/check/parts_20261118-0410.csv`、`hw/exports/netlist_v08_20261118-040633.json`
- 方法：parts.csv 与网表 props 对照；立创/厂商手册核对引脚数、封装、极性；每件最多 2 次检索，查不到即 UNSURE。
- 判定：OK = 五项可核对且一致；FAIL = 有明确不一致；UNSURE = 料号/手册无法取得或无法判定。

| 位号 | 料号 | 判定 | 依据 |
|---|---|---|---|
| C2 | C14663 | UNSURE | 待查 |
| C3 | C14663 | UNSURE | 待查 |
| C6 | C14663 | UNSURE | 待查 |
| C26 | C14663 | UNSURE | 待查 |
| D1 | C252436 | UNSURE | 待查 |
| FB1 | C2661472 | UNSURE | 待查 |
| J1 | C393939 | UNSURE | 待查 |
| L1 | （无料号） | UNSURE | 待查 |
| R1 | C269716 | UNSURE | 待查 |
| R2 | C269716 | UNSURE | 待查 |
| R13 | C23003 | UNSURE | 待查 |
| R14 | C25804 | UNSURE | 待查 |
| R15 | C25804 | UNSURE | 待查 |
| U1 | （无料号） | UNSURE | 待查 |
| C14 | C29936 | UNSURE | 待查 |
| C16 | C14663 | UNSURE | 待查 |
| R8 | C25804 | UNSURE | 待查 |
| R9 | C25804 | UNSURE | 待查 |
| SW1 | C56165515 | UNSURE | 待查 |

## FAIL 汇总

（待填）

## UNSURE 汇总

（待填）
