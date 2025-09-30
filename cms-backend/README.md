# SketchTracer CMS Backend

Admin dashboard built with Next.js (pages router). The console manages content, prompts, and overlay assets that feed the SketchTracer app.

## Getting Started

```bash
npm install
npm run dev
```

- Dev server: `http://localhost:3000`
- Admin console entry point: `http://localhost:3000/admin`
- Magic link login page: `/login`

## Architectural Highlights

```
cms-backend/
├─ components/
│  ├─ layout/AdminShell.tsx      // Shared header + shell used by admin pages
│  └─ ui/
│     ├─ button.tsx              // Reusable button variants (no external UI deps)
│     └─ dialog.tsx              // Minimal modal helpers ready for future design work
├─ lib/
│  └─ supabase.ts                // Supabase client helpers
├─ pages/
│  ├─ _app.tsx                   // Supabase session provider + global styles
│  ├─ index.tsx                  // Redirects to /login
│  ├─ login.tsx                  // Magic-link + OAuth sign-in flow
│  └─ admin/
│     ├─ index.tsx               // Dashboard overview with simple modal
│     ├─ items.tsx               // Catalog management table
│     └─ upload.tsx              // Asset upload form
├─ styles/globals.css            // Shared theme tokens (no external dependencies)
└─ middleware.ts                 // Auth gate (protect /admin routes)
```

### Styling Conventions

- Global theme + utilities live in `styles/globals.css`. Shared tokens like `--background`, `--border`, and helper classes (`app-surface`, `app-muted`) keep the UI consistent while we stand up a bespoke design system.
- Inline style objects keep components lightweight for now. As the in-house design system grows, swap these styles for centralised utilities or component-level styling.

### Supabase Auth Notes

- `_app.tsx` initialises the Supabase browser client and wires up the auth context.
- `middleware.ts` (optional) can enforce that `/admin/*` routes require a session.
- Adjust `.env.local` with Supabase URL/anon key before running locally.

### Scripts

| Script        | Purpose                     |
|---------------|-----------------------------|
| `npm run dev` | Start dev server (Turbopack)|
| `npm run build` | Production build          |
| `npm run start` | Serve production build    |

Feel free to extend this guide as additional workflows (publishing, storage integration, etc.) are implemented.
