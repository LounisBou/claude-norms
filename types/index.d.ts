// The value the norms hooks module keeps in the host's $.state: the scope
// /norms:check computed in this session, its head and the time (hooks/record.ts).
export type NormsScopeMark = { head: string; at: number }

declare module 'claude-code' {
  interface PluginState {
    norms: { scopeMark: NormsScopeMark | null }
  }
}
