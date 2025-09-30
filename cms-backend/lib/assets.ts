import supabase from './supabase'

export function getCatalogAssetUrl(tracePath?: string | null): string {
  if (!tracePath) return ''

  const { data } = supabase.storage.from('catalog').getPublicUrl(tracePath)
  const url = data?.publicUrl ?? ''
  if (!url) {
    console.warn('No public URL returned for trace path:', tracePath)
  }
  return url
}
