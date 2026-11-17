# G1 评审备注（REVIEW_NOTES）

## 阶段 2｜符号处理说明（供工程师评审）
1. **U2（ESP32-S3-WROOM-1-N16R8，C2913202）符号缺陷**：库符号引脚坐标重叠（IO35 与 IO38 同在 (85,15)）。IO35 属禁止区 GPIO33–37 且未使用，故从符号实例**删除 IO35 引脚**以释放 IO38(RGB_R)、消除 OVERLAPPIN；电气无影响。
2. **J1 换符号原因**：原 TYPE-C16PIN / TypeC-16PIN 库符号存在 SBU 与 GND 脚坐标重叠缺陷（NC 标记与 GND 叠字/误连风险）；改用引脚不重叠的 TYPE-C-16PIN（{{SECRET_qblwnxit}}），SBU1/SBU2 置 NC 并与 GND 分离（证据 power_page_J1_zoom.png）。

## 阶段 3｜音频页
- 麦克风 ICS-43432(C574021)：CONFIG/R 拉地、LR 接地（左声道）、SD 经 100k 下拉、VDD→+3V3_A 就近 0.1µF。引用 DS-000038 Rev1.0 p.8 Table6 原文（见 RUN_LOG）。
- +3V3_A = +3V3 经 R3 10Ω + C7 10µF + C8 100nF。
- MAX98357A(C910544)：VDD→+5V 就近 C10 10µF + C11 100nF；GAIN 经 R5 100k→VDD（3dB）；SD_MODE 由 AMP_SD 经 R6 10k / R7 22k 分压→2.27V>1.4V；OUT± 经 FB2/FB3 磁珠 + C12/C13 1nF 到 J2(PH2.0-2P)。
- **已知未完成**：SD_MODE 仍有 1 条网络重名(ONENETNAME)未合并；输出滤波数值数据手册无明确值(待确认)。
