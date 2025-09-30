import type { CSSProperties, ReactNode } from 'react'
import Link from 'next/link'
import { Button } from '../ui/button'
import { AdminNavigation } from '../ui/AdminNavigation'

interface AdminShellProps {
  title: string
  subtitle?: string
  actions?: ReactNode
  children: ReactNode
}

const avatarRoot: CSSProperties = {
  width: 36,
  height: 36,
  borderRadius: '9999px',
  border: '1px solid var(--border)',
  overflow: 'hidden',
  backgroundColor: 'var(--muted)',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  fontSize: '0.9rem',
  fontWeight: 600,
  color: 'var(--muted-foreground)',
}

export function AdminShell({ title, subtitle, actions, children }: AdminShellProps) {
  return (
    <div
      style={{
        minHeight: '100vh',
        backgroundColor: 'var(--background)',
        display: 'flex',
      }}
    >
      <AdminNavigation />

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <header
          style={{
            borderBottom: '1px solid var(--border)',
            padding: '1rem 2rem',
            display: 'flex',
            justifyContent: 'flex-end',
          }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
            <div style={avatarRoot}>CP</div>
            <button
              type="button"
              onClick={() => alert('Sign out coming soon')}
              style={{
                fontSize: '0.9rem',
                fontWeight: 600,
                color: 'var(--link)',
                background: 'none',
                border: 'none',
                cursor: 'pointer',
                padding: 0,
              }}
            >
              Sign out
            </button>
          </div>
        </header>

        <main style={{ flex: 1, padding: '2.5rem 2rem 3rem' }}>
          <div style={{ maxWidth: 960, margin: '0 auto' }}>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'space-between',
                gap: '1rem',
              }}
            >
              <div>
                <h1 className="app-heading" style={{ fontSize: '1.75rem' }}>
                  {title}
                </h1>
                {subtitle ? <p className="app-muted" style={{ marginTop: '0.35rem' }}>{subtitle}</p> : null}
              </div>
              {actions ?? null}
            </div>

            <section style={{ marginTop: '2rem' }} className="app-surface">
              {children}
            </section>
          </div>
        </main>
      </div>
    </div>
  )
}

export function ShellToolbar({ onCreate }: { onCreate: () => void }) {
  return (
    <div style={{ display: 'flex', gap: '0.75rem' }}>
      <Button variant="subtle" onClick={onCreate}>
        New Collection
      </Button>
      <Button asChild>
        <Link href="/admin/upload">Upload asset</Link>
      </Button>
    </div>
  )
}
