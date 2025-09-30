import type { AppProps } from 'next/app'
import { useState } from 'react'
import { SessionContextProvider } from '@supabase/auth-helpers-react'
import { Session } from '@supabase/auth-helpers-nextjs'
import { createBrowserSupabaseClient } from '@supabase/auth-helpers-nextjs'

import '../styles/globals.css'

export default function MyApp({
  Component,
  pageProps,
}: AppProps<{ initialSession: Session }>) {
  const [supabaseClient] = useState(() => createBrowserSupabaseClient())

  return (
    <SessionContextProvider supabaseClient={supabaseClient} initialSession={pageProps.initialSession}>
      <Component {...pageProps} />
    </SessionContextProvider>
  )
}
