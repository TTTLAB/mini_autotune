# mini_autotune 原理图自检报告

- 生成时间：2026-11-18 04:33:46
- 旧网表：`/Users/wangmingshu/Documents/mini_autotune/.dsh_tmp/g15/fix1/netlist.json`
- 新网表：`/Users/wangmingshu/Documents/mini_autotune/.dsh_tmp/g15/fix2/netlist.json`
- 旧 PNG 目录：`/Users/wangmingshu/Documents/mini_autotune/.dsh_tmp/g15/fix1/pngs`
- 新 PNG 目录：`/Users/wangmingshu/Documents/mini_autotune/.dsh_tmp/g15/fix2/pngs`
- 报告文件：`/Users/wangmingshu/Documents/mini_autotune/hw/exports/check/check_g15_fix2.md`

## 小结

| 检查项 | 计数 |
| --- | --- |
| PNG 文件（两目录 basename 并集） | 4 |
| PNG 变 / 未变 / 新增 / 删除 | 1 / 3 / 0 / 0 |
| 器件数（旧 → 新） | 65 → 66 |
| 新增器件 / 删除器件 | 1 / 0 |
| 引脚网络改动 | 0 |
| 网络新增 / 消失 | 0 / 0 |

## 1. PNG 每页 sha256 对比

按 basename 配对，两个目录都扫描。状态：变 = 同名但哈希不同；未变 = 哈希相同；新增 = 仅新目录有；删除 = 仅旧目录有。

| 文件 | 状态 | 旧 sha256 | 新 sha256 |
| --- | --- | --- | --- |
| SCH_Main_1-电源_2026-11-18.png | 未变 | f4983e06cf9a2d27a9732cd1f78630d6c736cbc6c67be2411d860708a60f5f72 | f4983e06cf9a2d27a9732cd1f78630d6c736cbc6c67be2411d860708a60f5f72 |
| SCH_Main_2-主控_2026-11-18.png | 未变 | fa35a45c74ea367935ec0b4e14430aadaf9a6493fb3fa8926db029e512a6e368 | fa35a45c74ea367935ec0b4e14430aadaf9a6493fb3fa8926db029e512a6e368 |
| SCH_Main_3-音频_2026-11-18.png | 变 | 71d19f916890c4a50311a2535576fb790dfb8681754f2c42a3693aa807076900 | 67a0b80fde56ca06d1cbd867f5a119a58f313bfc7f150a83340b0dd0c401b2d5 |
| SCH_Main_4-人机交互_2026-11-18.png | 未变 | a0d9fea12e176a13d59458d8b3f69260465533d281ad33bf20789539b0e97ce5 | a0d9fea12e176a13d59458d8b3f69260465533d281ad33bf20789539b0e97ce5 |

## 2. 网表 diff

以 `Designator` 为键；引脚 `net` 为空串表示未连接。

### 2.1 新增器件（新网表有、旧网表无）

| 位号 | 料号 | 值 | 器件名 | 焊盘/引脚数 |
| --- | --- | --- | --- | --- |
| C30 | C14663 | 100nF | CC0603KRX7R9BB104 | 2 |

### 2.2 删除器件（旧网表有、新网表无）

（无）

### 2.3 引脚网络改动

（无）

### 2.4 网络级新增/消失

**新增网络（新网表有、旧网表无，0 个）**

（无）

**消失网络（旧网表有、新网表无，0 个）**

（无）

## 3. 器件清单（以新网表为准）

| 位号 | 料号(Supplier Part) | 值(Value) | 器件名(DeviceName) | 封装名(FootprintName) | 焊盘/引脚数 |
| --- | --- | --- | --- | --- | --- |
| C1 | C15850 | 10uF | CL21A106KAYNNNE_C15850 | C0805 | 2 |
| C2 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C3 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C4 | C782264 | 22uF | CA45-A-16V-22uF-K | CAP-SMD_L3.2-W1.6 | 2 |
| C5 | C15850 | 10uF | CL21A106KAYNNNE_C15850 | C0805 | 2 |
| C6 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C7 | C15850 | 10uF | CL21A106KAYNNNE_C15850 | C0805 | 2 |
| C8 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C9 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C10 | C15850 | 10uF | CL21A106KAYNNNE_C15850 | C0805 | 2 |
| C11 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C14 | C29936 | 1uF | CL10B105KA8NNNC | C0603 | 2 |
| C15 | C15850 | 10uF | CL21A106KAYNNNE_C15850 | C0805 | 2 |
| C16 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C17 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C18 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C19 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C20 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C21 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C22 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C23 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C24 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C25 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C26 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| C27 | C45783 | 22uF | CL21A226MAQNNNE | C0805 | 2 |
| C28 | C45783 | 22uF | CL21A226MAQNNNE | C0805 | 2 |
| C29 | C45783 | 22uF | CL21A226MAQNNNE | C0805 | 2 |
| C30 | C14663 | 100nF | CC0603KRX7R9BB104 | C0603 | 2 |
| D1 | C252436 | — | USBLC6-4SC6 | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 6 |
| FB1 | C2661472 | — | PE-0603PFB121ST | L0603 | 2 |
| J1 | C393939 | — | TYPE-C16PIN | USB-C-SMD_TYPE-C16PIN | 16 |
| J2 | C22388468 | — | BX-PH2.0-2PZZ-Y | CONN-TH_2P-P2.00_HC-PH-2A-TW | 2 |
| K1 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K2 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K3 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K4 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K5 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K6 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K7 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K8 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| K9 | C42400866 | — | TS50610-411-02028 | KEY-SMD_L3.9-W3.0-LS5.0_1 | 2 |
| L1 | — | 2.2µH | 2.2uH | IND-SMD_L2.5-W2.0-VLS252012CX-150M | 2 |
| LED1 | C51933351 | — | GL5050RGB01-A | LED-SMD_6P-L5.0-W5.0_GL5050RGB01-A | 6 |
| R1 | C269716 | 5.1kΩ | RMC06035.1K1%N | R0603 | 2 |
| R2 | C269716 | 5.1kΩ | RMC06035.1K1%N | R0603 | 2 |
| R3 | C2889398 | 10Ω | 0603 ±5% 10Ω | R0603 | 2 |
| R4 | C25803 | 100kΩ | 0603WAF1003T5E | R0603 | 2 |
| R5 | C25803 | 100kΩ | 0603WAF1003T5E | R0603 | 2 |
| R6 | C25804 | 10kΩ | 0603WAF1002T5E | R0603 | 2 |
| R7 | C31850 | 22kΩ | 0603WAF2202T5E | R0603 | 2 |
| R8 | C25804 | 10kΩ | 0603WAF1002T5E | R0603 | 2 |
| R9 | C25804 | 10kΩ | 0603WAF1002T5E | R0603 | 2 |
| R10 | C4190 | 2.2kΩ | 0603WAF2700T5E | R0603 | 2 |
| R11 | C4190 | 2.2kΩ | RC0603FR-0762RL | R0603 | 2 |
| R12 | C4190 | 2.2kΩ | RC0603FR-0762RL | R0603 | 2 |
| R13 | C23003 | 33.2kΩ | 0603WAF2201T5E | R0603 | 2 |
| R14 | C25804 | 10kΩ | 0603WAF2201T5E | R0603 | 2 |
| R15 | C25804 | 10kΩ | 0603WAF2201T5E | R0603 | 2 |
| SW1 | C56165515 | — | TS-1088-AR03016 | SW-SMD_L3.9-W3.0_TS-1088-AR02026 | 2 |
| SW2 | C56165515 | — | TS-1088-AR03016 | SW-SMD_L3.9-W3.0_TS-1088-AR02026 | 2 |
| TP1 | C5272786 | — | 5123 | TP-TH_5123 | 1 |
| TP2 | C5272786 | — | 5123 | TP-TH_5123 | 1 |
| U1 | — | TPS563201DDCR | TPS563201DDCR | SOT-23-6_L2.9-W1.6-P0.95-LS2.8-BR | 6 |
| U2 | C2913202 | 2.4GHz | ESP32-S3-WROOM-1-N16R8 | WIRELM-SMD_ESP32-S3-WROOM-1 | 41 |
| U3 | C5656610 | — | ICS-43434_C5656610 | MIC-SMD_6P-L3.5-W2.7-P0.90-BL | 6 |
| U4 | C910544 | — | MAX98357AETE+T | TQFN-16_L3.0-W3.0-P0.50-BL-EP1.5 | 17 |
