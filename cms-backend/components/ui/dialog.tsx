import {
  Children,
  cloneElement,
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type CSSProperties,
  type ReactElement,
  type ReactNode,
  type MouseEvent,
} from 'react'
import { createPortal } from 'react-dom'

interface DialogContextValue {
  open: boolean
  setOpen: (open: boolean) => void
}

const DialogContext = createContext<DialogContextValue | null>(null)

const overlayStyle: CSSProperties = {
  position: 'fixed',
  inset: 0,
  backgroundColor: 'rgba(12, 15, 21, 0.55)',
  backdropFilter: 'blur(6px)',
}

const contentStyle: CSSProperties = {
  position: 'fixed',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  width: 'min(480px, calc(100vw - 2rem))',
  backgroundColor: 'var(--surface)',
  borderRadius: 16,
  border: '1px solid var(--border)',
  padding: '2rem',
  boxShadow: '0 40px 80px rgba(15, 23, 42, 0.22)',
}

export interface DialogProps {
  open: boolean
  onOpenChange?: (open: boolean) => void
  children: ReactNode
}

export function Dialog({ open, onOpenChange, children }: DialogProps) {
  const setOpen = useCallback(
    (next: boolean) => {
      onOpenChange?.(next)
    },
    [onOpenChange]
  )

  const value = useMemo<DialogContextValue>(() => ({ open, setOpen }), [open, setOpen])

  return <DialogContext.Provider value={value}>{children}</DialogContext.Provider>
}

const useDialogContext = () => {
  const ctx = useContext(DialogContext)
  if (!ctx) {
    throw new Error('Dialog components must be used within a <Dialog>')
  }
  return ctx
}

export interface DialogTriggerProps {
  children: ReactElement
}

export function DialogTrigger({ children }: DialogTriggerProps) {
  const { setOpen } = useDialogContext()
  type TriggerChildProps = {
    onClick?: (event: MouseEvent<HTMLElement>) => void
  }

  const child = Children.only(children) as ReactElement<TriggerChildProps>

  return cloneElement(child, {
    onClick: (event: MouseEvent<HTMLElement>) => {
      child.props.onClick?.(event)
      if (!event.defaultPrevented) setOpen(true)
    },
  } as Partial<TriggerChildProps>)
}

export interface DialogCloseProps {
  children: ReactElement
}

export function DialogClose({ children }: DialogCloseProps) {
  const { setOpen } = useDialogContext()
  type CloseChildProps = {
    onClick?: (event: MouseEvent<HTMLElement>) => void
  }

  const child = Children.only(children) as ReactElement<CloseChildProps>

  return cloneElement(child, {
    onClick: (event: MouseEvent<HTMLElement>) => {
      child.props.onClick?.(event)
      if (!event.defaultPrevented) setOpen(false)
    },
  } as Partial<CloseChildProps>)
}

export interface DialogContentProps {
  children: ReactNode
  style?: CSSProperties
}

export function DialogContent({ children, style }: DialogContentProps) {
  const { open, setOpen } = useDialogContext()
  const [container, setContainer] = useState<HTMLElement | null>(null)

  useEffect(() => {
    if (typeof document === 'undefined') return
    const node = document.createElement('div')
    document.body.appendChild(node)
    setContainer(node)

    return () => {
      document.body.removeChild(node)
      setContainer(null)
    }
  }, [])

  if (!open || typeof document === 'undefined' || !container) return null

  const content = (
    <>
      <div style={overlayStyle} onClick={() => setOpen(false)} />
      <div role="dialog" aria-modal="true" style={{ ...contentStyle, ...style }}>
        {children}
      </div>
    </>
  )

  return createPortal(content, container)
}

export interface DialogHeadingProps {
  children: ReactNode
}

export function DialogTitle({ children }: DialogHeadingProps) {
  return (
    <h2
      style={{
        margin: 0,
        fontSize: '1.25rem',
        fontWeight: 700,
        letterSpacing: '-0.01em',
      }}
    >
      {children}
    </h2>
  )
}

export interface DialogDescriptionProps {
  children: ReactNode
  style?: CSSProperties
}

export function DialogDescription({ children, style }: DialogDescriptionProps) {
  return (
    <p style={{ fontSize: '0.95rem', color: 'var(--muted-foreground)', margin: 0, ...style }}>{children}</p>
  )
}
