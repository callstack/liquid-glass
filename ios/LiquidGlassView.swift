import UIKit


#if compiler(>=6.2)

@available(iOS 26.0, *)
@objc public class LiquidGlassViewImpl: UIVisualEffectView {
  @objc public var effectTintColor: UIColor?
  @objc public var interactive: Bool = false
  @objc public var style: UIGlassEffect.Style = .regular

  public override func layoutSubviews() {
    if (self.effect != nil) { return }
    setupView()
  }
  
  @available(iOS 26.0, *)
  @objc public func setupView() {
    let glassEffect = UIGlassEffect(style: style)
    glassEffect.isInteractive = interactive
    glassEffect.tintColor = effectTintColor
    self.effect = glassEffect
  }
}

#else

@objc public class LiquidGlassViewImpl: UIView {}

#endif

