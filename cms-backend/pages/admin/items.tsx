import type { CSSProperties } from 'react'
import { useEffect, useMemo, useState } from 'react'
import Link from 'next/link'
import { AdminShell } from '../../components/layout/AdminShell'
import { Button } from '../../components/ui/button'
import supabase from '../../lib/supabase'
import { getCatalogAssetUrl } from '../../lib/assets'

const tableStyle: CSSProperties = {
  width: '100%',
  borderCollapse: 'separate',
  borderSpacing: 0,
  border: '1px solid var(--gray4)',
  borderRadius: 12,
  overflow: 'hidden',
  fontSize: '16px',
}

const headerCellStyle: CSSProperties = {
  textAlign: 'left',
  fontSize: '16px',
  textTransform: 'uppercase',
  letterSpacing: '0.06em',
  color: '#ffffff',
  backgroundColor: 'var(--sidebar)',
  padding: '10px 10px',
  borderBottom: '1px solid var(--gray4)',
  borderRight: '1px solid var(--gray4)',
  width: 'auto',
  whiteSpace: 'nowrap',
}

const cellStyle: CSSProperties = {
  padding: '10px 5px',
  borderBottom: '1px solid var(--gray4)',
  borderRight: '1px solid var(--gray4)',
  fontSize: '16px',
}

const badgeStyle: CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  padding: '0.15rem 0.5rem',
  borderRadius: 999,
  fontSize: '16px',
  background: '#d1fae5',
  color: '#065f46',
  fontWeight: 600,
}

type VariantRow = {
  id: string
  tracePath: string | null
  itemName: string
  styleKey: string
  styleName: string | null
  description: string | null
  difficulty: number | null
  tags: string[]
  accessTier: 'free' | 'premium'
  published: boolean
  createdAt: string | null
}

export default function AdminItemsPage() {
  const [variants, setVariants] = useState<VariantRow[]>([])
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [selectedVariant, setSelectedVariant] = useState<VariantRow | null>(null)

  useEffect(() => {
    let isMounted = true

    async function fetchVariants() {
      setIsLoading(true)
      setError(null)

      const { data, error: queryError } = await supabase
        .from('item_style_variants')
        .select(
          `id, trace_path, description, difficulty, tags, access_tier, published, created_at,
           items:item_id ( name ),
           styles:style_id ( key, name )`
        )
        .order('created_at', { ascending: false })

      if (!isMounted) return

      if (queryError) {
        console.error('Failed to load variants:', queryError)
        setError(queryError.message)
        setVariants([])
        setIsLoading(false)
        return
      }

      const normalized: VariantRow[] = (data ?? []).map((row: any) => {
        const itemName = row?.items?.name ?? 'Untitled item'
        const styleKeyRaw = row?.styles?.key ?? row?.styles?.name ?? null
        const tierInput = typeof row?.access_tier === 'string' ? row.access_tier.toLowerCase() : 'free'
        const accessTier: 'free' | 'premium' = tierInput === 'premium' ? 'premium' : 'free'
        const tagsValue: unknown[] = Array.isArray(row?.tags) ? row.tags : []

        return {
          id: row.id,
          tracePath: row.trace_path ?? null,
          itemName,
          styleKey: styleKeyRaw ?? '—',
          styleName: row?.styles?.name ?? null,
          description: row?.description ?? null,
          difficulty: row.difficulty ?? null,
          tags: tagsValue
            .map((tag: unknown) => (typeof tag === 'string' ? tag.trim() : ''))
            .filter((tag): tag is string => Boolean(tag)),
          accessTier,
          published: Boolean(row.published),
          createdAt: row.created_at ?? null,
        }
      })

      setVariants(normalized)
      setIsLoading(false)
    }

    fetchVariants()

    return () => {
      isMounted = false
    }
  }, [])

  const publishedBadgeStyle = useMemo(() => ({
    background: '#d1fae5',
    color: '#065f46',
  }), [])

  const draftBadgeStyle = useMemo(() => ({
    background: '#e5e7eb',
    color: '#374151',
  }), [])

  const accessBadgeStyle = (tier: 'free' | 'premium'): CSSProperties =>
    tier === 'free'
      ? { background: '#bfdbfe', color: '#1d4ed8' }
      : { background: '#ede9fe', color: '#6d28d9' }

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
            <th style={{ ...headerCellStyle }}>Preview</th>
            <th style={headerCellStyle}>Item</th>
            <th style={headerCellStyle}>Style</th>
            <th style={headerCellStyle}>Difficulty</th>
            <th style={headerCellStyle}>Tags</th>
            <th style={headerCellStyle}>Access</th>
            <th style={headerCellStyle}>Status</th>
            <th style={headerCellStyle}>Created</th>
            <th style={{ ...headerCellStyle, textAlign: 'right' }}>Actions</th>
          </tr>
        </thead>
        <tbody>
          {isLoading ? (
            <tr>
              <td style={{ ...cellStyle }} colSpan={9}>
                Loading variants…
              </td>
            </tr>
          ) : error ? (
            <tr>
              <td
                style={{
                  ...cellStyle,
                  color: 'var(--red9)',
                }}
                colSpan={9}
              >
                {error}
              </td>
            </tr>
          ) : variants.length === 0 ? (
            <tr>
              <td style={{ ...cellStyle }} colSpan={9}>
                No variants found. Upload a new asset to get started.
              </td>
            </tr>
          ) : (
            variants.map((variant, index) => {
              const imageUrl = getCatalogAssetUrl(variant.tracePath ?? undefined)
              const createdAt = variant.createdAt
                ? new Date(variant.createdAt).toLocaleDateString(undefined, {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                  })
                : '—'

              return (
                <tr
                  key={variant.id}
                  style={{ backgroundColor: index % 2 === 0 ? 'var(--gray1)' : 'var(--gray2)' }}
                >
                  <td style={{ ...cellStyle, verticalAlign: 'middle' }}>
                    {imageUrl ? (
                      <img
                        src={imageUrl}
                        alt={variant.itemName}
                        style={{
                          width: 48,
                          height: 48,
                          borderRadius: 12,
                          objectFit: 'cover',
                          border: '1px solid var(--gray4)',
                        }}
                      />
                    ) : (
                      <div
                        style={{
                          width: 48,
                          height: 48,
                          borderRadius: 12,
                          background: 'var(--gray3)',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          fontSize: '16px',
                          color: 'var(--muted-foreground)',
                        }}
                      >
                        No Image
                      </div>
                    )}
                  </td>
                  <td style={{ ...cellStyle, maxWidth: 180 }}>
                    <div
                      style={{
                        fontWeight: 600,
                        display: '-webkit-box',
                        WebkitLineClamp: 2,
                        WebkitBoxOrient: 'vertical',
                        overflow: 'hidden',
                      }}
                    >
                      {variant.itemName}
                    </div>
                  </td>
                  <td style={{ ...cellStyle, maxWidth: 140 }}>
                    <div
                      style={{
                        display: '-webkit-box',
                        WebkitLineClamp: 2,
                        WebkitBoxOrient: 'vertical',
                        overflow: 'hidden',
                      }}
                    >
                      {variant.styleName ?? variant.styleKey}
                    </div>
                  </td>
                  <td style={{ ...cellStyle, textAlign: 'center', width: 80 }}>{variant.difficulty ?? '—'}</td>
                  <td style={{ ...cellStyle, maxWidth: 220 }}>
                    <div
                      style={{
                        display: '-webkit-box',
                        WebkitLineClamp: 2,
                        WebkitBoxOrient: 'vertical',
                        overflow: 'hidden',
                      }}
                    >
                      {variant.tags.length > 0 ? variant.tags.join(', ') : '—'}
                    </div>
                  </td>
                  <td style={cellStyle}>
                    <span style={{ ...badgeStyle, ...accessBadgeStyle(variant.accessTier) }}>
                      {variant.accessTier === 'premium' ? 'Premium' : 'Free'}
                    </span>
                  </td>
                  <td style={cellStyle}>
                    <span style={{
                      ...badgeStyle,
                      ...(variant.published ? publishedBadgeStyle : draftBadgeStyle),
                    }}>
                      {variant.published ? 'Published' : 'Draft'}
                    </span>
                  </td>
                  <td style={cellStyle}>{createdAt}</td>
                  <td style={{ ...cellStyle, textAlign: 'right' }}>
                    <div style={{ display: 'flex', gap: '0.45rem', justifyContent: 'flex-end' }}>
                      <Button
                        type="button"
                        variant="secondary"
                        style={{ display: 'inline-flex', alignItems: 'center', justifyContent: 'center', padding: '0.35rem 0.6rem' }}
                        onClick={() => setSelectedVariant(variant)}
                        title="Edit variant"
                      >
                        <span aria-hidden="true">✏️</span>
                      </Button>
                      <Button
                        type="button"
                        variant="destructive"
                        style={{ display: 'inline-flex', alignItems: 'center', justifyContent: 'center', padding: '0.35rem 0.6rem' }}
                        title="Delete variant"
                      >
                        <span aria-hidden="true">🗑</span>
                      </Button>
                    </div>
                  </td>
                </tr>
              )
            })
          )}
        </tbody>
      </table>

      {selectedVariant ? (
        <aside
          style={{
            position: 'fixed',
            top: 0,
            right: 0,
            width: '420px',
            height: '100vh',
            backgroundColor: 'var(--background)',
            borderLeft: '1px solid var(--gray4)',
            boxShadow: '-10px 0 30px rgba(15, 23, 42, 0.12)',
            padding: '2rem 1.75rem',
            display: 'flex',
            flexDirection: 'column',
            gap: '1.25rem',
            zIndex: 50,
          }}
        >
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <h2 className="app-heading" style={{ fontSize: '1.3rem' }}>
                {selectedVariant.itemName}
              </h2>
              <p className="app-muted" style={{ marginTop: '0.35rem' }}>
                Style: {selectedVariant.styleName ?? selectedVariant.styleKey}
              </p>
            </div>
            <Button type="button" variant="subtle" onClick={() => setSelectedVariant(null)}>
              Close
            </Button>
          </div>

          <div style={{ display: 'grid', gap: '1rem', overflowY: 'auto' }}>
            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Trace path</label>
              <div
                style={{
                  background: 'var(--gray2)',
                  borderRadius: 10,
                  padding: '0.65rem 0.75rem',
                  fontSize: '0.9rem',
                  wordBreak: 'break-all',
                }}
              >
                {selectedVariant.tracePath ?? '—'}
              </div>
            </div>

            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Description</label>
              <textarea
                defaultValue={selectedVariant.description ?? ''}
                style={{
                  borderRadius: 10,
                  border: '1px solid var(--gray4)',
                  padding: '0.75rem',
                  background: 'var(--gray2)',
                  fontSize: '0.95rem',
                  minHeight: '120px',
                }}
                readOnly
              />
            </div>

            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Tags</label>
              <input
                type="text"
                value={selectedVariant.tags.join(', ')}
                style={{
                  borderRadius: 10,
                  border: '1px solid var(--gray4)',
                  padding: '0.6rem 0.75rem',
                  background: 'var(--gray2)',
                  fontSize: '0.95rem',
                }}
                readOnly
              />
            </div>

            <div style={{ display: 'grid', gap: '0.75rem', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))' }}>
              <div style={{ display: 'grid', gap: '0.35rem' }}>
                <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Difficulty</label>
                <input
                  type="number"
                  value={selectedVariant.difficulty ?? ''}
                  style={{
                    borderRadius: 10,
                    border: '1px solid var(--gray4)',
                    padding: '0.6rem 0.75rem',
                    background: 'var(--gray2)',
                    fontSize: '0.95rem',
                  }}
                  readOnly
                />
              </div>
              <div style={{ display: 'grid', gap: '0.35rem' }}>
                <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Access tier</label>
                <input
                  type="text"
                  value={selectedVariant.accessTier}
                  style={{
                    borderRadius: 10,
                    border: '1px solid var(--gray4)',
                    padding: '0.6rem 0.75rem',
                    background: 'var(--gray2)',
                    fontSize: '0.95rem',
                  }}
                  readOnly
                />
              </div>
            </div>

            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Status</label>
              <div>
                <span style={{
                  ...badgeStyle,
                  ...(selectedVariant.published ? publishedBadgeStyle : draftBadgeStyle),
                }}>
                  {selectedVariant.published ? 'Published' : 'Draft'}
                </span>
              </div>
            </div>

            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Created</label>
              <div className="app-muted">
                {selectedVariant.createdAt
                  ? new Date(selectedVariant.createdAt).toLocaleString()
                  : '—'}
              </div>
            </div>

            <div style={{ display: 'grid', gap: '0.35rem' }}>
              <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>Thumbnail</label>
              <div>
                {selectedVariant.tracePath ? (
                  <img
                    src={getCatalogAssetUrl(selectedVariant.tracePath)}
                    alt={selectedVariant.itemName}
                    style={{
                      width: '100%',
                      borderRadius: 16,
                      border: '1px solid var(--gray4)',
                      objectFit: 'cover',
                    }}
                  />
                ) : (
                  <div className="app-muted">No image available</div>
                )}
              </div>
            </div>
          </div>

          <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.75rem', marginTop: 'auto' }}>
            <Button type="button" variant="secondary" style={{ flex: 1 }}>
              Duplicate
            </Button>
            <Button type="button" variant="destructive" style={{ flex: 1 }}>
              Delete Variant
            </Button>
          </div>
        </aside>
      ) : null}
    </AdminShell>
  )
}
