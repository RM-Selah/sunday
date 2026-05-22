# Sunday — Worship Team Assistant

A single-file PWA + small Node backend for building worship sets, managing rosters, and coordinating teams over WhatsApp.

## Quick start

The app runs three ways depending on how much you want plugged in:

**1. App only (offline, localStorage)**

Open `index.html` in a browser. That's it — set builder, roster, people, and settings all work locally.

**2. App + AI**

```bash
export ANTHROPIC_API_KEY=sk-ant-...
npm start
```

Then open `index.html`. The Sunday AI chat will connect to `http://localhost:3456` automatically.

**3. Full stack — AI + WhatsApp + Supabase**

Copy `.env.example` to `.env`, fill in the values, then:

```bash
set -a && source .env && set +a
npm start
```

Open the app, go to Settings → paste your Supabase URL + anon key, enter your church name. The schema in `sunday-schema.sql` needs to be loaded into Supabase first (paste it into the SQL editor).

For WhatsApp inbound, expose the server via ngrok and point your Twilio webhook at `https://YOUR_DOMAIN/whatsapp/webhook`.

## Files

| File | What it is |
|---|---|
| `index.html` | The entire app — 5 screens (set, team, sunday, people, settings) |
| `sunday-server.js` | Node HTTP server: `/chat` (Claude proxy), `/whatsapp/*`, `/sync-state` |
| `sunday-schema.sql` | Supabase/Postgres schema, multi-tenant by `church_id`, RLS enabled |
| `sunday-manifest.json` | PWA manifest |
| `sunday-sw.js` | Service worker, network-first with offline fallback |
| `sunday-icon-*.png` | App icons |

## Environment variables

See `.env.example`. `ANTHROPIC_API_KEY` is the only required one — everything else is optional.

## Endpoints

- `GET /health` — server status
- `POST /chat` — browser → Claude
- `POST /clear` — clear in-memory conversation history
- `POST /sync-state` — browser pushes team/roster/songs so the server can answer WhatsApp
- `POST /whatsapp/webhook` — Twilio inbound
- `POST /whatsapp/send` — send a single WhatsApp message
- `POST /whatsapp/blast` — message everyone rostered for a given week
- `GET /whatsapp/status` — WhatsApp connection state
