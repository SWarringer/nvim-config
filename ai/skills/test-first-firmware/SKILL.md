---
name: test-first-firmware
description: Use when fixing a bug or adding logic in firmware or its test tooling - decides whether to write a failing unit test first or a hardware test procedure, and how to prove the test actually catches the problem.
---

# Test First (Firmware Edition)

Adapted from obra/superpowers `test-driven-development` (MIT, see LICENSE-superpowers.txt).
This version is relaxed on purpose: strict TDD doesn't fit behaviour that can
only be observed on hardware.

## Decide which kind of test fits

**Unit-testable** (pure or mostly-pure logic: parsers, encoders, CRC, state
machines, range/limit checks, conversions, buffer management):
-> Write the failing unit test **before** the fix. This is the default.

**Hardware-bound** (ISR timing, peripheral drivers, radio/BLE, real bus
traffic, power/reset behaviour):
-> Write a reproducible test procedure or scratch script first: setup,
stimulus, expected vs actual observation. Hand it to the engineer to run.
If the logic can be pulled out into a unit-testable function with a
**small** change, propose that, but don't refactor just to make it testable
without asking.

**Mixed:** unit-test the logic part and write a procedure for the rest.

## Unit test loop

1. Find the project's test framework and conventions first (read the unit
   test README, then copy the nearest existing test file). Don't invent a new
   structure.
2. **Red:** write the smallest test that shows the bug or the missing
   behaviour. Run it and **confirm it fails for the expected reason** (not
   a compile error, not a different assert).
3. **Green:** make the minimal change that makes it pass.
4. Run the full unit test suite, then go to `verify-before-done`.
5. If you wrote the fix before the test: revert the fix, confirm the test
   fails, restore the fix, confirm it passes. A test that was never seen
   failing proves nothing.

## What makes a good test

- One behaviour per test, named after the behaviour
- Covers the edges that matter on embedded targets: zero/max length, boundary
  register addresses, wraparound, invalid input from the wire, broadcast
  vs unicast
- Tests real code, not mocks of the code under test
- Deterministic: no dependence on wall-clock timing

## Don't

- Write tests that pass straight away and call them regression tests
- Change a test's expectations to make a broken implementation pass
  without discussing it
- Add test-only hooks to production code without asking. They cost flash
  and add review effort.
