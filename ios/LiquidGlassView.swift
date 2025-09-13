import UIKit

@objc public enum LiquidGlassEffect: Int {
  case regular
  case clear
  case none

  @available(iOS 26.0, *)
  var converted: UIGlassEffect.Style? {
    switch self {
    case .regular:
      return .regular
    case .clear:
      return .clear
    case .none:
      return nil
    }
  }
}

#if compiler(>=6.2)

@available(iOS 26.0, *)
@objc public class LiquidGlassViewImpl: UIVisualEffectView {
  private var isFirstMount: Bool = true
  @objc public var effectTintColor: UIColor?
  @objc public var interactive: Bool = false
  @objc public var style: LiquidGlassEffect = .regular

  public override func layoutSubviews() {
    if (self.effect != nil) { return }
    setupView()
    
    if isFirstMount {
      isFirstMount = false
    }
  }
  
  
  @available(iOS 26.0, *)
  @objc public func setupView() {
    guard let preferredStyle = style.converted else {
      UIView.animate {
        // TODO: Looks like only assigning nil is not working, check this after stable iOS 26 is rolled out.
        self.effect = UIVisualEffect()
      }
      return
    }
    
    let glassEffect = UIGlassEffect(style: preferredStyle)
    glassEffect.isInteractive = interactive
    glassEffect.tintColor = effectTintColor
    
    if isFirstMount {
      self.effect = glassEffect
    } else {
      // Animate only the effect is changed after first mount.
      UIView.animate { self.effect = glassEffect }
    }
  }
}

#else

@objc public class LiquidGlassViewImpl: UIView {}

#endif

