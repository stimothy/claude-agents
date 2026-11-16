# Story-review roster: review findings (applied 2026-11-16)

Reviews by `claude-whisperer` on 2026-11-15 of the ten `agents/story-review-*.md` files written that day. One file per agent, condensed from each review, with line numbers as they stood at commit `e457fb8`. These findings were applied on 2026-11-16 as settled in `decisions.md`; the applied files have not been re-reviewed. `roster.md` holds the review of all eleven files as a set.

`story-review-archivist` was reviewed earlier the same day and its six findings were applied before the other ten were written from it. It has no file here; what it still needs is in `roster.md`.

## Counts

| Agent | High | Medium | Low | Main finding |
|---|---|---|---|---|
| heckler | 2 | 4 | 5 | Its confidence scale allows findings its own bar forbids |
| dramaturg | 2 | 3 | 3 | Its checklist brings back the beat-sheet template it is told not to impose |
| oathkeeper | 1 | 4 | 3 | Genre expectations have no limit, so it would enforce tropes and beats |
| stranger | 1 | 4 | 6 | The caller's brief leaks the story; a model cannot "set aside" what it read |
| librarian | 1 | 1 | 3 | An unmarked superseded version sits on both sides of its line with the archivist |
| shrink | 0 | 4 | 2 | It lost the split between reviewing a change and reviewing the whole bible |
| cartographer | 0 | 3 | 7 | Chapter mode asks for findings its format cannot hold |
| stylist | 0 | 3 | 3 | Its checklist reintroduces show-don't-tell; rewrite-on-request undoes the no-rewrite rule |
| scholar | 0 | 3 | 5 | "Confident" has no test, so wrong corrections are not well guarded |
| turing | 0 | 5 | 5 | Its low tier lets an em-dash finding into nearly every review |

## Decisions that span files

Several per-file findings say "see the roster-wide decisions". These need one answer each, stated the same way in every file they touch. Recommendations are the session's, not yet confirmed by the owner.

1. "Plot holes" is claimed by no description. Recommended: the heckler claims "plot holes the world's rules create"; the dramaturg claims "steps nothing causes"; the cartographer says "missing facts, not loopholes".
2. A chapter review that names no lens has no owner. Recommended: the stylist takes it, as the archivist takes an unnamed bible review.
3. Real-world capabilities the story ignores (nobody checks the CCTV in a present-day crime novel, and the bible never says it exists). Recommended: the scholar owns them while the bible does not state the capability; the heckler owns them once it does.
4. Passive protagonist and arc with no cause, claimed by both shrink and dramaturg. Recommended: the dramaturg owns a climax or turn the protagonist's choices do not cause; the shrink owns a character with no want that would lead to a choice, and an arc whose change nothing in the outline causes.
5. Pacing in manuscript chapters. Recommended: the stylist owns how a scene paces its own moments on the page; the dramaturg owns proportion across chapters; the stranger reports where attention dropped without diagnosing it.
6. Stale entries, between librarian and cartographer. Recommended: stale (competes with a current entry and could be read as canon) is the librarian's; unused material that fits the current story is the cartographer's.
7. Superseded versions, between librarian and archivist. Recommended: if the page marks or positions one statement as older, it is the librarian's; if both read as current canon, it is the archivist's.
8. Anachronistic words, between scholar and stylist. Recommended: the scholar owns when a word entered the language; the stylist owns whether it suits the voice.
9. Rewrites on request. Recommended: no story reviewer rewrites; the stylist's exception is removed and the turing declines in its opening line.
10. Web access for the scholar. Owner's decision; it is offline as written.

## How to apply

The method that worked for the code roster: one `claude-wordsmith` run per file, each given its findings file plus one shared text for the decisions above, then a set review afterwards.
