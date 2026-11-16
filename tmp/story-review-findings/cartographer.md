# Review findings: agents/story-review-cartographer.md (claude-whisperer, individual review)

1. Medium. Lines 27, 85, 96-104. Manuscript mode asks for findings the bar and the Gap form cannot hold: a fact a chapter establishes has no outline step and blocks nothing. The low end of the scale ("a minor place with no description", line 133) cannot meet "cannot be written past that step" either. Fix: change the field to `Step or chapter: <path>:<line>`; give the bar a second clause for manuscript text ("or name the chapter passage and the later material an unrecorded fact is likely to collide with"); loosen "cannot be written past" so low-severity gaps can meet it.

2. Medium. Lines 31-33. No-outline mode is unclear when chapters exist, about whether an index or README listing counts as a reference, and has no form of its own. Fix: when chapters exist and there is no outline, search the chapters as in pass two; an entry a chapter uses is used. Say that index or navigation mentions do not count as references (navigation is the working-document lens's ground). Name the heading (`### Unreferenced:`) and cap its severity at low.

3. Medium. Lines 124, 135, 64. Severity for unused material is defined purely by size, which repeats the `Size:` field and outranks real gaps when reviews are merged, while line 64 says keeping it is the author's call. Fix: drop Severity from the Unused form and let Size carry the weight, or cap it at low with the reason "nothing breaks; size is reported under Size".

4. Low. Lines 52-53, 74. The boundary with structure leaks where a payoff was never set up (the shuttle-pilot example is the dramaturg's "payoff never set up"). Fix: add to line 74: "A payoff no earlier step sets up is structure's when the bible states the skill or fact; when neither bible nor outline states it, report it as a gap and do not frame it as setup and payoff."

5. Low. Lines 43, 54, 72. A rule too vague to settle a case is claimed by both this agent and the rule-implications lens. Fix: add to line 72: "A rule that is stated but too vague to settle what a step needs is the rule-implications lens's; you report a rule that is not stated at all."

6. Low. Lines 57, 80. Stale entries are not divided from the working-document lens. Fix: add to line 80: "An entry built for a version of the story the outline has left behind is stale, which is the working-document lens's; report as unused only material that fits the current story but is never used."

7. Low. Lines 59-65. The archivist's in-world-belief rule was dropped and coverage needs its own version. Fix: add a judgment bullet: "A need answered only by in-world belief (legend, rumour, a character's assumption) is not met by it; report it at medium confidence and say what the belief states."

8. Low. Line 3. The description does not say the agent finds the bible and outline itself. Fix: add "otherwise it finds the bible and outline itself", staying within the word limit.

9. Low. Line 3. "Holes in the worldbuilding" could go here or to the heckler. Fix: add "missing facts, not loopholes" or equivalent. (See the roster-wide decisions on "plot holes".)

10. Low. Line 17. The reason for not filling a gap is garbled. Fix: "a guess, once written down, tends to become canon, and the right answer often depends on plans the bible does not show."
