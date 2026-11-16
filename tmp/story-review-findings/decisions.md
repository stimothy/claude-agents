# Story-review roster: settled decisions for the fix round

Written 2026-11-16. This is the one answer to every question that spans files. Where a per-file findings file or `roster.md` says something different, this file wins. Each boundary is written here once; both files on either side of it state it in these terms, each from its own side.

Lens names used in the bodies: continuity (archivist), rule implications (heckler), coverage (cartographer), character (shrink), structure (dramaturg), intent (oathkeeper), cold read (stranger), prose (stylist), real-world accuracy (scholar), working document (librarian), machine-patterned writing (turing). Bodies refer to other lenses by lens name, as they do now; descriptions use agent names.

## Routing and descriptions

D1. Unnamed reviews.
- An unnamed review of a story bible, or of an outline (the outline is part of the bible), is the archivist's. Unchanged.
- An unnamed review of manuscript chapters ("review chapter 3") is the stylist's. The stylist's description says so: for example "Use for a prose, line or style review, or to review a chapter or scene when no lens is named."
- The stylist's description drops the archivist pointer. The stranger's description replaces its archivist pointer with "a chapter review that names no lens is story-review-stylist's".
- The other eight non-archivist descriptions keep "A story-bible review naming no lens is story-review-archivist's" (the librarian restores the dropped "story-bible").

D2. "Plot holes". Only the heckler's description uses the phrase: "plot holes the world's rules create". The heckler's body says in one sentence that contradictions between stated facts are continuity's and steps nothing causes are structure's, so a caller asking for plot holes in general can run all three. The dramaturg's description does not use the phrase "plot holes"; it may say "steps nothing causes". The cartographer's body says it reports missing facts, not loopholes.

D3. Pacing.
- Dramaturg: owns pacing across scenes and chapters, in an outline or a manuscript: each movement's share of the length against what happens in it, and scenes that do no structural work. Its description includes the word "pacing".
- Stylist: owns pacing within a scene, how the scene paces its own moments on the page. Its description and boundary line say "pacing within a scene".
- Stranger: reports where attention dropped, as experience; the diagnosis is structure's.
- Oathkeeper: drops "a thriller's pace" as an example.

D4. Description wording.
- Cut "otherwise it reviews the whole bible" from every description; the bodies already say what happens when nothing is named.
- The archivist's "Not for ..." list becomes about 15 words or fewer, for example "Continuity only; the other lenses are the other story-review agents."
- Keep every description at or under 70 words.

## Boundaries between two lenses

D5. Passive protagonist (shrink / dramaturg).
- Dramaturg: a climax or turn that the protagonist's choices do not cause, and a protagonist the plot carries.
- Shrink: a character with no want that would lead to a choice; an arc whose change nothing in the outline causes; whether a choice the character does make fits them.
- Each file states the other side in one sentence. Neither reports the other's case.

D6. Real-world capabilities the story ignores (heckler / scholar). An ability, technology or institution the bible states is the heckler's. A real-world affordance the bible never states but the story's real setting supplies (CCTV, phone records in a present-day crime novel) is the scholar's, reported as procedure or practice at no more than medium confidence.

D7. A stated reason a character does not take a route (heckler / shrink). Where the bible gives a reason a character does not take a route the rules allow, whether that reason fits the character is the shrink's. The heckler treats a stated reason as closing the route and does not judge its fit.

D8. A rule too vague to settle an outline step (heckler / cartographer). The cartographer's, as a missing fact. The heckler keeps `Vague rules the plot leans on:` only as a note of what it could not test.

D9. Dangling names, stale and superseded entries (cartographer / librarian / archivist).
- Librarian: an explicit link, path or "see X" that does not resolve, or a renamed target; an entry that the page marks or positions as older, or that competes with a current entry and could be read as canon; whether a search would miss one spelling of a name; whether undecided or in-world material is marked as such.
- Cartographer: a name used in prose with no entry anywhere; material that is current and unused. It skips evidently superseded material.
- Archivist: two statements that both read as current canon and disagree, including a name spelled two ways. It reports unmarked undecided or in-world material only where it makes two canon statements disagree.

D10. Anachronistic words (scholar / stylist). The scholar owns whether a word, idiom or thing existed in the period, as a fact. The stylist owns words that jar against the established voice, whatever their date.

D11. Genre endings (dramaturg / oathkeeper). The dramaturg uses the evident genre only to tell design from fault; a broken genre convention as such is the intent lens's.

D12. A skill used at the climax that nothing sets up (cartographer / dramaturg). When the bible states the skill, it is the dramaturg's (the outline needs a setup). When the bible does not state it, both may report: the cartographer that the bible lacks it, the dramaturg that the outline lacks a setup.

D13. Machine-patterned writing in other files. Every "What is not your job" list that lacks it adds: "Machine-patterned writing: wording, constructions and stock details that mark text as model-written."

## Shared text, identical in every file that has it

D14. Cold-read line in "What is not your job" (all files except the stranger and the stylist): "A cold read of an outline or chapters by someone who has not read the bible." The stylist keeps its own longer line.

D15. Pasted text. Every file's "What to return" has, after the format block: "For pasted text with no path, locate by paragraph number within the paste."

D16. Change-scope rule. The wording the files use is "repeats, relies on or newly exposes" (each lens adapts the start to its own subject). The dramaturg removes "worsens"; the scholar restores "or newly exposes".

D17. Output field names.
- `Question for the author: <one sentence, or "none">` in heckler, cartographer, shrink, dramaturg and scholar.
- `Kind of change:` in stylist and librarian.
- The shrink's `Gap:` becomes `Mismatch:`.
- `Already in the bible:` for bible targets everywhere; the turing uses `Already in the text:` only for manuscript targets.
- Lens-specific explanation fields stay as they are.

D18. Severity. The turing says: "Machine-patterned writing is never critical; nothing in the story breaks."

## Behaviour

D19. No story reviewer rewrites prose, on request or otherwise. The stylist's rewrite-on-request exception is removed. A reviewer asked for rewrites declines in its opening line and gives the reason in one clause. `Kind of change:` describes a change in general terms and never gives replacement text.

D20. The scholar stays offline: no WebSearch or WebFetch. Tools stay `Read, Grep, Glob`.

D21. Tools, models and effort are unchanged in every file. All reviewers stay read-only.

## Not in this round

- `roster.md` finding 19's check script (grep the eleven files for the shared sentences). This file is the canonical boundary table it asks for.
- A per-roster install option in `scripts/install.sh`.
