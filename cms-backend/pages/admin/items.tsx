import type { CSSProperties } from 'react'
import Link from 'next/link'
import { AdminShell } from '../../components/layout/AdminShell'
import { Button } from '../../components/ui/button'

const tableStyle: CSSProperties = {
  width: '100%',
  borderCollapse: 'separate',
  borderSpacing: 0,
}

const headerCellStyle: CSSProperties = {
  textAlign: 'left',
  fontSize: '0.8rem',
  textTransform: 'uppercase',
  letterSpacing: '0.06em',
  color: 'var(--gray11)',
  padding: '0.75rem 0.5rem',
  borderBottom: '1px solid var(--gray4)',
}

const cellStyle: CSSProperties = {
  padding: '1rem 0.5rem',
  borderBottom: '1px solid var(--gray4)',
}

const badgeStyle: CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  padding: '0.15rem 0.5rem',
  borderRadius: 999,
  fontSize: '0.75rem',
  background: '#d1fae5',
  color: '#065f46',
  fontWeight: 600,
}

const rows = [
  {
    name: 'Perspective grids',
    type: 'Overlay',
    updated: 'Apr 12, 2025',
    status: 'Published',
  },
  {
    name: 'Line art catalog',
    type: 'Prompt library',
    updated: 'Apr 9, 2025',
    status: 'Draft',
  },
  {
    name: 'Shadow archetypes',
    type: 'Overlay',
    updated: 'Mar 28, 2025',
    status: 'Published',
  },
]

export default function AdminItemsPage() {
  return (
    <AdminShell
      title="Catalog assets"
      subtitle="Curate the overlays, prompts, and references surfaced in the SketchTracer app."
      actions={
        <Button variant="primary" asChild>
          <Link href="/admin/upload">Upload asset</Link>
        </Button>
      }
    >
      <table style={tableStyle}>
        <thead>
          <tr>
            <th style={{ ...headerCellStyle, paddingLeft: 0 }}>Name</th>
            <th style={headerCellStyle}>Type</th>
            <th style={headerCellStyle}>Updated</th>
            <th style={{ ...headerCellStyle, textAlign: 'right', paddingRight: 0 }}>Status</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.name}>
              <td style={{ ...cellStyle, paddingLeft: 0 }}>
                <div style={{ fontWeight: 600 }}>{row.name}</div>
                <div className="app-muted" style={{ fontSize: '0.85rem', marginTop: '0.2rem' }}>
                  Used across discovery feed and tracing tutorials
                </div>
              </td>
              <td style={cellStyle}>{row.type}</td>
              <td style={cellStyle}>{row.updated}</td>
              <td style={{ ...cellStyle, textAlign: 'right', paddingRight: 0 }}>
                <span style={badgeStyle}>{row.status}</span>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </AdminShell>
  )
}
