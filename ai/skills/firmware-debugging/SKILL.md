---
name: firmware-debugging
description: Use when investigating a firmware bug, failing unit/HIL test, build failure, protocol misbehaviour (Modbus, BACnet, BLE, UART), crash, hang, reset or timing problem - before proposing any fix.
---

# Firmware Debugging

Adapted from obra/superpowers `systematic-debugging` (MIT, see LICENSE-superpowers.txt).

**Core rule: no fix without a root cause you can explain and back with evidence.**
A fix that makes the symptom go away without an explanation is a guess. On
embedded targets, guesses often move a race or overflow somewhere else.

## Phase 1 - Gather evidence

1. **Read the actual output in full.** Compiler/linker errors, test failures,
   RTT log, fault handler output, assert file/line. Do not skim.
2. **Pin down reproduction.** Exact firmware variant, build, hardware/form
   factor, bus settings (baud, parity, stop bits, addresses), traffic pattern.
   Is it deterministic, rate-dependent, or timing-dependent? If it is
   intermittent, estimate the rate before changing anything. Otherwise you
   can't tell later whether a change made a difference.
3. **Check what changed.** `git log`/`git diff` since the last known good
   version or release tag. Consider `git bisect` between tags when there is a
   known-good build.
4. **Find where it breaks.** For a multi-stage path (e.g. UART ISR -> frame
   parser -> application handler -> response encoder -> TX), record what
   enters and leaves each stage before forming a theory. Typical evidence
   sources:
   - RTT / debug log (add temporary, clearly marked log lines if needed)
   - Bus capture from a test tool or sniffer
   - Unit test that drives the suspect function directly
   - Map file / `size` output for stack, heap and section overflow
   - Fault registers or reset reason after a crash or watchdog reset
5. **Trace bad values back to where they come from.** Fix at the source, not where
   the symptom appears.

**You cannot touch the hardware.** When evidence requires a device, bus
analyser or HIL run, say exactly what to run and what to look for, then
wait for the result. Don't fill the gap with assumptions.

## Phase 2 - Compare against what works

- Find similar code in the repo that works (another handler, another
  protocol, the previous release) and list every difference.
- When behaviour is defined by a spec, read the relevant section of the spec
  (the project's AGENTS.md lists where they are). Quote section numbers.

## Phase 3 - One hypothesis at a time

- State it: "I think X causes this because Y; if true, we should see Z."
- Test it with the smallest change or measurement possible. One variable at a time.
- If it is not confirmed, form a new hypothesis. Don't pile fixes on top of each other.
- Say "I don't know" or "I don't understand X" when that is the case.

Embedded suspects worth checking explicitly:
- Shared data between ISR and main/task context without proper
  protection, missing `volatile`, non-atomic read-modify-write
- Buffer/index overflow, off-by-one in ring buffers, length fields trusted
  from the wire
- Integer promotion, signed/unsigned mixing, truncation, endianness of
  multi-byte fields
- Stack overflow, uninitialised statics after a soft reset, state not
  cleared on reconnect or handover
- Timeouts/timers: wraparound, units (ms vs ticks), inter-frame timing
  (e.g. Modbus t1.5/t3.5)
- Broadcast vs unicast and "no response expected" paths

## Phase 4 - Fix

1. Where possible, get a failing reproduction first (see `test-first-firmware`):
   a unit test, or a written hardware test procedure / scratch script.
2. Make one focused change at the root cause. No "while I'm here" refactors.
3. Verify with `verify-before-done`. Say what you verified and what still
   needs hardware confirmation.
4. Remove temporary debug logging unless it is worth keeping.

## Stop and discuss

- **After 3 failed fix attempts**, stop. Repeated failures in different
  places usually mean the design is wrong (ownership of state, concurrency
  model, layering) and patching won't fix it. Present what you learned and ask
  the engineer before trying again.
- If you notice yourself thinking "just try X and see", "probably X", or
  "multiple changes at once to save time", go back to Phase 1.
- If the conclusion is "timing/environmental, no code root cause", document
  what was ruled out and how. Most "no root cause" findings turn out to be
  an investigation that stopped too early.
