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
