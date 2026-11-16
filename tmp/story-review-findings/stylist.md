# Review findings: agents/story-review-stylist.md (claude-whisperer, individual review)

1. Medium. Lines 51, 49, 53, 40, 58, 83, 111. The "author's standard" guard at line 58 is clear, but the checklist and the bar bring the workshop rules back: "The particular" (51) is show-don't-tell, the knife fight in long sentences (49) is "short sentences for action", line 40 says to Grep for "a filter verb"; the bar (83) asks for the author's pattern only for a departure from voice, and "pulled out of the story" fits almost anything; "Reread the passage ... until you can" pushes the model to argue itself into a finding. Fix: apply line 53's pattern (Distance: "where the book otherwise stays close") to every craft item that is not a plain reader failure (rhythm, the particular, pacing, cliche, filtering): report it only where the book elsewhere does otherwise, or where the reader actually loses something (misreads, loses track, rereads). Say in the bar that "pulled out of the story" needs one of those two grounds. Drop "a filter verb" from line 40. Change "Reread ... until you can" to "read more of the surrounding text".

2. Medium. Line 15 (last sentence), 102; description line 3. The explicit-request exception undoes the no-rewrite rule: the caller is a delegating model so "explicitly" is a guess, the stated reason still applies, the output form has no place for rewrites and line 102 says "never replacement text". The description's "line ... review" attracts line-edit requests. Fix: delete the last sentence of line 15 and add "Describes problems; never rewrites." to the description. (See the roster-wide decisions.)

3. Medium. Line 3. No agent claims a manuscript review that names no lens ("review chapter 5"). (See the roster-wide decisions for the owner chosen.)

4. Low. Line 9. "Every other reviewer of the story reads for what it says; you read for how it is said" is false for the machine-patterned-writing and intent lenses. Fix: delete the sentence.

5. Low. Lines 40, 98. Grep count mode counts matching lines, not occurrences, and a prose paragraph is often one line. Fix: add "count mode counts lines, not occurrences; use `-o` with content output when one line can hold several".

6. Low. Lines 35, 74. A style note about tone can produce the same finding as the intent lens. Fix: at line 74 say that this lens judges sentences against the stated voice, while whether a whole chapter's tone matches the stated tone is the intent lens's.
