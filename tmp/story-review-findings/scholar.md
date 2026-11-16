# Review findings: agents/story-review-scholar.md (claude-whisperer, individual review)

1. Medium. Lines 37-46, 107, 119. "Confident" has no test, so the three-way sort depends on the model's self-assessment, worst exactly where wrong corrections come from (dates, office holders, popular myths, claims true for a niche case). Line 107's "as far as you know" invites a hedged fact inside a finding. Fix: add a test that shows in the output. Before a finding, (a) state the correct fact without hedging, at the precision you actually know, and (b) try to name a period, place, technology or reading under which the story's claim would be true. If (a) fails, or (b) succeeds, put it under `Worth verifying:`. Change line 107 to "<what is actually the case, stated briefly>". Also say the sort is a precedence: "check in this order; the first that fits wins", so a suspected error in a specialised area lands in `Worth verifying:`.

2. Medium. Lines 86, 131. The scope rule dropped "newly exposes". A change that moves the period, place or realism level makes untouched entries wrong, and they would be demoted to `Already in the bible:`. Fix: restore "or newly exposes" in both places, and add: when the change alters the period, place or level of realism, check the whole bible's claims against the new setting.

3. Medium. Lines 37, 48-60, 77. Real-world capabilities the story ignores (nobody checks the CCTV or phone records in a present-day crime novel, and the bible never says they exist) fall between this agent and the rule-implications lens. Fix: this lens owns what real institutions, technology or procedure in the stated setting would do that the story ignores, where the bible does not state it; the rule-implications lens owns it once the bible states the capability. Add a "What you look for" item with that example, reported at no more than medium confidence.

4. Low. Lines 51, 53. Two examples over-generalise. Fix: "a pregnancy visibly showing two weeks after conception" and "an eighteenth-century merchantman that crosses the Atlantic in three days".

5. Low. Lines 46, 127. The ban on invented citations covers corrections only. Fix: "Never invent a citation, title, date, statute, statistic or name anywhere in the review." At line 127: "kind of source, not a specific title unless you are sure it exists".

6. Low. Lines 68, 70, 100-110. The question for the author and the pointer to a sensitivity reader or expert have no place in the format. Fix: add `- Question: <one sentence, or "none">` to the template; the expert-check pointer goes there or under `Outside what I can judge:`.

7. Low. Lines 106, 119-123. `Confidence` here means whether the error applies to this story, which a reader will take as doubt about the fact. Fix: rename the field `Applies to this story: high | medium | low`. Say that a local exception you can name belongs in medium, and local practice you cannot judge goes under `Outside what I can judge:`.

8. Low. Lines 50, 83. Anachronistic words are claimed by both this agent and the prose lens. Fix: this lens owns when a word entered the language; the prose lens owns whether it suits the book's voice. State that under "What is not your job".

Design question (not applied; owner's decision): the reviewer leaned toward giving this agent WebSearch and WebFetch, with instructions to search only general facts and never quote manuscript text or invented names, cite only pages fetched, and search only claims that would otherwise go under `Worth verifying:`. Keep the agent offline unless told otherwise.
