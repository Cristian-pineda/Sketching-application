import { useMemo, useState } from 'react'
import type { CSSProperties } from 'react'
import { AdminShell } from '../../components/layout/AdminShell'
import { Button } from '../../components/ui/button'
import { Dialog, DialogContent, DialogDescription, DialogTitle, DialogTrigger, DialogClose } from '../../components/ui/dialog'

const statCardStyle: CSSProperties = {
  display: 'flex',
  flexDirection: 'column',
  gap: '0.5rem',
  padding: '1.5rem',
  borderRadius: 12,
  border: '1px solid var(--gray4)',
  background: 'var(--gray2)',
  boxShadow: '0 10px 35px rgba(15, 23, 42, 0.08)',
}

const labelStyle: CSSProperties = {
  fontSize: '0.95rem',
  color: 'var(--gray11)',
}

const valueStyle: CSSProperties = {
  fontSize: '1.85rem',
  fontWeight: 700,
  letterSpacing: '-0.02em',
}

export default function AdminDashboard() {
  const [isCreateOpen, setCreateOpen] = useState(false)

  const stats = useMemo(
    () => [
      {
        label: 'Active collections',
        value: 12,
        change: '+3 this week',
      },
      {
        label: 'New assets',
        value: 48,
        change: '+12 pending review',
      },
      {
        label: 'Collaborators',
        value: 7,
        change: '2 invitations outstanding',
      },
    ],
    []
  )

  return (
    <Dialog open={isCreateOpen} onOpenChange={setCreateOpen}>
      <AdminShell
        title="Creative Ops Snapshot"
        subtitle="Monitor asset ingestion and manage curation workflows for SketchTracer."
        actions={
          <div style={{ display: 'flex', gap: '0.75rem' }}>
            <DialogTrigger>
              <Button variant="primary" icon={<span aria-hidden="true">＋</span>}>
                New collection
              </Button>
            </DialogTrigger>
            <Button variant="secondary" asChild icon={<span aria-hidden="true">⇪</span>}>
              <a href="/admin/upload">Upload asset</a>
            </Button>
          </div>
        }
      >
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
            gap: '1.25rem',
          }}
        >
          {stats.map((stat) => (
            <article key={stat.label} style={statCardStyle}>
              <span style={labelStyle}>{stat.label}</span>
              <span style={valueStyle}>{stat.value}</span>
              <span className="app-muted">{stat.change}</span>
          </article>
        ))}
      </div>

      <div style={{ marginTop: '2.5rem' }}>
        <h2 className="app-heading" style={{ fontSize: '1.2rem', marginBottom: '0.75rem' }}>
          Review queue
        </h2>
        <p className="app-muted">
          You have 12 sketches awaiting stylist approval. Prioritize uploads that support upcoming discovery campaigns.
        </p>
      </div>
      </AdminShell>

      <DialogContent>
        <DialogTitle>Create a collection</DialogTitle>
        <DialogDescription style={{ marginTop: '0.5rem', color: 'var(--muted-foreground)' }}>
          Bundle related trace overlays, prompt templates, and reference assets into a production-ready collection.
        </DialogDescription>

        <form style={{ marginTop: '1.5rem', display: 'grid', gap: '1rem' }}>
          <label style={{ display: 'grid', gap: '0.35rem' }}>
            <span style={{ fontSize: '0.85rem', fontWeight: 600 }}>Collection name</span>
            <input
              type="text"
              placeholder="e.g. Architectural Shadows"
              style={{
                borderRadius: 8,
                border: '1px solid var(--gray4)',
                padding: '0.6rem 0.75rem',
                fontSize: '0.95rem',
                background: 'var(--gray2)',
                color: 'var(--gray12)',
              }}
            />
          </label>

          <label style={{ display: 'grid', gap: '0.35rem' }}>
            <span style={{ fontSize: '0.85rem', fontWeight: 600 }}>Purpose</span>
            <textarea
              rows={4}
              placeholder="Outline how this collection will be used in the CMS."
              style={{
                borderRadius: 8,
                border: '1px solid var(--gray4)',
                padding: '0.75rem',
                fontSize: '0.95rem',
                background: 'var(--gray2)',
                color: 'var(--gray12)',
                resize: 'vertical',
              }}
            />
          </label>

          <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem', marginTop: '0.5rem' }}>
            <DialogClose>
              <Button variant="subtle">Cancel</Button>
            </DialogClose>
            <Button type="submit">Save draft</Button>
          </div>
        </form>
      </DialogContent>
    </Dialog>
  )
}
