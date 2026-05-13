# Claude Project Memory — Selah Worship App

## HOW TO START EVERY SESSION (read this first)
**"worship practice"** is the key phrase. The moment you see those two words, that is your trigger.

Do this immediately and silently, no questions asked:
1. Read this entire CLAUDE.md file
2. Pull the latest worship-practice.html from GitHub using the push script (see Pushing section)
3. Say: "Got it — I'm up to speed. What are we working on today?"

Do NOT ask for the GitHub URL. Do NOT ask for a token. Do NOT ask Reuben to explain the project.
Everything you need is in this file. Reuben is not an engineer — he should never have to manage your memory.

---

## The file
`worship-practice.html` — single-file app, all CSS + JS + HTML inline.

## GitHub
- Repo: `https://github.com/rm-selah/rm-selah.github.io`
- File lives at: `sunday/worship-practice.html`
- Live URL: `https://rm-selah.github.io/sunday/worship-practice.html`
- Branch: `main` (GitHub Pages, publishes from root)

## Workflow (every session)
1. Clone or pull from repo before doing any work
2. Edit `/sunday/worship-practice.html`
3. Commit + push when done
4. User can hard refresh (Cmd+Shift+R) to see live changes — GitHub Pages takes ~30s

## Pushing — use the script, never ask for a token
There is a push script already saved in the outputs folder:
`/sessions/sleepy-jolly-ramanujan/mnt/outputs/push-to-github.py`

It contains the GitHub token and handles everything. Just run:
```
cd /sessions/sleepy-jolly-ramanujan/mnt/outputs
python3 push-to-github.py worship-practice.html
```

- Repo: `RM-selah/sunday`
- File: `worship-practice.html` (root of that repo)
- ALWAYS check for this script first before asking Reuben for a token

## The app — what it is
Sunday set-list planning tool for Selah Church worship team.
- Sunny (AI assistant) helps build the set via chat
- Drag-and-drop song library with search
- Ministry section at bottom of set
- Set card overlay (Monocle-style) with image sharing via Web Share API
- Key picker per song
- Glass-panel UI over a dark photo background

## People
- Reuben Morgan — worship leader, main user
- iMessage: 0450723433 / reubentmorgan@icloud.com
- Georgia — worship leader (referenced in set card)

## Design brief — "Bandit Running" aesthetic
Dark, cinematic, atmospheric. Moody but intentional. Like Monocle magazine meets raw concert photography.
- Current background photo: `photo-1576919463908-de1f877114bb` (lone silhouette, open sky)
- Glass panels: rgba backgrounds with backdrop-filter blur, low opacity (0.38–0.55)
- Font: system display + body vars
- Accent colour: amber (`--amber`)

## Song library notes
- "Returning" by Reuben Morgan — key A, homegrown
- Library persists in localStorage via `SundayData`

## Pending / next up
- Onboarding + greeting flow (not started)
- Three-role experience: Pastor / Worship Leader / Team views
- Team page layout needs work
- Date in set card: show next Sunday's date, not just month
- Background photo: still choosing — current is option 6 (silhouette)
