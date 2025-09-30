import Link from 'next/link'
import { useRouter } from 'next/router'

const navItems = [
  {
    href: '/admin',
    label: 'Overview',
    shortLabel: 'OV',
  },
  {
    href: '/admin/items',
    label: 'Items',
    shortLabel: 'IT',
  },
  {
    href: '/admin/upload',
    label: 'Upload',
    shortLabel: 'UP',
  },
] as const

export function AdminNavigation() {
  const router = useRouter()

  return (
    <aside
      style={{
        width: 220,
        borderRight: '1px solid var(--sidebar-border)',
        backgroundColor: 'var(--sidebar)',
        color: 'var(--sidebar-foreground)',
        display: 'flex',
        flexDirection: 'column',
        padding: '1.5rem 1rem',
        gap: '1.5rem',
      }}
    >
      <Link
        href="/admin"
        style={{
          fontWeight: 700,
          fontSize: '1.1rem',
          letterSpacing: '-0.01em',
          textDecoration: 'none',
          color: 'var(--sidebar-foreground)',
          display: 'flex',
          alignItems: 'center',
        }}
      >
        CMS Console
      </Link>

      <nav style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', flex: 1 }}>
        {navItems.map(({ href, label, shortLabel }) => {
          const isActive = router.pathname === href

          return (
            <Link
              key={href}
              href={href}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '0.75rem',
                padding: '0.65rem 0.75rem',
                borderRadius: 'var(--radius)',
                color: isActive ? 'var(--sidebar-primary-foreground)' : 'var(--sidebar-foreground)',
                backgroundColor: isActive ? 'var(--sidebar-primary)' : 'var(--sidebar)',
                textDecoration: 'none',
                transition: 'background-color 0.2s ease, color 0.2s ease',
              }}
            >
              <span
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  width: 30,
                  height: 30,
                  borderRadius: 6,
                  backgroundColor: 'rgba(255, 255, 255, 0.08)',
                  fontSize: '0.75rem',
                  fontWeight: 700,
                  letterSpacing: '0.08em',
                }}
                aria-hidden="true"
              >
                {shortLabel}
              </span>
              <span style={{ fontWeight: 600 }}>{label}</span>
            </Link>
          )
        })}
      </nav>

      <div style={{ fontSize: '0.75rem', color: 'var(--sidebar-accent-foreground)', opacity: 0.7 }}>
        Build your own components here.
      </div>
    </aside>
  )
}
