# Review findings: agents/story-review-stranger.md (claude-whisperer, individual review)

1. High. Lines 3, 16. The caller's brief is the likeliest leak: a delegating model that has read the bible adds background, and the agent cannot forget it. Fix: add to the description: "Pass only file paths or the text itself; say nothing about the story, since anything you explain it cannot report as unclear" (keep the description within the word limit by trimming elsewhere). In the body, have the agent say in its opening line that the brief described the story, if it did.

2. Medium. Lines 16, 24, 34. "Set aside what you saw" (the caller's account, rules in context, a bible file opened by mistake) cannot be done by a model. Rules files are a real channel: `omitClaudeMd` drops CLAUDE.md but, as far as the reviewer knows, not `.claude/rules/`, and a rule scoped to manuscript paths loads when chapter 1 is read. Fix: replace "set aside" with a test: "Before treating a name, term or motive as understood, find the line on these pages that established it; if you cannot, report it as not understood, whatever else you know." The opening line says whether rules, the brief or an opened bible file told it about the story. At line 34: "stop reading at the point you recognise it as reference material."

3. Medium. Lines 40, 44. The sequential read does not happen with a whole-file Read: the whole chapter is in context before the first note. Fix: read long files in parts with Read's offset and limit (a scene or about 150 lines at a time) and write notes for each part before the next call. Pasted text arrives whole; say that the agent should then note honestly when a reaction came after seeing more.

4. Medium. Lines 32, 46, 50, 119. Mid-book reading is inconsistent: "Discount" (50) vs low-confidence reporting (119); the "end of the opening" belief statement does not exist for chapter 7; a diff to chapter 12 is a read from the middle but is not linked to those rules; the belief statement is given three times (46, 59, 95). Fix: choose "report them at low confidence, saying the earlier chapters may settle them". For a read from the middle, the opening is the first scene read. At line 32, a chapter read for a diff is a read from the middle unless it is the first. Keep the belief statement at line 46 and in the return format; cut it from line 59.

5. Medium. Lines 30, 34. "Say so and ask" does not say whether to stop or go on, and a subagent cannot ask mid-run. Fix: line 34: "skip it, name it in the opening line, and review the rest; return without reviewing only if nothing readable remains." Line 30: "use the order the caller listed and say so".

6. Low. Lines 44 (last sentence), 67 (last sentence), 108-113. Capping recall-based tracking at low severity contradicts the severity scale. Fix: "rate it by what a reader who missed that mention would lose, at no more than medium confidence." Cut the "turn back" sentence or merge it into this one.

7. Low. Line 32. Rebuilding a stitched text from a mismatched diff gives a page no reader will see, and the old side tells the agent what the passage used to say. Fix: "If the file contains the diff's new side, read the file; otherwise read the new side alone as fragments and say so. Use the old side only to find where the change sits."

8. Low. Lines 15, 30. Glob on a broad named directory shows bible file names. Fix: "Glob only inside the directory you were given, for chapter files; if it holds reference material as well, list only what you will read."

9. Low. Lines 64, 87. "Experience, not diagnosis" is mislabelled: the bar requires naming the feature of the page that caused it. Fix: "Report what happened and what on the page caused it, never what should change."

10. Low. Lines 87, 105. The bar demands an assumption the format lets you skip. Fix: at line 87, "and, where you made one, what you assumed".

11. Low. Line 3. The description misses "beta read". Fix: add "beta-reader" to the trigger list.
