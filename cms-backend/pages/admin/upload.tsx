import type { CSSProperties, FormEvent } from 'react'
import { useCallback, useEffect, useRef, useState } from 'react'
import { useSupabaseClient } from '@supabase/auth-helpers-react'

import { AdminShell } from '../../components/layout/AdminShell'
import { Button } from '../../components/ui/button'

type SelectionMeta = {
  slug?: string
  key?: string
  categoryId?: string
}

type Selection = {
  id: string
  label: string
  caption?: string
  meta?: SelectionMeta
}

interface ComboboxFieldProps {
  label: string
  placeholder: string
  value: Selection | null
  onSelect: (option: Selection | null) => void
  fetchOptions: (query: string) => Promise<Selection[]>
  createOption?: (input: string) => Promise<Selection>
  disabledCreateReason?: string | null
}

const inputStyle: CSSProperties = {
  borderRadius: 10,
  border: '1px solid var(--gray4)',
  padding: '0.6rem 0.75rem',
  background: 'var(--gray2)',
  fontSize: '0.95rem',
}

const listStyle: CSSProperties = {
  position: 'absolute',
  top: 'calc(100% + 0.3rem)',
  left: 0,
  width: '100%',
  backgroundColor: 'var(--card)',
  border: '1px solid var(--gray4)',
  borderRadius: 10,
  boxShadow: '0 12px 25px rgba(15, 23, 42, 0.18)',
  maxHeight: 220,
  overflowY: 'auto',
  zIndex: 10,
}

const listItemStyle: CSSProperties = {
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'flex-start',
  gap: '0.2rem',
  padding: '0.55rem 0.7rem',
  width: '100%',
  textAlign: 'left',
  border: 'none',
  background: 'transparent',
  cursor: 'pointer',
}

const mutedItemStyle: CSSProperties = {
  padding: '0.55rem 0.7rem',
  fontSize: '0.8rem',
  color: 'var(--muted-foreground)',
}

const feedbackStyle = (tone: 'info' | 'error'): CSSProperties => ({
  fontSize: '0.8rem',
  color: tone === 'error' ? 'var(--red9)' : 'var(--muted-foreground)',
})

const toSlug = (value: string) =>
  value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')

function ComboboxField({
  label,
  placeholder,
  value,
  onSelect,
  fetchOptions,
  createOption,
  disabledCreateReason,
}: ComboboxFieldProps) {
  const [inputValue, setInputValue] = useState(value?.label ?? '')
  const [options, setOptions] = useState<Selection[]>([])
  const [isOpen, setIsOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [isCreating, setIsCreating] = useState(false)
  const [feedback, setFeedback] = useState<{ message: string; tone: 'info' | 'error' } | null>(null)

  useEffect(() => {
    setInputValue(value?.label ?? '')
  }, [value?.id, value?.label])

  useEffect(() => {
    let active = true
    const query = inputValue.trim()
    setIsLoading(true)
    setFeedback(null)

    const handler = setTimeout(async () => {
      try {
        const fetched = await fetchOptions(query)
        if (!active) return
        setOptions(fetched)
        if (fetched.length === 0 && query) {
          setFeedback({ message: 'No matches found.', tone: 'info' })
        }
      } catch (error) {
        if (!active) return
        const message = error instanceof Error ? error.message : 'Failed to load options.'
        setFeedback({ message, tone: 'error' })
        setOptions([])
      } finally {
        if (active) setIsLoading(false)
      }
    }, 200)

    return () => {
      active = false
      clearTimeout(handler)
    }
  }, [inputValue, fetchOptions])

  const normalizedInput = inputValue.trim()
  const showCreateOption = Boolean(
    createOption &&
      normalizedInput &&
      !options.some((option) => option.label.toLowerCase() === normalizedInput.toLowerCase())
  )

  const handleSelect = (option: Selection | null) => {
    if (!option) {
      setInputValue('')
      onSelect(null)
      return
    }
    setInputValue(option.label)
    onSelect(option)
    setIsOpen(false)
    setFeedback(null)
  }

  const handleCreate = async () => {
    if (!createOption || !normalizedInput) return
    if (disabledCreateReason) {
      setFeedback({ message: disabledCreateReason, tone: 'info' })
      return
    }
    setIsCreating(true)
    setFeedback(null)
    try {
      const created = await createOption(normalizedInput)
      setOptions((prev) => [created, ...prev.filter((option) => option.id !== created.id)])
      handleSelect(created)
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Failed to create record.'
      setFeedback({ message, tone: 'error' })
    } finally {
      setIsCreating(false)
    }
  }

  return (
    <div style={{ position: 'relative', display: 'grid', gap: '0.35rem' }}>
      <label style={{ fontSize: '0.85rem', fontWeight: 600 }}>{label}</label>
      <input
        type="text"
        value={inputValue}
        onChange={(event) => setInputValue(event.target.value)}
        onFocus={() => setIsOpen(true)}
        onBlur={() => setTimeout(() => setIsOpen(false), 120)}
        placeholder={placeholder}
        autoComplete="off"
        style={inputStyle}
      />
      {isOpen && (
        <div style={listStyle}>
          {isLoading && <div style={mutedItemStyle}>Searching…</div>}
          {!isLoading && options.map((option) => (
            <button
              key={option.id}
              type="button"
              style={{
                ...listItemStyle,
                backgroundColor: value?.id === option.id ? 'rgba(37, 99, 235, 0.12)' : 'transparent',
                color: 'inherit',
              }}
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => handleSelect(option)}
            >
              <span style={{ fontWeight: 600 }}>{option.label}</span>
              {option.caption ? (
                <span style={{ fontSize: '0.75rem', color: 'var(--muted-foreground)' }}>{option.caption}</span>
              ) : null}
            </button>
          ))}
          {!isLoading && value && !normalizedInput && (
            <button
              type="button"
              style={{ ...listItemStyle, color: 'var(--muted-foreground)' }}
              onMouseDown={(event) => event.preventDefault()}
              onClick={() => handleSelect(null)}
            >
              Clear selection
            </button>
          )}
          {!isLoading && showCreateOption && (
            <>
              <button
                type="button"
                style={{
                  ...listItemStyle,
                  color: disabledCreateReason ? 'var(--muted-foreground)' : 'var(--sidebar-foreground)',
                  backgroundColor: disabledCreateReason ? 'transparent' : 'var(--sidebar)',
                }}
                onMouseDown={(event) => event.preventDefault()}
                onClick={handleCreate}
                disabled={Boolean(disabledCreateReason) || isCreating}
              >
                {isCreating ? 'Creating…' : `Create "${normalizedInput}"`}
              </button>
              {disabledCreateReason && (
                <div style={mutedItemStyle}>{disabledCreateReason}</div>
              )}
            </>
          )}
          {!isLoading && !showCreateOption && options.length === 0 && !feedback && (
            <div style={mutedItemStyle}>Start typing to search.</div>
          )}
        </div>
      )}
      {feedback ? <div style={feedbackStyle(feedback.tone)}>{feedback.message}</div> : null}
    </div>
  )
}

export default function UploadPage() {
  const supabase = useSupabaseClient()
  const formRef = useRef<HTMLFormElement>(null)
  const [categorySelection, setCategorySelection] = useState<Selection | null>(null)
  const [itemSelection, setItemSelection] = useState<Selection | null>(null)
  const [styleSelection, setStyleSelection] = useState<Selection | null>(null)
  const [formMessage, setFormMessage] = useState<string | null>(null)
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [traceFile, setTraceFile] = useState<File | null>(null)
  const [tracePreviewUrl, setTracePreviewUrl] = useState<string | null>(null)
  const [traceError, setTraceError] = useState<string | null>(null)
  const [isHovering, setIsHovering] = useState(false)
  const [isComputingTracePath, setIsComputingTracePath] = useState(false)

  useEffect(() => {
    async function checkAuth() {
      const { data: sessionData } = await supabase.auth.getSession()
      const { data: userData } = await supabase.auth.getUser()

      console.log('Debug session data:', sessionData)
      console.log('Debug user data:', userData)
    }

    checkAuth()
  }, [supabase])

  const clearTrace = useCallback(() => {
    if (tracePreviewUrl) {
      URL.revokeObjectURL(tracePreviewUrl)
    }
    setTraceFile(null)
    setTracePreviewUrl(null)
    setTraceError(null)
  }, [tracePreviewUrl])

  useEffect(() => {
    if (!categorySelection) {
      setItemSelection(null)
    }
  }, [categorySelection?.id])

  useEffect(() => {
    return () => {
      if (tracePreviewUrl) {
        URL.revokeObjectURL(tracePreviewUrl)
      }
    }
  }, [tracePreviewUrl])

  const fetchCategories = useCallback(
    async (query: string) => {
      const term = query.trim()
      let builder = supabase.from('categories').select('id, name, slug').order('name').limit(6)
      if (term) {
        builder = builder.ilike('name', `%${term}%`)
      }
      const { data, error } = await builder
      if (error) throw new Error(error.message)
      return (data ?? []).map((category) => ({
        id: category.id,
        label: category.name,
        caption: category.slug,
        meta: { slug: category.slug },
      }))
    },
    [supabase]
  )

  const createCategory = useCallback(
    async (name: string) => {
      const slug = toSlug(name)
      const { data, error } = await supabase
        .from('categories')
        .insert({ name, slug })
        .select('id, name, slug')
        .single()
      if (error) throw new Error(error.message)
      return {
        id: data.id,
        label: data.name,
        caption: data.slug,
        meta: { slug: data.slug },
      }
    },
    [supabase]
  )

  const fetchItems = useCallback(
    async (query: string) => {
      const term = query.trim()
      let builder = supabase.from('items').select('id, name, slug, category_id').order('name').limit(6)
      if (categorySelection?.id) {
        builder = builder.eq('category_id', categorySelection.id)
      }
      if (term) {
        builder = builder.ilike('name', `%${term}%`)
      }
      const { data, error } = await builder
      if (error) throw new Error(error.message)
      return (data ?? []).map((item) => ({
        id: item.id,
        label: item.name,
        caption: item.slug,
        meta: { slug: item.slug, categoryId: item.category_id },
      }))
    },
    [supabase, categorySelection?.id]
  )

  const createItem = useCallback(
    async (name: string) => {
      if (!categorySelection) {
        throw new Error('Select a category before adding a new item.')
      }
      const slug = toSlug(name)
      const { data, error } = await supabase
        .from('items')
        .insert({ name, slug, category_id: categorySelection.id })
        .select('id, name, slug, category_id')
        .single()
      if (error) throw new Error(error.message)
      return {
        id: data.id,
        label: data.name,
        caption: data.slug,
        meta: { slug: data.slug, categoryId: data.category_id },
      }
    },
    [supabase, categorySelection]
  )

  const fetchStyles = useCallback(
    async (query: string) => {
      const term = query.trim()
      let builder = supabase.from('styles').select('id, name, key').order('name').limit(6)
      if (term) {
        builder = builder.ilike('name', `%${term}%`)
      }
      const { data, error } = await builder
      if (error) throw new Error(error.message)
      return (data ?? []).map((style) => ({
        id: style.id,
        label: style.name,
        caption: style.key,
        meta: { key: style.key },
      }))
    },
    [supabase]
  )

  const createStyle = useCallback(
    async (name: string) => {
      const key = toSlug(name)
      const { data, error } = await supabase
        .from('styles')
        .insert({ name, key })
        .select('id, name, key')
        .single()
      if (error) throw new Error(error.message)
      return {
        id: data.id,
        label: data.name,
        caption: data.key,
        meta: { key: data.key },
      }
    },
    [supabase]
  )

  const handleSubmit = useCallback(
    async (event: FormEvent<HTMLFormElement>) => {
      event.preventDefault()
      setFormMessage(null)

      if (!categorySelection || !itemSelection || !styleSelection) {
        setFormMessage('Select a category, item, and style before submitting.')
        return
      }

      if (!traceFile) {
        setFormMessage('Upload a trace overlay before submitting.')
        return
      }

      const itemSlug = itemSelection.meta?.slug
      const styleKey = styleSelection.meta?.key

      if (!itemSlug || !styleKey) {
        setFormMessage('Selected item or style is missing a slug/key. Please try again.')
        return
      }

      const formData = new FormData(event.currentTarget)
      const description = (formData.get('description') as string) ?? ''
      const tagsInput = ((formData.get('tags') as string) ?? '').trim()
      const tags = tagsInput
        ? tagsInput
            .split(',')
            .map((tag) => tag.trim())
            .filter(Boolean)
        : []
      const difficultyValue = Number(formData.get('difficulty'))
      const difficulty = Number.isFinite(difficultyValue) ? difficultyValue : null
      const accessTier = (formData.get('access_tier') as string) || 'free'
      const fileExtension = traceFile.name.includes('.')
        ? traceFile.name.substring(traceFile.name.lastIndexOf('.') + 1).toLowerCase()
        : 'png'
      const filePath = `${itemSlug}/${styleKey}.${fileExtension}`

      setIsSubmitting(true)

      try {
        const { data: userResult } = await supabase.auth.getUser()
        console.log('Supabase Auth UID', userResult?.user?.id ?? null)

        setFormMessage('Saving variant metadata…')
        const { data: variant, error: insertError } = await supabase
          .from('item_style_variants')
          .insert({
            item_id: itemSelection.id,
            style_id: styleSelection.id,
            description,
            tags: tags.length > 0 ? tags : null,
            difficulty,
            access_tier: accessTier,
            trace_path: filePath,
          })
          .select('id')
          .single()

        if (insertError || !variant) {
          throw new Error(insertError?.message ?? 'Unable to save variant metadata.')
        }

        setFormMessage('Uploading trace overlay…')
        const { error: uploadError } = await supabase.storage
          .from('catalog')
          .upload(filePath, traceFile, { upsert: true })

        if (uploadError) {
          console.error('Trace overlay upload failed:', uploadError)
          await supabase.from('item_style_variants').delete().eq('id', variant.id)
          throw new Error(uploadError.message ?? 'Failed to upload trace overlay.')
        }

        setFormMessage('Variant successfully created and image uploaded.')
        formRef.current?.reset()
        setCategorySelection(null)
        setItemSelection(null)
        setStyleSelection(null)
        clearTrace()
        setIsHovering(false)
      } catch (submissionError) {
        if (submissionError instanceof Error) {
          console.error('Variant submission failed:', submissionError)
        }
        setFormMessage(
          submissionError instanceof Error
            ? submissionError.message
            : 'Something went wrong while saving the variant.'
        )
      } finally {
        setIsSubmitting(false)
      }
    },
    [
      categorySelection,
      clearTrace,
      itemSelection,
      styleSelection,
      supabase,
      traceFile,
    ]
  )

  useEffect(() => {
    if (itemSelection?.meta?.slug && styleSelection?.meta?.key && traceFile) {
      setIsComputingTracePath(true)
      const timeout = setTimeout(() => {
        setIsComputingTracePath(false)
      }, 200)
      return () => clearTimeout(timeout)
    }
    setIsComputingTracePath(false)
  }, [itemSelection?.meta?.slug, styleSelection?.meta?.key, traceFile])

  const handleFiles = (files: FileList | null) => {
    if (isSubmitting) {
      return
    }
    setTraceError(null)
    if (!files || files.length === 0) {
      clearTrace()
      return
    }

    const file = files[0]
    const allowedTypes = ['image/png', 'image/jpeg', 'image/svg+xml']
    if (!allowedTypes.includes(file.type)) {
      clearTrace()
      setTraceError('Only PNG, JPG, or SVG files are allowed.')
      return
    }

    if (tracePreviewUrl) {
      URL.revokeObjectURL(tracePreviewUrl)
    }

    setTraceFile(file)
    setTracePreviewUrl(URL.createObjectURL(file))
  }

  const handleDrop = (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault()
    event.stopPropagation()
    if (isSubmitting) {
      setIsHovering(false)
      return
    }
    setIsHovering(false)
    handleFiles(event.dataTransfer.files)
  }

  return (
    <AdminShell
      title="Upload asset"
      subtitle="Drop overlays, prompt templates, or references into the catalog and tag them for discovery."
    >
      <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: '1rem' }}>
        <Button
          type="button"
          variant="secondary"
          onClick={async () => {
            const { data: sessionInfo } = await supabase.auth.getSession()
            console.log('Session data:', sessionInfo ?? null)
          }}
        >
          Log session info
        </Button>
      </div>
      <form ref={formRef} onSubmit={handleSubmit} style={{ display: 'grid', gap: '1.5rem' }}>
        <section
          onDragEnter={(event) => {
            event.preventDefault()
            event.stopPropagation()
            setIsHovering(true)
          }}
          onDragOver={(event) => {
            event.preventDefault()
            event.stopPropagation()
            if (!isHovering) setIsHovering(true)
          }}
          onDragLeave={(event) => {
            event.preventDefault()
            event.stopPropagation()
            if (event.currentTarget.contains(event.relatedTarget as Node)) return
            setIsHovering(false)
          }}
          onDrop={handleDrop}
          style={{
            border: traceFile ? '1px solid var(--gray4)' : `1px dashed ${isHovering ? 'var(--blue9)' : 'var(--gray5)'}`,
            borderRadius: 16,
            padding: '2rem',
            textAlign: 'center',
            background: traceFile ? 'var(--card)' : isHovering ? 'rgba(37, 99, 235, 0.08)' : 'var(--gray2)',
            display: 'grid',
            gap: '0.75rem',
            position: 'relative',
          }}
        >
          {!traceFile ? (
            <>
              <div>
                <p style={{ fontWeight: 600, marginBottom: '0.35rem' }}>Upload trace overlay</p>
                <p className="app-muted" style={{ marginBottom: '1.25rem' }}>
                  PNG, JPG, or SVG up to 25&nbsp;MB. Stored as{' '}
                  <code>{'catalog/{item-slug}/{style-key}.png'}</code>.
                </p>
              </div>
              <Button
                type="button"
                variant="secondary"
                disabled={isSubmitting}
                onClick={() => {
                  if (!isSubmitting) {
                    document.getElementById('trace_path')?.click()
                  }
                }}
              >
                {isHovering ? 'Drop file to upload' : 'Browse locally'}
              </Button>
              <p className="app-muted" style={{ fontSize: '0.8rem' }}>
                or drag & drop your file here
              </p>
            </>
          ) : (
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '1rem',
                justifyContent: 'center',
              }}
            >
              {tracePreviewUrl ? (
                <img
                  src={tracePreviewUrl}
                  alt={traceFile.name}
                  style={{
                    width: 72,
                    height: 72,
                    objectFit: 'cover',
                    borderRadius: 12,
                    border: '1px solid var(--gray4)',
                    backgroundColor: 'var(--gray2)',
                  }}
                />
              ) : null}
              <div style={{ textAlign: 'left' }}>
                <p style={{ fontWeight: 600 }}>{traceFile.name}</p>
                <p className="app-muted" style={{ fontSize: '0.8rem' }}>
                  {(traceFile.size / 1024).toFixed(1)} KB
                </p>
                {isComputingTracePath ? (
                  <p className="app-muted" style={{ fontSize: '0.75rem' }}>
                    Computing storage path…
                  </p>
                ) : null}
              </div>
              <Button
                type="button"
                variant="subtle"
                disabled={isSubmitting}
                onClick={() => {
                  if (!isSubmitting) {
                    clearTrace()
                  }
                }}
              >
                Remove
              </Button>
            </div>
          )}
          <input
            id="trace_path"
            name="trace_path"
            type="file"
            accept="image/png,image/jpeg,image/svg+xml"
            style={{ display: 'none' }}
            onChange={(event) => handleFiles(event.target.files)}
          />
          {traceError ? <p style={{ color: 'var(--red9)', fontSize: '0.85rem' }}>{traceError}</p> : null}
        </section>

        <div style={{ display: 'grid', gap: '1rem' }}>
          <ComboboxField
            label="Category"
            placeholder="Search categories…"
            value={categorySelection}
            onSelect={setCategorySelection}
            fetchOptions={fetchCategories}
            createOption={createCategory}
          />

          <ComboboxField
            label="Item"
            placeholder="Search items…"
            value={itemSelection}
            onSelect={setItemSelection}
            fetchOptions={fetchItems}
            createOption={createItem}
            disabledCreateReason={
              categorySelection ? null : 'Select a category before adding a new item.'
            }
          />

          <ComboboxField
            label="Style"
            placeholder="Search styles…"
            value={styleSelection}
            onSelect={setStyleSelection}
            fetchOptions={fetchStyles}
            createOption={createStyle}
          />

          <div style={{ display: 'grid', gap: '0.35rem' }}>
            <label htmlFor="description" style={{ fontSize: '0.85rem', fontWeight: 600 }}>
              Description
            </label>
            <textarea
              id="description"
              name="description"
              rows={4}
              placeholder="Describe how to use this variant during tracing."
              style={{
                borderRadius: 10,
                border: '1px solid var(--gray4)',
                padding: '0.75rem',
                background: 'var(--gray2)',
                fontSize: '0.95rem',
                resize: 'vertical',
              }}
            />
          </div>

          <div style={{ display: 'grid', gap: '0.35rem' }}>
            <label htmlFor="tags" style={{ fontSize: '0.85rem', fontWeight: 600 }}>
              Tags
            </label>
            <input
              id="tags"
              name="tags"
              type="text"
              placeholder="Comma separated keywords"
              style={inputStyle}
            />
          </div>

          <div style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap' }}>
            <div style={{ flex: '1 1 220px', display: 'grid', gap: '0.35rem' }}>
              <label htmlFor="difficulty" style={{ fontSize: '0.85rem', fontWeight: 600 }}>
                Difficulty
              </label>
              <select id="difficulty" name="difficulty" style={inputStyle} defaultValue="">
                <option value="" disabled>
                  Select difficulty
                </option>
                {[1, 2, 3, 4, 5].map((level) => (
                  <option key={level} value={level}>
                    {level}
                  </option>
                ))}
              </select>
            </div>

            <div style={{ flex: '1 1 220px', display: 'grid', gap: '0.35rem' }}>
              <label htmlFor="access_tier" style={{ fontSize: '0.85rem', fontWeight: 600 }}>
                Access Tier
              </label>
              <select id="access_tier" name="access_tier" style={inputStyle} defaultValue="">
                <option value="" disabled>
                  Select tier
                </option>
                <option value="free">Free</option>
                <option value="premium">Premium</option>
              </select>
            </div>
          </div>
        </div>

        <input type="hidden" name="category_id" value={categorySelection?.id ?? ''} />
        <input type="hidden" name="item_id" value={itemSelection?.id ?? ''} />
        <input type="hidden" name="style_id" value={styleSelection?.id ?? ''} />

        {formMessage ? (
          <p style={{ color: formMessage.startsWith('Variant') ? 'var(--muted-foreground)' : 'var(--red9)' }}>
            {formMessage}
          </p>
        ) : null}

        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.75rem' }}>
          <Button type="button" variant="subtle" disabled={isSubmitting}>
            Save draft
          </Button>
          <Button type="submit" disabled={isSubmitting}>
            {isSubmitting ? 'Saving…' : 'Submit for review'}
          </Button>
        </div>
      </form>
    </AdminShell>
  )
}
