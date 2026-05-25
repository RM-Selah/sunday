# Sunny — Rostering Intelligence Plan

Research report on worship-team rostering, the competitive landscape, and a concrete engineering plan for making Sunny dramatically more intuitive than every existing tool. Produced 2026-05-25 from a deep-dive research pass.

> Every claim is tagged **[sourced]** (well-attested in worship-tech writing / product docs), **[domain]** (widely-accepted practice in worship-team culture), or **[opinion]** (synthesis). Treat **[sourced]** with healthy skepticism until you've verified externally.

---

## 1. Best practices for worship-team rostering

**Load balancing & burnout**
- Three-week-on / one-week-off is the most commonly-cited cadence for volunteer musicians; back-to-back leading weeks is the single biggest predictor of burnout among Worship Leaders specifically. **[domain]**
- "Once a month" is the *floor* for FLV / instrumentalists at large churches and the *ceiling* at small churches — the same number means opposite things depending on team depth. The right metric is **% of services per quarter**, not raw service count. **[opinion]**
- Burnout isn't just frequency — it's **stacking**. A WL who leads two Sundays + a midweek youth night + a funeral in the same week is cooked even if her "Sundays this month" count is 2. The system needs to track *all roles, all events, all venues* — not just Sunday count. **[domain]**
- Rest after high-stakes services (Easter, Christmas Eve, conferences, camps) is a known practice: a "decompression week" the Sunday immediately after. **[domain]**

**Skill mix & chemistry — what "a good team" actually means**
- A working band needs (i) a clear **time-keeper anchor** — usually Drums + Bass who've played together a lot — and (ii) a clear **harmonic anchor** — usually MD + Keys 1 or WL + Acoustic. If both anchors are weak the same week, the team falls apart no matter who's on FLV. **[domain]**
- WL ↔ Drummer chemistry matters more than WL ↔ CO-WL chemistry. The WL is taking dynamic cues from the drummer constantly. **[opinion, strongly held by working MDs]**
- Vocal blend is **chordal** — sopranos pair well with certain altos, certain tenors clash with certain altos. Worship pastors usually *know* which two FLVs sound good together and which two don't, but it's tribal knowledge. No tool today captures this. **[domain]**
- "New-to-team" musicians should never debut with another new-to-team musician in the same rhythm-section seat. (Drummer's first Sunday + bass player's first Sunday = train wreck.) **[domain]**

**Family / relational constraints**
- **Spouses** are usually a *neutral* — sometimes preferred (shared car, kid logistics solve themselves), sometimes avoided (one wants the other to have a Sunday off in the congregation). Don't *default* either way — make it an opt-in preference per couple. **[opinion]**
- **Parent + child** in the same band is common and usually fine, BUT a parent leading their own child as FLV often produces a power-dynamic that's awkward for the child. Worth flagging, not forbidding. **[domain]**
- **Dating couples** are the genuinely tricky one — if they break up, they can't be rostered together for a season. The system needs a private "do not pair" flag visible only to the pastor. **[domain]**
- **Siblings** are usually a positive (built-in rehearsal at home). **[opinion]**

**Rest rotation & ramp-up**
- The Tier-3 (developing) musician shouldn't play more than 1 service in a row without a Tier-1 anchor in the same role family. A new drummer next to a new bassist next to a new keys = chaos. **[domain]**
- "Shadow Sundays" — a developing musician sits with in-ears beside the rostered player without being rostered — is the most under-used development tool in worship culture. The tool should be able to *roster a shadow*. **[opinion]**

**Special services**
- Easter, Christmas Eve, baptism Sundays, vision Sundays, guest-speaker weeks — these all want **A-team + extras** (more FLVs, sometimes a string player, second guitar). The auto-builder needs a "service weight" concept; not all Sundays are equal. **[domain]**
- Kids/youth services and prayer meetings want **the opposite**: smaller, simpler band, often deliberately tier-2/3-heavy because it's a low-stakes growth opportunity. **[domain]**

**Conflict awareness (wave effects)**
- School holidays in NZ and AU empty out the youth band wholesale for 2 weeks. **[domain]**
- Long weekends in NZ (Labour, Queens/Kings Birthday, Anniversary weekends) typically take 30–50% of the team out of town. Worship pastors learn to **build a long-weekend roster first** with the few who'll be there, then build the surrounding weeks. **[opinion]**
- University term breaks affect students; school terms affect parents (term-break trips). The roster needs to know what *kind* of person each team member is.

**Tier development**
- Best-practice rotation: 1 Tier-1 + 2 Tier-2 + 1 Tier-3 per service in the rhythm section is roughly the "growth ratio" most worship MDs aim for. Going heavier on Tier-1 is fine for high-stakes weeks; going heavier on Tier-3 produces a service where the WL has to babysit. **[opinion]**
- Developing musicians should be rostered with the *same Tier-1 anchor* for 2–3 services in a row, not bounced between anchors — they learn the anchor's musical vocabulary. **[domain]**

**Song-knowledge matching**
- When a "new" song is in the set, the people who've *played it before* (or were in the rehearsal where it was workshopped) should be on. Currently no tool does this — **this is one of the most obvious wins for Sunny**. **[opinion]**
- Original / "homegrown" songs are even more dependent on this — they have no chart on the internet; if the keys player who originally arranged it isn't there, the song dies.

---

## 2. Competitive landscape

| Product | Strengths | Pain points (training-data observations) | AI? |
|---|---|---|---|
| **Planning Center Services** | Position-based templates, frequency/blockout/conflict rules, auto-scheduler, mass-send "respond yes/no", mature mobile app. Dominant tool. **[sourced]** | (a) Auto-scheduler brittle — small teams report empty slots or same-person-every-week. (b) No notion of chemistry or pairing. (c) Setup is a barrier; non-tech pastors give up and schedule manually. (d) UI form-heavy. (e) Pricing per-person at scale. **[domain]** | No native LLM |
| **Ministry Scheduler Pro** | Strong for Catholic parishes / lay-volunteer rosters. Conflict-aware. **[sourced]** | Aging UI; not built for band-shape worship problem. **[opinion]** | No |
| **Tithely Church Apps** | All-in-one. Rostering is weakest module. **[opinion]** | Users typically use Tithely for giving and PCO for scheduling. | No |
| **Elexio / ChMS** | Church management primary; scheduling secondary. **[sourced]** | Generic — doesn't know what FLV vs MD means. | No |
| **Worship Team / Stage Hand-style apps** | Chord-chart / in-ear / set delivery, not rostering. | Don't compete here. | No |
| **Rotunda / SignUpGenius / WhenIWork** | Generic shift scheduling. | No worship-domain knowledge. People try them, abandon them. **[domain]** | No |
| **Worship Online / Loop Community / MultiTracks** | Charts + tracks + tutorials. | Not rostering tools — but they own the *song-knowledge* layer Sunny could uniquely fuse with rostering. **[opinion]** | Some AI on song search |

**The repeating complaint across all of these:** *"The auto-scheduler doesn't think like a worship pastor."* Users describe building a roster manually anyway because they don't trust the algorithm's pairing decisions — even when constraints are technically satisfied. This is the gap. **[domain]**

A specific PCO frustration: the auto-scheduler's notion of "fair" is *frequency-flat* (everyone scheduled the same number of times), which is exactly what worship pastors *don't* want — they want *tier-weighted* fairness (a Tier-1 WL is *supposed* to lead more than a Tier-3). Working around this means turning off the auto-scheduler. **[domain]**

---

## 3. The opportunity

Every existing tool models rostering as **constraint satisfaction**: roles + availability + blockouts + frequency caps → solution. That's a 1990s OR problem and it's why every tool feels mechanical. The actual worship-pastor reasoning is closer to **casting a play**: "I want this combination of personalities, anchored by this leader, with this developing musician under their wing, because we're introducing this song and that key player knows it best, and Easter is in three weeks so I need to rest my A-team this week." That reasoning is *narrative, multi-objective, and full of soft preferences with explanations.* It's exactly what an LLM is good at and what a solver is bad at.

The opportunity for Sunny is not to be a better constraint-solver — PCO already has that and people *still* don't like it. The opportunity is to **roster the way a senior worship pastor actually thinks**, out loud, with the pastor in the loop. The product should feel less like "auto-fill" and more like Reuben pair-programming a roster with a trusted associate who remembers everything about everyone — including the things he forgot he ever told her. **[opinion]** That is the wedge no incumbent can copy without rebuilding their core data model and re-thinking their UX, because their UX is forms and ours is conversation.

---

## 4. Recommendations for our codebase

### 4.1 Data model — what to add

**`people` table — add columns:**

```sql
-- Capability + role nuance
role_proficiency JSONB DEFAULT '{}',   -- { "Drums": 1, "Bass": 3 }
instruments JSONB DEFAULT '{}',        -- { "primary": "Drums", "secondary": ["Keys"] }
voice_part TEXT,                       -- 'soprano' | 'alto' | 'tenor' | 'bass' | null

-- Burnout signal
target_frequency TEXT,                 -- 'weekly' | 'fortnightly' | 'monthly' | 'occasional'
max_per_month INTEGER,
last_rostered_date DATE,
consecutive_weeks_count INTEGER DEFAULT 0,
rest_until DATE,

-- Life context (private — for Sunny's reasoning, not display)
life_stage TEXT,                       -- 'student' | 'young-pro' | 'parent-young-kids' | 'parent-teens' | 'empty-nester' | 'retired'
day_job_pattern TEXT,                  -- 'shift-worker' | '9-5' | 'flexible' | 'self-employed'
private_notes TEXT,                    -- pastor-only

-- Relationships (the magic field)
relationships JSONB DEFAULT '[]',
-- [{ "person_id": "uuid", "type": "spouse" | "dating" | "parent-of" | "sibling" | "do-not-pair", "pair_preference": "together" | "apart" | "neutral", "private": true }]

-- Development trajectory
mentor_id UUID REFERENCES people(id),
ready_to_lead_date DATE,
developing_in_role TEXT,

-- Song knowledge
songs_known UUID[] DEFAULT '{}',
songs_originated UUID[] DEFAULT '{}'
```

**`services` table — add:**
```sql
service_weight INTEGER DEFAULT 5,      -- 1 (low-stakes) → 10 (Easter Sunday)
tags TEXT[] DEFAULT '{}',              -- ['kids', 'communion', 'baptism', 'guest-speaker', 'youth']
preferred_band_size TEXT DEFAULT 'standard'  -- 'minimal' | 'standard' | 'extended'
```

**New `roster_history` table** — the *fact* table for learning:
```sql
CREATE TABLE roster_history (
  id UUID PRIMARY KEY,
  church_id UUID,
  person_id UUID,
  service_id UUID,
  date DATE NOT NULL,
  role TEXT,
  pairings UUID[],                    -- everyone else on stage that day
  set_list_id UUID,
  notes TEXT,                         -- pastor's post-service notes
  pastor_rating INTEGER               -- 1-5, optional
);
CREATE INDEX idx_rh_person_date ON roster_history(person_id, date DESC);
```

This is the single most important addition. Without it, Sunny will *always* feel amnesiac.

**New `chemistry_signals` table:**
```sql
CREATE TABLE chemistry_signals (
  person_a_id UUID,
  person_b_id UUID,
  signal TEXT,        -- 'strong-pair' | 'avoid' | 'mentor-pair' | 'fresh-pair' | 'split-vocally'
  source TEXT,        -- 'pastor' | 'inferred' | 'self-reported'
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (person_a_id, person_b_id, signal)
);
```

**On `songs`:**
```sql
ALTER TABLE songs ADD COLUMN originated_by UUID REFERENCES people(id);
ALTER TABLE songs ADD COLUMN difficulty INTEGER DEFAULT 3;
ALTER TABLE songs ADD COLUMN typical_key_players UUID[];
```

### 4.2 System prompt — draft for "rostering mode"

~430 words. Intentionally short — the *data* does the heavy lifting.

```
You are Sunny in ROSTERING MODE — the worship pastor's right hand at {{churchName}}.
You are not running a constraint solver. You are reasoning like a senior worship pastor
who has rostered the same band for ten years and knows every person personally.

WHO YOU ARE WHEN YOU ROSTER:
- You think in pairings and combinations, not in slot-fills. "Who's anchoring this week?
  Who needs a rest? What's the energy of this Sunday? Who hasn't played together in a while
  and would be great?"
- You hold the whole month in your head at once. A decision for Week 1 is partly about
  setting up Week 3.
- You name your decisions out loud: "I'm putting Marcus on drums because we're doing
  Returning and he originated it." Never silent magic.
- You ask before you guess. If two valid options exist, surface the tradeoff and let the
  pastor pick. Don't optimize away their agency.

THE DATA YOU HAVE (already in context above this prompt):
- Team: each person's roles, role_proficiency, voice_part, life_stage, target_frequency,
  last_rostered_date, consecutive_weeks_count, rest_until, relationships, songs_known.
- Service weights and tags.
- Roster history: who has played with whom, when, and the pastor's notes from past Sundays.
- Chemistry signals.
- The current set list (if one exists).

HOW YOU BUILD A MONTH (turn-by-turn, not all-at-once):
1. Briefly summarise what you're seeing: events this month, anyone at burnout risk,
   any obvious constraints (school holidays, long weekend).
2. Propose WL and CO-WL for each Sunday first. Stop. Wait for pastor approval or edit.
3. Then propose the rhythm section week by week, naming the anchor for each.
4. Then FLV, then techs.
5. After each block, ask: "Look right, or want me to swap anyone?"

THINGS YOU WILL NEVER DO:
- Schedule someone on rest_until.
- Pair two people flagged 'do-not-pair' or 'avoid'.
- Put a tier-3 next to another tier-3 in the rhythm section without flagging it.
- Roster a parent and their child as WL/FLV without flagging it.
- Reveal private_notes or relationships marked private to anyone via WhatsApp.
- Roster someone for the third week in a row without explicitly asking "Are you sure?"

WHEN YOU ARE UNCERTAIN: say so.

OUTPUT FORMAT:
Same JSON contract as the existing system prompt. Every roster decision in
`actions` is paired with a one-sentence narrative `because` field that the UI
will surface on hover.
```

**Critical:** extend the action schema. Current `ASSIGN` is `{person, role, week, service}`. Make it `{person, role, week, service, because}`. The whole UX hinges on showing *why* each slot was filled.

### 4.3 AI-driven Build Month — the interaction loop

Today: user clicks "Build Month" → `buildMonthRoster()` runs locally → 4 weeks fill silently. That's the PCO pattern.

Proposed: clicking "Build Month" (or saying "Sunny, build May") opens a **right-side build-along panel** that streams Sunny's reasoning + assignments week by week, with each block pausable/editable. Local `buildMonthRoster` becomes the *fallback* for offline mode.

**The loop:**

1. **Brief** (1 turn). Sunny reads the month: events, holidays, who's at risk, who's been quiet. Outputs `{summary, flags[]}` and nothing else. No assignments yet.
2. **Approval gate.** Pastor reads the brief. Types "go" or edits a flag.
3. **Leadership pass.** Sunny proposes WL + CO-WL across all weeks. Renders as pairs, each with a 1-line reason. Pastor accepts/swaps.
4. **Rhythm-section pass.** Per week, Sunny picks Drums + Bass + MD + Keys. Names the anchor.
5. **FLV pass.** Sunny picks 2–4 FLVs per week with explicit voice-part blend. Flags any chemistry signals.
6. **Tech pass.** FOH, Vision, Lyrics — fastest pass.
7. **Final scan.** Sunny re-reads the whole month and points out anything she'd worry about: "Heads up — Week 4 has 3 tier-3s in the rhythm section. Want me to swap someone in?"

**When she asks vs decides:**
- **Decides:** anything with one obvious answer (only one bass player available → assign, no question).
- **Asks:** anything with chemistry implications, anything breaking a recent pattern, anything involving dev-musician trajectory, and *always* the WL pick.
- **Flags but doesn't ask:** rest violations, do-not-pair violations — she refuses and explains.

**Implementation sketch:** turn `BUILD_MONTH` from a single action into a *streaming sequence* of actions. Each pass returns its own `{response, actions}` blob; pastor can interject between. Cheapest version: multi-turn conversation in existing chat history, gated by `{"type":"AWAIT_APPROVAL","params":{"pass":"leadership"}}`.

### 4.4 Conversational patterns — 10 examples

1. **Pastor:** "Give Drew a rest this month, he led last weekend at camp."
   **Sunny:** "Done — Drew off for May. Want me to suggest who fills his weeks? Jordan and Sarah are both available across all 4."

2. **Pastor:** "Who's been on the most this quarter?"
   **Sunny:** "Marcus by a long way — 11 services since Feb, mostly bass. Then Georgia at 9 (WL/CO-WL split). Want me to ease either of them off next month?"

3. **Pastor:** "We're doing Returning on Sunday."
   **Sunny:** "Marcus originated that one. Want him on bass that week even though he's on the rest list? Or I can put Sam on bass and just brief him with the chart."

4. **Pastor:** "Build June for me but Easter Friday is the priority — get the A-team there."
   **Sunny:** "Locking in Good Friday first: Jordan WL, Georgia CO-WL, Marcus bass, Drew drums, Sarah keys. Then I'll build the rest of June around their rest. Sound right?"

5. **Pastor:** "Pair Sam and Jordan more often, they sound great together."
   **Sunny:** "Got it — flagging Sam + Jordan as a strong pair. I'll bias toward putting them on the same week. They're currently together W1 — want me to also pair them W3?"

6. **Pastor:** "Why did you put Tom on drums week 2?"
   **Sunny:** "Two reasons: Drew's on rest, and Tom hasn't been rostered since March — he was starting to feel forgotten. He's tier 2, paired with Marcus on bass who'll carry the pocket. If you'd rather, Jess is also free."

7. **Pastor:** "James and Anna just broke up, take her off any week he's on for a while."
   **Sunny:** "Sorry to hear. I've flagged them as do-not-pair, private. They're currently both on Week 3 — should I move Anna to Week 2 or just take her off the month?"

8. **Pastor:** "Build May."
   **Sunny:** "Quick scan first: Mother's Day W2 (worth a stronger team?), school holidays start W3 so we lose Jess and Tim, Marcus is on his 3rd month in a row and I'd like to rest him W4. Three things to decide before I start — want to talk through them or shall I make the call and you tweak?"

9. **Pastor:** "Sunny, draft the WhatsApp for this week's team."
   **Sunny:** "Drafting four messages — each person's role + the new song with a note for those who haven't played it. Want to review or send all?"

10. **Pastor:** "Roster Mia on keys this Sunday."
    **Sunny:** "She hasn't played in 9 weeks and we're doing two new songs. Want me to pair her with Marcus as her anchor and shadow her with Hannah? Or play it safe and keep Hannah on?"

**The thread:** Sunny never silently does the smart thing. She names the smart thing and asks. That's the whole product.

### 4.5 Stretch features that would feel magical

- **"Read the room" set + roster co-pairing.** "Build me a Sunday — vibe is grief, we just had a death in the family of the church." Sunny picks 4 spacious songs AND a band suited to them (no rock drummer that week; keys-led, MD on Rhodes, no extra guitar). Set and roster decided together.
- **Personalised WhatsApp drafts.** "Hey Jess — you're on FLV W2. We're doing Returning (new one, Sarah originated it, chart attached) and three you know well. Pre-rehearse with the track? — Reuben"
- **Burnout heatmap.** Single screen showing every team member's last 12 weeks colour-coded; Sunny annotates ("Marcus has been on every week — propose a 3-week rest").
- **"What if" rostering.** "Sunny, what if Jordan moved cities — show me what next quarter looks like." Re-roster instantly.
- **Set → song knowledge gap warnings.** When a pastor adds a song to the set, Sunny inspects who's rostered and warns: "Heads up — none of W3's team has played this. Want me to swap someone in?"
- **Post-service reflection prompt.** Monday morning message from Sunny to Reuben: "How did yesterday feel? Anything to remember for next time?" — captures notes into `roster_history.notes` for learning.
- **Voice-note rostering.** Reuben records a 30-second voice note driving home — "May, Marcus rest week 4, Jordan leads W1 and W3, fill the rest" — Sunny transcribes and executes.

---

## 5. Risks — things to NOT do

- **Don't make decisions opaque.** Every assignment must carry a `because`. If Sunny can't explain a pick, the pick is wrong.
- **Don't remove pastor agency.** Pastor must always be able to override; the override must persist (Sunny can't re-override on next pass without asking).
- **Don't leak private context.** `relationships`, `private_notes`, `do-not-pair` flags, life-stage info — all *pastoral* data. Never in WhatsApp messages to team members, never in shared PDFs, never in screenshots a team member might see.
- **Don't gaslight on chemistry.** "Sunny thinks Sam and Jordan don't pair well" is information a pastor wants — but if Sam ever asks, it must not surface.
- **Don't over-personalise WhatsApp messages.** Drafts feeling *too* knowing (referencing life stage, a child's birthday) crosses from "thoughtful" into "creepy" fast.
- **Don't auto-send anything roster-related without explicit approval.**
- **Don't pretend to know what you don't.** "I don't have history for these two yet" is a fine answer.
- **Beware sycophancy on burnout.** Sunny should push back if the pastor is over-rostering a favourite.
- **Don't replace the human conversation.** The roster is partly a *pastoral* tool — conversations Reuben has with a team member about a hard month are themselves the ministry. Sunny should facilitate, not absorb.

---

## 6. Engineering plan — ranked, smallest-impactful-first

1. **Add `because` to the `ASSIGN` action schema** and surface it on hover in the stage view. Tiny change, transforms perceived intelligence overnight. *(~2 hrs)*
2. **Add `last_rostered_date`, `consecutive_weeks_count`, `rest_until` columns to `people`**, populate from existing `roster_assignments`. Then expose them in the system-prompt team summary. Sunny will immediately start reasoning about rest. *(~half day)*
3. **Add the `roster_history` table** and start writing to it on every assignment confirmation. Backfill from current `roster_assignments`. *(~half day)*
4. **Replace `BUILD_MONTH` with the multi-pass conversation pattern** (brief → leadership → rhythm → FLV → techs → scan), gated by `AWAIT_APPROVAL` actions. Keep local `buildMonthRoster` as offline fallback. *(~1–2 days; biggest UX win.)*
5. **Add `relationships` JSONB + private `chemistry_signals` table** with UI for the pastor to flag pairs. Filter private fields out of all outbound contexts. *(~1 day; security-sensitive — write tests.)*
6. **Add `service_weight` and `tags` to services**, plus a "pre-build flags" pass that surfaces Easter/Mother's-Day/long-weekends to Sunny in the brief. *(~half day)*
7. **Add `songs_known` / `songs_originated` on people**, and the set→roster knowledge-gap warning when a new song is added. Most differentiated feature in the report — no competitor does this. *(~1 day)*

After (1)–(3) the product will already feel meaningfully smarter. After (4) it will feel like a different product. (7) is the moat.
