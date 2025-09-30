import { Children, cloneElement, forwardRef } from 'react'
import type {
  ButtonHTMLAttributes,
  CSSProperties,
  ElementRef,
  ReactElement,
  ReactNode,
  MouseEvent,
} from 'react'

type ButtonVariant = 'primary' | 'secondary' | 'subtle' | 'destructive'
type ButtonSize = 'sm' | 'md' | 'lg'

const baseStyle: CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: '0.5rem',
  borderRadius: 8,
  border: '1px solid transparent',
  fontWeight: 600,
  letterSpacing: '-0.01em',
  transition: 'background-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease',
  cursor: 'pointer',
}

const variantStyle: Record<ButtonVariant, CSSProperties> = {
  primary: {
    backgroundColor: 'var(--blue9)',
    color: 'black',
    boxShadow: '0 6px 20px rgba(25, 118, 210, 0.25)',
  },
  secondary: {
    backgroundColor: 'transparent',
    color: 'var(--gray12)',
    border: '1px solid var(--gray5)',
    boxShadow: '0 1px 2px rgba(15, 23, 42, 0.08)',
  },
  subtle: {
    backgroundColor: 'var(--gray3)',
    color: 'var(--gray12)',
  },
  destructive: {
    backgroundColor: 'var(--red9)',
    color: 'white',
    boxShadow: '0 6px 20px rgba(229, 57, 53, 0.25)',
  },
}

const sizeStyle: Record<ButtonSize, CSSProperties> = {
  sm: { padding: '0.4rem 0.9rem', fontSize: '0.85rem' },
  md: { padding: '0.55rem 1.2rem', fontSize: '0.95rem' },
  lg: { padding: '0.75rem 1.5rem', fontSize: '1.05rem' },
}

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  asChild?: boolean
  variant?: ButtonVariant
  size?: ButtonSize
  icon?: ReactNode
}

const mergeStyle = (
  user: CSSProperties | undefined,
  variant: CSSProperties,
  size: CSSProperties
): CSSProperties => ({
  ...baseStyle,
  ...variant,
  ...size,
  ...user,
})

export const Button = forwardRef<ElementRef<'button'>, ButtonProps>(
  ({ asChild, style, variant = 'primary', size = 'md', icon, children, ...rest }, ref) => {
    const componentStyle = mergeStyle(style, variantStyle[variant], sizeStyle[size])

    if (asChild) {
      type ChildProps = {
        style?: CSSProperties
        onClick?: (event: MouseEvent<HTMLElement>) => void
        children?: ReactNode
      }

      const child = Children.only(children) as ReactElement<ChildProps>
      const existingStyle = child.props.style
      const handleClick = child.props.onClick
      const { onClick: buttonClick, ...buttonRest } = rest

      const mergedChild = cloneElement(
        child,
        {
          ...buttonRest,
          style: { ...componentStyle, ...existingStyle },
          onClick: (event: MouseEvent<HTMLElement>) => {
            if (buttonClick) buttonClick(event as unknown as MouseEvent<HTMLButtonElement>)
            if (!event.defaultPrevented) handleClick?.(event)
          },
        },
        <>
          {icon}
          {child.props.children}
        </>
      )

      return mergedChild
    }

    return (
      <button ref={ref} style={componentStyle} {...rest}>
        {icon}
        {children}
      </button>
    )
  }
)

Button.displayName = 'Button'
