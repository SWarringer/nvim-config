---
name: verify-before-done
description: Use before claiming a change is done, fixed, working or passing, and before committing or asking for review - requires fresh build/test evidence and a clear split between what was verified and what still needs hardware.
---

# Verify Before Done

Adapted from obra/superpowers `verification-before-completion` (MIT, see LICENSE-superpowers.txt).

**Core rule: no claim of success without evidence from a run you did in this turn.**
"Should work", "looks correct" and earlier runs are not evidence.

## The gate

Before saying something is done, fixed or passing:

1. **Identify** which commands prove it. Use the project's documented
   commands (AGENTS.md / CLAUDE.md "Build and Test" / "Before Submitting").
2. **Run** them fresh and in full.
3. **Read** the output: exit code, warning count, failure count.
4. **Report** the actual result, with the evidence.

## What usually needs to run for a firmware change

Choose the set that matches the change. If you skip something, say so and why:

| Change touches | Run |
|---|---|
| Shared/common code | Build **every** firmware variant (e.g. both BACnet and Modbus), not only the one you worked on |
| Any C/H file | Unit tests; formatter (`fmt`) and confirm no diff left behind |
| Non-trivial C logic, pointers, buffers | Static analysis (scan-build / cppcheck if the project has it) |
| Memory layout, new buffers/tables | Compare flash/RAM usage before vs after and report the delta |
| Python tooling | Ruff (lint + format) and a quick run of the script |
| Bug fix with a unit test | Red/green check: test fails without the fix, passes with it |

New compiler warnings count as failures unless explained.

## Report format

End with an explicit split:

- **Verified here:** commands run + results (e.g. "both firmware
  variants build, 0 new warnings; unit tests 142/142 pass; fmt clean").
- **Not verified / needs hardware:** what only a device, bus analyser or HIL
  run can confirm, with concrete steps and expected observations (RTT
  output, response frames, LED pattern, timing).
- **Assumptions:** anything taken on trust that was not checked.

## Red flags

- Writing "done", "fixed" or "works" before running anything
- Relying on a subagent's "success" without checking the diff and re-running
- Treating "it compiles" as "it works" for behaviour that only shows on hardware
- Building one variant and assuming the others are fine
