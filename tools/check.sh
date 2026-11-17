#!/usr/bin/env bash
# mini_autotune 原理图自检脚本（只读）
#
# 用法:
#   tools/check.sh <prev_netlist.json> <cur_netlist.json> <prev_png_dir> <cur_png_dir> [out_md]
#
# 行为:
#   - 对比两个 PNG 目录中同名 .png 的 sha256（变 / 未变 / 新增 / 删除）
#   - 以 Designator 为键对比两个 JLCEDA 网表（器件增删、引脚网络变化、网络增删）
#   - 输出新网表的器件清单
#   - 只读输入；唯一写出是 Markdown 报告（默认 hw/exports/check/check_<时间戳>.md）
#   - 不调用 git，不联网

set -euo pipefail

usage() {
    cat <<'EOF'
用法: tools/check.sh <prev_netlist.json> <cur_netlist.json> <prev_png_dir> <cur_png_dir> [out_md]

  prev_netlist.json  旧网表（JLCEDA 导出 JSON）
  cur_netlist.json   新网表（JLCEDA 导出 JSON）
  prev_png_dir       旧 PNG 目录
  cur_png_dir        新 PNG 目录
  out_md             可选，报告输出路径
                     缺省: <仓库根>/hw/exports/check/check_<YYYYMMDD-HHMMSS>.md
EOF
}

die() {
    printf 'check.sh: 错误: %s\n' "$*" >&2
    exit 1
}

if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    usage >&2
    exit 2
fi

prev_net=$1
cur_net=$2
prev_png=$3
cur_png=$4

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(dirname "$script_dir")

if [ "$#" -eq 5 ]; then
    out_md=$5
else
    mkdir -p "$repo_root/hw/exports/check" || die "无法创建默认报告目录"
    out_md="$repo_root/hw/exports/check/check_$(date +%Y%m%d-%H%M%S).md"
fi

command -v python3 >/dev/null 2>&1 || die "找不到 python3"

[ -f "$prev_net" ] || die "旧网表不存在或不是文件: $prev_net"
[ -r "$prev_net" ] || die "旧网表不可读: $prev_net"
[ -f "$cur_net" ] || die "新网表不存在或不是文件: $cur_net"
[ -r "$cur_net" ] || die "新网表不可读: $cur_net"
[ -d "$prev_png" ] || die "旧 PNG 目录不存在或不是目录: $prev_png"
[ -r "$prev_png" ] || die "旧 PNG 目录不可读: $prev_png"
[ -d "$cur_png" ] || die "新 PNG 目录不存在或不是目录: $cur_png"
[ -r "$cur_png" ] || die "新 PNG 目录不可读: $cur_png"

python3 -I - "$prev_net" "$cur_net" "$prev_png" "$cur_png" "$out_md" <<'PY'
# -*- coding: utf-8 -*-
import hashlib
import json
import os
import re
import sys
from datetime import datetime


def err(msg):
    sys.stderr.write("check.sh: 错误: %s\n" % msg)
    sys.exit(1)


def natkey(value):
    """自然排序键：R2 < R10，C2 < C10。"""
    parts = re.split(r"(\d+)", str(value))
    key = []
    for part in parts:
        if part == "":
            continue
        if part.isdigit():
            key.append((0, int(part)))
        else:
            key.append((1, part.lower()))
    return key


def code_span(value):
    return "`" + str(value).replace("`", "'") + "`"


def md_cell(value):
    if value is None:
        return "—"
    text = str(value)
    if text == "":
        return "—"
    return text.replace("\r", " ").replace("\n", "<br>").replace("|", "\\|")


def md_table(headers, rows):
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(md_cell(cell) for cell in row) + " |")
    return "\n".join(lines)


def sha256_file(path):
    digest = hashlib.sha256()
    try:
        with open(path, "rb") as handle:
            for chunk in iter(lambda: handle.read(1024 * 1024), b""):
                digest.update(chunk)
    except OSError as exc:
        err("读取文件失败 %s: %s" % (path, exc))
    return digest.hexdigest()


def scan_pngs(directory):
    found = {}
    try:
        names = os.listdir(directory)
    except OSError as exc:
        err("读取 PNG 目录失败 %s: %s" % (directory, exc))
    for name in names:
        path = os.path.join(directory, name)
        if name.lower().endswith(".png") and os.path.isfile(path):
            found[name] = path
    return found


def load_netlist(path, label):
    try:
        with open(path, "r", encoding="utf-8") as handle:
            data = json.load(handle)
    except json.JSONDecodeError as exc:
        err("%s 不是合法 JSON（%s）: %s" % (label, path, exc))
    except OSError as exc:
        err("读取%s失败（%s）: %s" % (label, path, exc))

    if not isinstance(data, dict):
        err("%s 顶层不是 JSON 对象: %s" % (label, path))
    components = data.get("components")
    if not isinstance(components, dict):
        err("%s 缺少 components 对象: %s" % (label, path))

    by_designator = {}
    duplicates = {}
    missing_designator = []

    for uid, component in components.items():
        if not isinstance(component, dict):
            continue
        props = component.get("props")
        if not isinstance(props, dict):
            props = {}

        designator = str(props.get("Designator") or "").strip()
        if designator == "":
            designator = "（无位号:%s）" % uid
            missing_designator.append(str(uid))

        pins = {}
        pin_names = {}
        pin_info = component.get("pinInfoMap")

        if isinstance(pin_info, dict):
            entries = list(pin_info.items())
        elif isinstance(pin_info, list):
            entries = []
            for index, entry in enumerate(pin_info):
                if not isinstance(entry, dict):
                    continue
                number = entry.get("number")
                if number in (None, ""):
                    entry_props = entry.get("props")
                    if isinstance(entry_props, dict):
                        number = entry_props.get("Pin Number")
                if number in (None, ""):
                    number = str(index + 1)
                entries.append((str(number), entry))
        else:
            entries = []

        for pin_key, pin_entry in entries:
            if not isinstance(pin_entry, dict):
                pin_entry = {}
            number = pin_entry.get("number")
            if number in (None, ""):
                number = pin_key
            number = str(number)
            net = pin_entry.get("net")
            if net is None:
                net = ""
            else:
                net = str(net)
            pins[number] = net
            name = pin_entry.get("name")
            if name not in (None, ""):
                pin_names[number] = str(name)

        if designator in by_designator:
            duplicates[designator] = duplicates.get(designator, 1) + 1
            record = by_designator[designator]
            for number, net in pins.items():
                record["pins"].setdefault(number, net)
            for number, name in pin_names.items():
                record["pin_names"].setdefault(number, name)
            for key, value in props.items():
                if key not in record["props"] or record["props"][key] in (None, ""):
                    record["props"][key] = value
        else:
            by_designator[designator] = {
                "designator": designator,
                "uid": str(uid),
                "props": dict(props),
                "pins": pins,
                "pin_names": pin_names,
            }

    return {
        "by_designator": by_designator,
        "duplicates": duplicates,
        "missing_designator": missing_designator,
        "component_count": len(components),
    }


def collect_nets(netlist):
    result = set()
    for record in netlist["by_designator"].values():
        for net in record["pins"].values():
            if net != "":
                result.add(net)
    return result


def net_display(net):
    if net is None:
        return "（无此引脚）"
    if net == "":
        return "（未连接）"
    return net


args = sys.argv[1:]
if len(args) != 5:
    err("内部参数数量错误")
prev_net_path, cur_net_path, prev_png_dir, cur_png_dir, out_md = args

for label, path in (("旧网表", prev_net_path), ("新网表", cur_net_path)):
    if not os.path.isfile(path):
        err("%s不存在或不是文件: %s" % (label, path))
for label, directory in (("旧 PNG 目录", prev_png_dir), ("新 PNG 目录", cur_png_dir)):
    if not os.path.isdir(directory):
        err("%s不存在或不是目录: %s" % (label, directory))

out_abs = os.path.abspath(out_md)
if os.path.isdir(out_abs):
    err("报告输出路径是目录: %s" % out_abs)
for path in (prev_net_path, cur_net_path):
    if os.path.abspath(path) == out_abs:
        err("报告输出路径不能与输入网表相同: %s" % out_abs)

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# ---------- 1. PNG sha256 ----------
prev_pngs = scan_pngs(prev_png_dir)
cur_pngs = scan_pngs(cur_png_dir)

png_rows = []
png_changed = 0
png_same = 0
png_added = 0
png_removed = 0

for name in sorted(set(prev_pngs) | set(cur_pngs), key=natkey):
    old_path = prev_pngs.get(name)
    new_path = cur_pngs.get(name)
    if old_path is not None and new_path is not None:
        old_hash = sha256_file(old_path)
        new_hash = sha256_file(new_path)
        if old_hash == new_hash:
            status = "未变"
            png_same += 1
        else:
            status = "变"
            png_changed += 1
    elif new_path is not None:
        status = "新增"
        old_hash = "—"
        new_hash = sha256_file(new_path)
        png_added += 1
    else:
        status = "删除"
        old_hash = sha256_file(old_path)
        new_hash = "—"
        png_removed += 1
    png_rows.append((name, status, old_hash, new_hash))

# ---------- 2. 网表 diff ----------
prev = load_netlist(prev_net_path, "旧网表")
cur = load_netlist(cur_net_path, "新网表")
prev_map = prev["by_designator"]
cur_map = cur["by_designator"]

added_designators = sorted(set(cur_map) - set(prev_map), key=natkey)
removed_designators = sorted(set(prev_map) - set(cur_map), key=natkey)
common_designators = sorted(set(prev_map) & set(cur_map), key=natkey)

pin_changes = []
for designator in common_designators:
    old_pins = prev_map[designator]["pins"]
    new_pins = cur_map[designator]["pins"]
    names = dict(prev_map[designator]["pin_names"])
    names.update(cur_map[designator]["pin_names"])
    for pin in sorted(set(old_pins) | set(new_pins), key=natkey):
        old_net = old_pins.get(pin)
        new_net = new_pins.get(pin)
        if old_net == new_net:
            continue
        pin_changes.append((designator, pin, names.get(pin, ""), old_net, new_net))

prev_nets = collect_nets(prev)
cur_nets = collect_nets(cur)
new_nets = sorted(cur_nets - prev_nets, key=natkey)
gone_nets = sorted(prev_nets - cur_nets, key=natkey)

# ---------- 报告 ----------
lines = []
lines.append("# mini_autotune 原理图自检报告")
lines.append("")
lines.append("- 生成时间：%s" % timestamp)
lines.append("- 旧网表：%s" % code_span(os.path.abspath(prev_net_path)))
lines.append("- 新网表：%s" % code_span(os.path.abspath(cur_net_path)))
lines.append("- 旧 PNG 目录：%s" % code_span(os.path.abspath(prev_png_dir)))
lines.append("- 新 PNG 目录：%s" % code_span(os.path.abspath(cur_png_dir)))
lines.append("- 报告文件：%s" % code_span(out_abs))
lines.append("")
lines.append("## 小结")
lines.append("")
lines.append(md_table(
    ["检查项", "计数"],
    [
        ["PNG 文件（两目录 basename 并集）", len(png_rows)],
        ["PNG 变 / 未变 / 新增 / 删除",
         "%d / %d / %d / %d" % (png_changed, png_same, png_added, png_removed)],
        ["器件数（旧 → 新）", "%d → %d" % (prev["component_count"], cur["component_count"])],
        ["新增器件 / 删除器件", "%d / %d" % (len(added_designators), len(removed_designators))],
        ["引脚网络改动", len(pin_changes)],
        ["网络新增 / 消失", "%d / %d" % (len(new_nets), len(gone_nets))],
    ],
))
lines.append("")

lines.append("## 1. PNG 每页 sha256 对比")
lines.append("")
lines.append("按 basename 配对，两个目录都扫描。状态：变 = 同名但哈希不同；未变 = 哈希相同；新增 = 仅新目录有；删除 = 仅旧目录有。")
lines.append("")
if png_rows:
    lines.append(md_table(["文件", "状态", "旧 sha256", "新 sha256"], png_rows))
else:
    lines.append("（两个目录中都没有 .png 文件）")
lines.append("")

lines.append("## 2. 网表 diff")
lines.append("")
lines.append("以 `Designator` 为键；引脚 `net` 为空串表示未连接。")
lines.append("")

lines.append("### 2.1 新增器件（新网表有、旧网表无）")
lines.append("")
if added_designators:
    rows = []
    for designator in added_designators:
        record = cur_map[designator]
        props = record["props"]
        rows.append([
            designator,
            props.get("Supplier Part", ""),
            props.get("Value", ""),
            props.get("DeviceName", ""),
            len(record["pins"]),
        ])
    lines.append(md_table(["位号", "料号", "值", "器件名", "焊盘/引脚数"], rows))
else:
    lines.append("（无）")
lines.append("")

lines.append("### 2.2 删除器件（旧网表有、新网表无）")
lines.append("")
if removed_designators:
    rows = []
    for designator in removed_designators:
        record = prev_map[designator]
        props = record["props"]
        rows.append([
            designator,
            props.get("Supplier Part", ""),
            props.get("Value", ""),
            props.get("DeviceName", ""),
            len(record["pins"]),
        ])
    lines.append(md_table(["位号", "料号", "值", "器件名", "焊盘/引脚数"], rows))
else:
    lines.append("（无）")
lines.append("")

lines.append("### 2.3 引脚网络改动")
lines.append("")
if pin_changes:
    rows = []
    for designator, pin, pin_name, old_net, new_net in pin_changes:
        rows.append([
            "%s.%s" % (designator, pin),
            pin_name,
            net_display(old_net),
            net_display(new_net),
        ])
    lines.append(md_table(["器件.引脚", "引脚名", "旧网络", "新网络"], rows))
else:
    lines.append("（无）")
lines.append("")

lines.append("### 2.4 网络级新增/消失")
lines.append("")
lines.append("**新增网络（新网表有、旧网表无，%d 个）**" % len(new_nets))
lines.append("")
if new_nets:
    for net in new_nets:
        lines.append("- %s" % code_span(net))
else:
    lines.append("（无）")
lines.append("")
lines.append("**消失网络（旧网表有、新网表无，%d 个）**" % len(gone_nets))
lines.append("")
if gone_nets:
    for net in gone_nets:
        lines.append("- %s" % code_span(net))
else:
    lines.append("（无）")
lines.append("")

lines.append("## 3. 器件清单（以新网表为准）")
lines.append("")
if cur_map:
    rows = []
    for designator in sorted(cur_map, key=natkey):
        record = cur_map[designator]
        props = record["props"]
        rows.append([
            designator,
            props.get("Supplier Part", ""),
            props.get("Value", ""),
            props.get("DeviceName", ""),
            props.get("FootprintName", ""),
            len(record["pins"]),
        ])
    lines.append(md_table(
        ["位号", "料号(Supplier Part)", "值(Value)", "器件名(DeviceName)",
         "封装名(FootprintName)", "焊盘/引脚数"],
        rows,
    ))
else:
    lines.append("（新网表没有器件）")
lines.append("")

notes = []
if cur["duplicates"]:
    notes.append("新网表重复位号（已合并引脚）：" + "、".join(
        "%s×%d" % (designator, count)
        for designator, count in sorted(cur["duplicates"].items(), key=lambda item: natkey(item[0]))
    ))
if prev["duplicates"]:
    notes.append("旧网表重复位号（已合并引脚）：" + "、".join(
        "%s×%d" % (designator, count)
        for designator, count in sorted(prev["duplicates"].items(), key=lambda item: natkey(item[0]))
    ))
if cur["missing_designator"]:
    notes.append("新网表无位号器件 uid：" + "、".join(code_span(uid) for uid in cur["missing_designator"]))
if prev["missing_designator"]:
    notes.append("旧网表无位号器件 uid：" + "、".join(code_span(uid) for uid in prev["missing_designator"]))
if notes:
    lines.append("## 备注")
    lines.append("")
    for note in notes:
        lines.append("- " + note)
    lines.append("")

out_dir = os.path.dirname(out_abs)
try:
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
except OSError as exc:
    err("无法创建报告目录 %s: %s" % (out_dir, exc))

tmp_path = out_abs + ".tmp.%d" % os.getpid()
try:
    with open(tmp_path, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines).rstrip() + "\n")
    os.replace(tmp_path, out_abs)
except OSError as exc:
    try:
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
    except OSError:
        pass
    err("写入报告失败 %s: %s" % (out_abs, exc))

print("报告已生成: %s" % out_abs)
print("PNG 变/未变/新增/删除: %d/%d/%d/%d；器件 +%d/-%d；引脚改动 %d；网络 +%d/-%d" % (
    png_changed, png_same, png_added, png_removed,
    len(added_designators), len(removed_designators), len(pin_changes),
    len(new_nets), len(gone_nets),
))
sys.exit(0)
PY
