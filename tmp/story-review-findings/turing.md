# Review findings: agents/story-review-turing.md (claude-whisperer, individual review)

1. Medium. Lines 124, 180, 186, 151. The "low" severity tier ("scattered instances most readers would pass over") and low confidence for the em dash "however frequent" give a ready slot for exactly what the density rule at line 124 excludes; the bar (151) needs only a name, quotes and a count. An em-dash finding will turn up in nearly every review. Fix: redefine low as "a pattern that clears the density bar but sits in one passage or is a weak tell". In the bar, say a pattern reported alone must clear line 124. Say em dashes, transitions and tricolons are reported only inside a cluster with other tells, or where the rate is plainly above the rest of the same text, never on their own.

2. Medium. Lines 111-113, 178. "A default name on a main character" is the example of high severity, against "one proves nothing". The role-based surname item ("Chen for a software developer or Okafor for a doctor") risks flagging a surname because of the heritage it carries. Fix: the high example becomes "several default names or settings among the main cast". One default name alone is reported only as part of a set. A role-matched surname counts only when several characters show the same name-by-role habit.

3. Medium. Lines 120, 176-180. Chatbot residue can be rated low because severity measures spread, though it is the one thing the author must fix before anyone sees the text. Fix: add to high: "any chatbot residue, unfilled placeholder or note to a user in text meant for the page, whatever the count".

4. Medium. Lines 3, 9, 153, 188. A clean result will be relayed as "human-written". Fix: in the empty-result line add: "This says nothing about who wrote the text; a revised machine draft can read clean." When the caller asks outright whether AI wrote the text, the opening line states that this review cannot answer that and reports patterns instead.

5. Medium. Lines 32, 39. Grep advice misses result truncation (content output is capped by default at 250 results) and the cost of `-o` over a whole novel; a bare `--` also matches YAML frontmatter, Markdown rules and table separators. Fix: take per-file count-mode figures for the whole target (a lower bound on occurrences); use `-o` only on the densest files and with head_limit 0; check for a truncation notice. Give the class `['’]` for apostrophes. Write the double hyphen as `[-]{2}` and exclude lines that are only dashes.

6. Low. Lines 39, 46, 80-81, 111-112. The checklist will act as a search list, and the text's own repeated tics are never searched. Fix: after the first reading pass, Grep the whole target for stock gestures and phrases found recurring in this text, and give those counts priority over listed vocabulary. Say listed words alone, outside any cluster, are not a finding.

7. Low. Lines 50-55, 140. The "tidy single-thread plot" default that line 140 refers to is missing from the checklist. Fix: add one bible shape-tell bullet: "a single causal chain with no subplot and a tidy resolution"; and one fiction-habits bullet: "conflict resolved quickly in the protagonist's favour; dialogue used for philosophical debate". Both low confidence; the structural judgement stays with the structure lens.

8. Low. Lines 3, 28. With nothing named, it reviews the bible when the request is probably about the manuscript. Fix: when nothing is named and a manuscript exists, return and ask whether to review the bible or which chapters (as the prose lens does).

9. Low. Lines 17, 130. Explicit requests for rewrites are not handled. Fix: "If the caller asks for rewrites, decline in the opening line and give the reason in one clause."

10. Low. Lines 85, 88, 124-125, 182-186. The reliability tiers are stated twice and the em-dash caveat four times. Fix: keep the tiers at line 125; have the confidence scale say "high, medium and low follow the three tiers in 'Judgment before you report'"; state the em-dash caveat once.

Not findings: the checklist's length is worth keeping (it is the payload, and it loads only when run); the boundary with the prose lens agrees from both files.
