# G1 评审备注（REVIEW_NOTES）

## 阶段 2｜符号处理说明（供工程师评审）
1. **U2（ESP32-S3-WROOM-1-N16R8，C2913202）符号缺陷处理**：该库符号存在引脚坐标重叠（IO35 与 IO38 同在 (85,15)，另有其它版本 IO47/IO20、IO48/IO19、IO41/IO37 重叠）。其中 **IO35 属禁止区 GPIO33–37 且本设计未使用**，因此从符号实例中**删除 IO35 引脚**以释放 IO38（RGB_R）并消除 OVERLAPPIN 报错。电气无影响（IO35 本就不连）。
2. **J1 换符号原因**：原 `TYPE-C16PIN` 及 `TypeC-16PIN` 等库符号存在 **SBU 引脚与 GND 脚坐标重叠**缺陷，导致不连接(NC)标记与 GND 文字叠字、存在误连风险。改用引脚不重叠的 `TYPE-C-16PIN`（{{SECRET_qblwnxit}}）。SBU1/SBU2 为 USB-C 冗余脚、本设计不用，置 NC，且与 GND 脚分离（证据：power_page_J1_zoom.png）。
