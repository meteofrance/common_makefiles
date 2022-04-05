import json
import re
import sys
from typing import List, Tuple


with open(sys.argv[1], "r") as f:
    lines = [x.rstrip() for x in f.readlines()]

mode: str = ""
buffer: List[str] = []
variables: List[Tuple[str, str, str, List[str]]] = []
targets: List[Tuple[str, str, str, List[str]]] = []

VARIABLE_PATTERN = r"^([A-Z0-9_]+).*=(.*)$"
TARGET_PATTERN = r"^([a-z0-9_]+)(:{1,2})(.*)$"
WITH_DOC_TARGET_PATTERN = r"^([a-z0-9_]+)(:{1,2})(.*)## (.*)$"

for line in lines:
    if line.startswith("\t"):
        continue
    if line.startswith("#+ "):
        buffer.append(line[3:])
        mode = "overridable"
    elif line.startswith("#* "):
        buffer.append(line[3:])
        mode = "overridable_before"
    elif line.startswith("## "):
        buffer.append(line[3:])
        mode = "readonly"
    else:
        mo = re.match(VARIABLE_PATTERN, line)
        if mo:
            if len(buffer) == 0:
                continue
            var = mo.group(1)
            default = mo.group(2).strip()
            if mode == "overridable":
                variables.append((var, "overridable", default, buffer))
            elif mode == "overridable_before":
                variables.append((var, "overridable_before", default, buffer))
            elif mode == "readonly":
                variables.append((var, "readonly", default, buffer))
            buffer = []
            mode = ""
            continue
        mo = re.match(WITH_DOC_TARGET_PATTERN, line)
        if mo:
            var = mo.group(1)
            sep = mo.group(2)
            deps = mo.group(3).strip()
            doc = mo.group(4).strip()
            doc_to_add = buffer if len(buffer) > 0 else [doc]
            if sep == ":":
                targets.append((var, sep, deps, doc_to_add))
            else:
                targets.append((var, sep, deps, doc_to_add))
            buffer = []
            mode = ""
            continue
        mo = re.match(TARGET_PATTERN, line)
        if mo:
            if len(buffer) == 0:
                continue
            var = mo.group(1)
            sep = mo.group(2)
            deps = mo.group(3).strip()
            if mode == "overridable":
                targets.append((var, sep, deps, buffer))
            elif mode == "readonly":
                targets.append((var, sep, deps, buffer))
            buffer = []
            mode = ""
            continue
        mode = ""
        buffer = []

res = {
    "variables": variables,
    "targets": targets,
    "has_targets_ready_to_use": len([x for x in targets if x[1] == ":"]) > 0,
    "has_targets_overridable": len([x for x in targets if x[1] == "::"]) > 0,
    "has_variables_readonly": len([x for x in variables if x[1] == "readonly"]) > 0,
    "has_variables_overridable": len([x for x in variables if x[1] != "readonly"]) > 0,
}
print(json.dumps(res, indent=4))
