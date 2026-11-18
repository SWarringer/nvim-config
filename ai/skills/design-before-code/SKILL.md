---
name: design-before-code
description: Use before implementing a new feature, protocol behaviour, config option or non-trivial behaviour change in firmware or tooling, when the request leaves open decisions. Not for small, fully specified fixes.
---

# Design Before Code

Adapted from obra/superpowers `brainstorming` (MIT, see LICENSE-superpowers.txt),
cut down for incremental firmware work.

## First: is this needed?

- **The request is fully specified and small** (clear bug fix, rename,
  one-line behaviour change): skip this skill. Do the work and say what you did.
- **Something non-trivial is open** (behaviour on the wire, persistence,
  backwards compatibility, resource budget, which layer owns it): continue.

## 1. Read before asking

Read the relevant code, nearby modules, recent commits and, for protocol
behaviour, the spec section (paths in the project's AGENTS.md). You should be
able to explain how it works today and what the change would touch.
Never ask something the repo or the spec already answers.

## 2. Restate and ask

In one short message:
- Restate what you understand is wanted and why
- Mention any constraint or conflict found (spec requirement, release branch
  scope, shared code affecting other variants, flash/RAM headroom)
- Ask **one** question, the open point that would most change the design.
  Ask follow-ups one at a time.

## 3. Propose approaches

When there is a real choice, give 2-3 options. For each, state the
trade-off in embedded terms:
- Flash / RAM cost
- CPU / ISR load and timing determinism
- Concurrency and ownership of state
- Compatibility (wire protocol, stored config, app/BLE interface, other
  firmware variants)
- Size of change and test effort (unit-testable or HIL only)

Recommend one, preferring the smallest change that fits the existing
architecture.

## 4. Short design, then approval

Write the design in a few lines to a dozen: what changes, where (files/
functions), behaviour at the edges, how it will be verified (unit tests vs
hardware steps). Get explicit approval before implementing. For larger
work, use plan mode to break it into steps.

Keep it conversational and brief. Don't mention this skill or its steps to
the engineer.
