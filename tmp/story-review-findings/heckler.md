# Review findings: agents/story-review-heckler.md (claude-whisperer, individual review)

1. High. Lines 84, 60, 116-117. The bar says every step of the reasoning must rest on something the bible states, but medium confidence is defined as "one step ... likely rather than stated" and low as depending on "a reading of the rule's wording", which line 60 forbids. No line divides "too vague" (the vague-rules list) from "a reading of the wording" (a low finding). Fix: make the bar match the scale: "each step rests on the bible's wording; where one step is likely but not stated, say which one and cap confidence at medium". Remove "a reading of the rule's wording" from the low level, so ambiguous wording always goes to `Vague rules the plot leans on:`.

2. High (for crime, contemporary, historical). Lines 37, 61 against 45, 78, 84. Unclear whether real-world background (police, phone records, CCTV) counts as a rule when the bible never states it. (See the roster-wide decisions: real-world capabilities the bible does not state are the real-world-accuracy lens's; this lens takes them once the bible states the capability. Change the line 37 questions and the line 61 example to match.)

3. Medium. Lines 51-53, 71, 99. No rule for consequences the bible never addresses ("no lord buys years from the poor"): line 71 reads as handing them to coverage, and `Breaks:` needs a quote that does not exist. Fix: state that a consequence a stated rule implies for the world is this agent's even when the bible says nothing about it. Allow `Breaks:` to name the entry whose picture of the world it should change, or "not addressed". Narrow line 71 to "a rule the plot needs and no entry states at all".

4. Medium. Lines 59, 72. "The bible gives a reason" does not say whether a character trait counts. Fix: count a reason only when the bible connects it to this route or this kind of route. When closing the hole would take a judgement about personality, report the hole, name the trait in `Reasoning:`, and leave whether it suffices to the character lens.

5. Medium. Lines 60, 71, 121. The `Vague rules the plot leans on:` section earns its place as a record of what could not be tested, but line 71's "is yours" collides with coverage. Fix: present it as untested because the wording does not decide the case. Replace "is yours" in line 71 with "list it as untested; whether the bible should say more is coverage's question".

6. Medium. Line 3. The description misses how authors ask for this lens. Fix: add "plot holes the world's rules create" and "whether a magic system, technology or institution holds up" to the "Use only when" clause, within the word limit. (See the roster-wide decisions on "plot holes".)

7. Low. Lines 9, 70. Direct violations (an outline step doing what a rule plainly forbids) are claimed by continuity too. Fix: add to line 70: "An outline step that does what a rule plainly forbids is continuity; yours begins where getting from the rule to the problem takes a step of inference."

8. Low. Lines 45, 56-64. No check on when a rule applies. Fix: add "when the rule, ability or resource came into being, and who had it at that date" to the list of things that close a hole.

9. Low. Lines 39-43, 27. Nothing covers a bible with no outline. Fix: "If there is no outline, run the world and edge tests only and say so in your opening line."

10. Low. Lines 64, 103. The `Question:` field can carry the patch. Fix: add "state the question openly, without listing possible answers."

11. Low. Line 63. "treats as true" vs "confirms" for in-world beliefs cannot be told apart. Fix: "test it where the outline relies on it; low confidence unless an entry written as canon states it."
