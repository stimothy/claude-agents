# Review findings: the eleven story-review agents as a set (claude-whisperer)

Condensed from the set review. Line numbers as of commit `e457fb8`. Not applied.

## Routing, tested against the twenty descriptions in the repository

| Request | Where it goes | Verdict |
|---|---|---|
| review my story bible | archivist | works |
| check for plot holes | no description uses the phrase; archivist, heckler and dramaturg all fit | finding 3 |
| is my magic system broken | heckler | works |
| does chapter 3 match the bible | archivist | works |
| review chapter 3 / review my outline | nobody claims an unnamed manuscript or outline review | finding 2 |
| is the pacing off | no description says "pacing" | finding 1 |
| does this sound like AI wrote it | turing | works |
| fact-check my outline | scholar | works |
| tidy up my bible | librarian (reports only) | works |
| are my characters believable | shrink | works |
| what am I missing | cartographer | works |
| give this a fresh read | stranger | works |

No code-review or Claude-file request can land on a story agent except through the librarian's sentence (finding 4), and no story request lands on the other rosters. Minor: turing is the only agent anywhere that claims AI-isms, so a request about a README or cover letter could reach it and its body would go looking for a story bible.

## Findings

1. High. Pacing in a manuscript belongs to no lens and no description says "pacing". dramaturg:3, 28, 62; stylist:3, 54, 73; stranger:58, 78; oathkeeper:48. Fix: the dramaturg takes pacing across scenes and chapters in a manuscript (each movement's share of the drafted length against what happens in it, and scenes that do no structural work) and adds "pacing" to its description. The stylist's line 73 and description say "pacing within a scene". The stranger's line 78 adds that attention drops are reported as experience and the diagnosis is structure's. The oathkeeper drops "a thriller's pace" at line 48.

2. High (medium confidence). An unnamed review of a chapter or an outline has no default owner. Descriptions of archivist, stylist, stranger, dramaturg, turing, scholar. Fix: choose a default for unnamed manuscript reviews (the stylist is the natural one) and for an unnamed outline review (the archivist as part of the bible, or the dramaturg), and state it in that agent's description. Replace the archivist pointer in the stylist's and stranger's descriptions with that default.

3. Medium. "Plot holes" is claimed by no description and fits three. Fix: put it in one description; the heckler fits best. Have it say that contradictions are the archivist's and causality the dramaturg's, so the delegator can run all three.

4. Medium. librarian:3 says "A review naming no lens is story-review-archivist's", dropping "story-bible". Fix: restore it.

5. Medium. The archivist's file still describes a roster of one. archivist:3, 54, 55, 61-72.
   - Description: replace the "Not for ..." list with about 15 words or fewer, for example "Continuity only; the other lenses are the other story-review agents."
   - Line 68: "A cold read of an outline or chapters by someone who has not read the bible".
   - Add machine-patterned writing to "What is not your job": "Machine-patterned writing: wording, constructions and stock details that mark text as model-written".
   - Line 71: add "whether undecided or in-world material is marked as such is the working-document lens's; you report it only where it makes two canon statements disagree."
   - Line 46 or 102: a name spelled two ways is the archivist's as a contradiction; whether a search misses one spelling is the librarian's.

6. Medium. Shrink and dramaturg both claim the passive protagonist and the climax the protagonist does not decide, at different severities. shrink:52, 74, 110; dramaturg:56, 59, 79, 114-115. Fix: give it to the dramaturg as a property of the plot's chain of agency. Remove shrink's line 52 and the "makes no choice that matters" clause at 110; add to shrink's line 74: "a protagonist the plot carries, or a climax someone else decides, is structure's; whether a choice they do make fits them is yours." The dramaturg's line 79 states the reverse. (The individual reviews suggested a slightly different split: shrink keeps a character with no want that would lead to a choice. Either works if both files say the same thing.)

7. Medium. Scholar and stylist each claim an anachronistic word. scholar:50; stylist:52, 76. Fix: the scholar owns whether a word or idiom existed in the period, as a fact; the stylist owns words that jar against the established voice whatever their date. stylist:76 becomes "...whether the word or thing it names existed then is not". Add the reverse line to the scholar.

8. Medium. Real-world routes the plot ignores sit between heckler and scholar. heckler:37, 45, 78, 84; scholar:77. Fix: an ability or institution the bible states is the heckler's; a real-world affordance the bible never states but the story's real setting supplies is the scholar's, reported as procedure or practice. One sentence each at heckler:78 and scholar:77.

9. Medium. When the bible gives a reason a character does not take a route, nobody checks whether the reason fits them. heckler:59, 72; shrink:72. Fix: add to shrink:72: "Where the bible gives a reason a character does not take a route the rules allow, whether that reason fits them is yours."

10. Low. Heckler and cartographer both claim a rule too vague to settle an outline step. heckler:60, 71, 121; cartographer:54, 61, 140. Fix: give it to the cartographer; the heckler keeps `Vague rules the plot leans on:` as a note of what it could not test. Change heckler:71 and add the case to cartographer:61.

11. Low. Cartographer and librarian overlap on dangling names and superseded entries. cartographer:33, 47, 56, 57, 80; librarian:50, 51, 53, 61, 71. Fix: an explicit link, path or "see X" that does not resolve, or a renamed target, is the librarian's; a name used in prose with no entry anywhere is the cartographer's. The cartographer skips evidently superseded material as the librarian's staleness and reports as unused only material that is current and unused.

12. Low. Dramaturg and oathkeeper both reach a genre ending that breaks its promise. Fix: add to dramaturg:80: "you use the evident genre only to tell design from fault; a broken genre convention as such is the intent lens's."

13. Low. A skill used at the climax that nothing sets up is claimed by both cartographer (53, 74) and dramaturg (55, 78). Fix: the dramaturg's when the bible states the skill; both may report when it does not (the fixes differ: add the skill to the bible, or add a setup to the outline). One sentence in each.

14. Low. Nine files describe the cold read as covering only the premise and outline: archivist:68, heckler:75, cartographer:76, shrink:76, dramaturg:81, oathkeeper:79, scholar:82, librarian:75, turing:142. Fix in all nine: "A cold read of an outline or chapters by someone who has not read the bible."

15. Low. Output field names for the same thing differ. Fix: `Question for the author: <one sentence, or "none">` in heckler, cartographer, shrink, dramaturg, and added to the scholar's format. `Kind of change:` in both stylist and librarian. Rename shrink's `Gap:` (the cartographer's word) to something like `Mismatch:`. Keep lens-specific explanation fields as they are.

16. Low. Small differences in shared sentences that change behaviour.
    - The dramaturg adds "worsens" to the change-scope rule (86, 129). Add it to all ten or remove it.
    - The scholar drops "newly exposes" (86, 131). Restore it.
    - The turing uses `Already in the text:` even for bible entries (147, 190). Use `Already in the bible:` for bible targets.
    - Only the stylist (105) says how to locate findings in pasted text with no path. Add its paragraph-number sentence to every file.

17. Low. The turing drops `critical` without saying so. Fix: add "Machine-patterned writing is never critical; nothing in the story breaks."

18. Low. Words in the descriptions that route nothing. The eleven descriptions total about 690 words; all twenty in the repository about 1,200, loaded in every session of every project. The archivist pointer costs about 95 words across ten descriptions and is useless in the stylist and stranger. "otherwise it reviews the whole bible" appears in three descriptions though five more bodies behave the same way. Fix: replace the pointer in stranger and stylist with the manuscript default, shorten the archivist's list, and add the "otherwise" clause to every bible lens or cut it from all.

19. Low. About 9,000 of the set's 28,000 body words are shared skeleton copied by hand, and the boundary sentences are written separately in two files each; findings 5 to 14 are that drift. Fix: keep a canonical boundary table and skeleton text in the repository outside `agents/`, write both sides of each boundary from it, and add a simple check that greps the eleven files for the shared sentences.

## Checked, no finding

Archivist/heckler, archivist/cartographer, shrink/cartographer, heckler/dramaturg, stylist/turing, oathkeeper/stylist, shrink/turing, dramaturg/turing, and the stranger against the rest. Tools and models are consistent and fit; the librarian on sonnet suits inventory work.

## Outside the eleven files

`scripts/install.sh` links every agent, so code-only users get about 690 words of story descriptions in every session; a per-roster install option would remove that. The README's agent tables do not list the story roster.

## Which findings touch which file

- archivist: 2, 3, 5, 14, 18
- heckler: 3, 8, 9, 10, 14, 15
- cartographer: 10, 11, 13, 14, 15
- shrink: 6, 9, 14, 15
- dramaturg: 1, 2, 3, 6, 12, 13, 14, 15, 16
- oathkeeper: 1, 12, 14
- stranger: 1, 2, 18
- stylist: 1, 2, 7, 15, 16, 18
- scholar: 7, 8, 14, 15, 16
- librarian: 4, 5, 11, 14, 15
- turing: 14, 16, 17
