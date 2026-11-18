---
name: handling-review-feedback
description: Use when receiving code review comments (from a colleague, a merge request, or a /code-review run) - before applying any of the suggested changes.
---

# Handling Review Feedback

Adapted from obra/superpowers `receiving-code-review` (MIT, see LICENSE-superpowers.txt).

**Core rule: check each comment against the code before acting on it.**
Reviewers, both human and AI, can be wrong, miss context, or propose changes
that don't fit an embedded target.

For each comment:

1. **Restate it** in your own words. If it is unclear, ask, and don't implement
   your guess.
2. **Check it against the code:** read the referenced lines and their callers.
   Is the issue real? Can you show it (input, sequence, interleaving)?
3. **Classify:**
   - *Correct:* fix it, keeping the change minimal and in scope.
   - *Partly correct:* fix the real part and explain the rest.
   - *Incorrect or not applicable:* push back with evidence (file:line,
     spec section, test result). Don't make the change just to agree.
   - *Out of scope* (refactor, style preference, release branch): note it as
     a follow-up and don't do it now.
4. Watch for suggestions that are fine on a desktop but not on target:
   dynamic allocation, recursion, large stack buffers, extra copies in hot
   paths, new dependencies, behaviour changes on the wire.

Then apply the accepted changes one by one and run `verify-before-done`.

Report back as a short list: comment -> accepted / rejected (why) / deferred.
No performative agreement ("great catch!"). Just state the result.
