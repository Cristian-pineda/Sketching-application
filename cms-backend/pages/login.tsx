import { useState } from 'react'
import { useSupabaseClient, useUser } from '@supabase/auth-helpers-react'
import { useRouter } from 'next/router'
import { Button } from '../components/ui/button'

export default function Login() {
  const supabase = useSupabaseClient()
  const user = useUser()
  const router = useRouter()
  const [email, setEmail] = useState('')

  if (user) {
    const dest = (router.query.redirectedFrom as string) || '/admin'
    if (typeof window !== 'undefined') router.replace(dest)
  }

  async function signInWithEmail(e: React.FormEvent) {
    e.preventDefault()
    const { error } = await supabase.auth.signInWithOtp({ email })
    if (error) alert(error.message)
    else alert('Magic link sent! Check your email.')
  }

  async function signInWithGithub() {
    const { error } = await supabase.auth.signInWithOAuth({ provider: 'github' })
    if (error) alert(error.message)
  }

  return (
    <main
      style={{
        minHeight: '100vh',
        display: 'grid',
        placeItems: 'center',
        background: 'radial-gradient(circle at top, rgba(99, 102, 241, 0.12), transparent 60%)',
        padding: '2rem',
      }}
    >
      <section
        className="app-surface"
        style={{
          maxWidth: 420,
          width: '100%',
          padding: '2rem',
          borderRadius: 16,
        }}
      >
        <h1 className="app-heading" style={{ fontSize: '1.6rem', marginBottom: '0.35rem' }}>
          Sign in to CMS
        </h1>
        <p className="app-muted" style={{ marginBottom: '1.75rem' }}>
          Manage the assets that power SketchTracer’s discovery and tracing experiences.
        </p>

        <form onSubmit={signInWithEmail} style={{ display: 'grid', gap: '1rem' }}>
          <label htmlFor="email" style={{ fontSize: '0.85rem', fontWeight: 600 }}>
            Work email
          </label>
          <input
            id="email"
            type="email"
            placeholder="you@sketchtracer.co"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            style={{
              borderRadius: 12,
              border: '1px solid var(--gray4)',
              padding: '0.75rem 0.85rem',
              fontSize: '0.95rem',
              background: 'var(--gray2)',
            }}
          />
          <Button type="submit">Send magic link</Button>
        </form>

        <div
          style={{
            display: 'grid',
            gap: '0.75rem',
            marginTop: '2rem',
            borderTop: '1px solid var(--gray4)',
            paddingTop: '1.5rem',
          }}
        >
          <p className="app-muted" style={{ fontSize: '0.85rem' }}>
            Or authenticate with a connected provider
          </p>
          <Button type="button" variant="secondary" onClick={signInWithGithub}>
            Continue with GitHub
          </Button>
        </div>
      </section>
    </main>
  )
}
