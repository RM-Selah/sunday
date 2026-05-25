# Sunday — Worship Team Assistant ("The Local")

A single-file HTML PWA + Cloudflare Worker that helps worship pastors build set lists, manage rosters, and coordinate teams. Built by Reuben Morgan ([@reubenmorgan](https://github.com/reubenmorgan), org: RM-Selah). Branded as **The Local**, deployed at **runworship.com**.

## What's live

- **Front-end** → GitHub Pages from `RM-Selah/sunday`, served at `runworship.com` via CNAME.
- **API backend** → Cloudflare Worker (`sunday-api`) at `api.runworship.com`. Proxies Anthropic so worship pastors never see an API key.
- **Model** → `claude-sonnet-4-6` (set via `ANTHROPIC_MODEL` env var on the Worker).
- **API key** → `ANTHROPIC_API_KEY` is a Worker secret. Already deployed, Sunny is live.

## Repos & local paths

| Repo | Local clone | What it is |
|---|---|---|
| [RM-Selah/sunday](https://github.com/RM-Selah/sunday) | `~/Documents/Worship Practice/sunday-repo/` (this folder) | Full app — `index.html`, schema, manifest, service worker, icons, legacy Node server |
| [RM-Selah/sunday-server](https://github.com/RM-Selah/sunday-server) | `~/Documents/Worship Practice/sunday-server-repo/` | Cloudflare Worker (`worker.js` + `wrangler.toml`). Deploy with `npx wrangler deploy`. |

The parent folder (`~/Documents/Worship Practice/`) still has older mockups under `archive/` — historical, ignore.

## Files in this repo

| File | What it is |
|---|---|
| `index.html` | The entire app. ~10k lines. Set builder, Roster, Sunny (AI chat), People, Settings. All state in localStorage, optional Supabase sync. |
| `sunday-server.js` | Legacy Node server. Cloudflare Worker is what's deployed now. |
| `sunday-schema.sql` | Supabase/Postgres schema, multi-tenant by `church_id`, RLS enabled. |
| `sunday-manifest.json` / `sunday-sw.js` / `sunday-icon-*.png` | PWA bits. |
| `docs/rostering-plan.md` | Deep-dive research + engineering plan for the rostering brain. |

## Architecture notes

- **5 screens**: Set builder · Roster · Sunday (AI chat) · People · Settings.
- **Sunny (the AI)** is a system-prompted Claude call that returns `{ response, actions: [...] }`. Action handlers in `index.html` mutate state and re-render.
- **Mobile chat** is a peek-and-expand bottom sheet — input bar always visible (~78px), tap to lift to 75vh.
- **Seed system** lives at `var SEED_VERSION = '...'`. Bump the string to force a re-seed of specific localStorage keys on next load. We narrow the wipe (e.g. only `sunday_songs`) so user roster work isn't lost.
- **Share flows** (set list + roster) use a unified pattern:
  1. Try `navigator.share({ files })` — works on iPhone / iPad / Mac Safari (native share sheet, OS picks Messages / WhatsApp / Mail / AirDrop).
  2. Mac Chrome / Edge fallback: copy image to clipboard, open the target app synchronously inside the click handler (popup blocker won't fire), user pastes with ⌘V.
  3. Last resort: download.
- **Watch out**: `sms:?body=` is the iOS-8+ syntax for the iMessage URL. The older `sms:&body=` caused macOS Messages to land on the most recent contact (we hit this — "the Georgia bug").

## Sunny's action vocabulary (lives in the system prompt)

- Team: `ADD_TEAM_MEMBER`, `ADD_TEAM_BULK`, `UPDATE_PERSON`, `DELETE_TEAM_MEMBER`
- Songs: `ADD_TO_LIBRARY`, `ADD_SONGS_BULK`, `UPDATE_SONG`, `REMOVE_FROM_LIBRARY`, `ADD_SONG`, `REMOVE_SONG`, `SWAP_SONG`, `BUILD_SET`, `REORDER`, `CLEAR_SET`, `SET_MINISTRY`
- Roster: `BUILD_MONTH`, `FILL_WEEK`, `ASSIGN` (with `because` field for hover tooltips), `REMOVE_PERSON`, `REST_PERSON`, `CLEAR_WEEK`, `CLEAR_MONTH`, `SET_UNAVAILABLE`, `SET_AVAILABLE`, `SET_ROSTER_MONTH`
- Services: `ADD_SERVICE`, `ADD_EVENT`, `RENAME_SERVICE`, `REMOVE_SERVICE`
- Misc: `SET_CHURCH_NAME`, `EXPORT_ROSTER_PDF`, `EXPORT_SET_PDF`, `WHATSAPP_SEND`, `WHATSAPP_BLAST`, `WHATSAPP_CHECK_AVAIL`
- Role aliases are normalised on input: `vocal`/`singer` → `FLV`, `piano` → `Keys`, `electric` → `Guitar`, etc.

## Current data state

- **Team**: real PCO roster (47 people), tagged with canonical roles `WL / CO-WL / FLV / Keys / Drums / Bass / Guitar / Acoustic / FOH`. (MD slot is currently disabled — historical assignments are still in `state.roster`, but it's hidden from the stage view, PDF, share text, and Sunny's prompt. Re-enable by adding `'MD'` back to the slot lists.)
- **Songs**: 28-song master library, 4 categories — Praise · Homegrown · Current · Classic. Originals credit `The Local`.
- **History**: 9 months of PCO roster data (Aug 2025 → May 2026) seeded so Sunny has long memory and history-weighted picks.
- **Services**: Sunday AM (9:30am) + Sunday PM (6pm) seeded by default.

## Current priority

Test phase for sharing with worship leaders this week:
- Reuben + Kayleigh sit down to roster June 2026 together.
- Share the app with a small group of other worship pastors for set-list building.

What's still rough:
- New-user onboarding is archived/hidden — every new visitor gets The Local's seed data. Fine for Kayleigh, awkward for sharing with a different church (separate sprint).
- Roster image / PDF visual now grouped into bands (Leadership · Rhythm · Vocals · Tech). Could later add: set list embedded in roster card, service time + notes line.

## Working conventions

- Commit messages: Conventional-ish but readable. Co-authored line at the bottom (see git log).
- Don't bump SEED_VERSION unless you mean to wipe data. When you do, narrow the wipe (e.g. only `sunday_songs`) so roster work persists.
- The single-file HTML is canonical. Don't split it unless we agree.
- Be decisive with Sunny — if a request needs an action, emit JSON. Don't promise without executing.

## Where to look next

- For broader rostering vision: `docs/rostering-plan.md`.
- For the share flow refactor (Web Share API + clipboard fallback): search `shareSetAs` and `shareRosterAs` in `index.html`.
- For the seed: search `var SEED_VERSION`.

## Quick "what's the state?" command

```
git log --oneline -20
```

That's usually the fastest orient.
