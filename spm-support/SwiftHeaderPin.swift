// Pins the Swift API mirrored by spm-headers/LiquidGlass-Swift.h.
// Swift type checking cannot pin enum raw values or Objective-C runtime names;
// compare those with the generated Swift header when changing the Swift API.
import UIKit

#if compiler(>=6.2)
@MainActor
private func pinSwiftHeader(_ view: LiquidGlassViewImpl, _ container: LiquidGlassConatinerViewImpl) {
  let _: UIVisualEffectView = view
  let _: UIVisualEffectView = container
  let _: UIColor? = view.effectTintColor
  let _: Bool = view.interactive
  let _: LiquidGlassEffect = view.style
  let _: Bool = view.animated
  let _: CGFloat = view.animationDuration
  let _: Bool = view.hasAnimationDuration
  let _: CGFloat = container.spacing
  view.effectTintColor = nil
  view.interactive = false
  view.style = .regular
  view.animated = false
  view.animationDuration = 0
  view.hasAnimationDuration = false
  container.spacing = 0
  view.setupView()
  view.resetInteractiveEffect()
}

private let swiftHeaderSelectors: [Selector] = [
  #selector(getter: LiquidGlassViewImpl.effectTintColor),
  #selector(setter: LiquidGlassViewImpl.effectTintColor),
  #selector(getter: LiquidGlassViewImpl.interactive),
  #selector(setter: LiquidGlassViewImpl.interactive),
  #selector(getter: LiquidGlassViewImpl.style),
  #selector(setter: LiquidGlassViewImpl.style),
  #selector(getter: LiquidGlassViewImpl.animated),
  #selector(setter: LiquidGlassViewImpl.animated),
  #selector(getter: LiquidGlassViewImpl.animationDuration),
  #selector(setter: LiquidGlassViewImpl.animationDuration),
  #selector(getter: LiquidGlassViewImpl.hasAnimationDuration),
  #selector(setter: LiquidGlassViewImpl.hasAnimationDuration),
  #selector(LiquidGlassViewImpl.setupView),
  #selector(LiquidGlassViewImpl.resetInteractiveEffect),
  #selector(getter: LiquidGlassConatinerViewImpl.spacing),
  #selector(setter: LiquidGlassConatinerViewImpl.spacing),
]
#endif
