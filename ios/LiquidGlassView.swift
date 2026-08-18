import UIKit

@objc public enum LiquidGlassEffect: Int {
  case regular
  case clear
  case none

#if compiler(>=6.2)
  @available(iOS 26.0, tvOS 26.0, *)
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
#endif

}

#if compiler(>=6.2)

@available(iOS 26.0, tvOS 26.0, *)
@objc public class LiquidGlassViewImpl: UIVisualEffectView {
  private var isFirstEffectApplicationForWindow: Bool = true

  @objc public var effectTintColor: UIColor?
  @objc public var interactive: Bool = false
  @objc public var style: LiquidGlassEffect = .regular
  @objc public var animated: Bool = true
  @objc public var animationDuration: CGFloat = 0
  @objc public var hasAnimationDuration: Bool = false

  public override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)

    // We keep the effect only when the view belongs to a window
    // When interactive is enabled, UIKit may register pointer-interaction
    // or subtree-monitoring state to the view's UIWindow
    // Any stale reference to the detached view after unmount may crash
    // So we cleanup the effect when the window changes while the old window is available
    if let currentWindow = window, currentWindow !== newWindow {
      effect = nil
      isFirstEffectApplicationForWindow = true
    }
  }

  public override func didMoveToWindow() {
    super.didMoveToWindow()

    setupView()
  }

  @objc public func setupView() {
    // We shouldn't add the effect if the view is not attached to a window
    // React Native may call setupView() through updateProps before mount
    // So we need to explicitly check for window presence
    guard window != nil else {
      return
    }

    guard #available(iOS 26.0, tvOS 26.0, *) else {
      return
    }

    // Runtime check to ensure UIGlassEffect is available
    // This handles cases where early iOS 26 beta releases may not have this API
    guard let glassEffectClass = NSClassFromString("UIGlassEffect") as? NSObject.Type else {
      return
    }

    // Verify that the effectWithStyle: selector is available
    // This provides an additional safety check for early beta versions
    guard glassEffectClass.responds(to: Selector(("effectWithStyle:"))) else {
      return
    }

    guard let preferredStyle = style.converted else {
      // TODO: Looks like only assigning nil is not working, check this after stable iOS 26 is rolled out.
      applyEffect(UIVisualEffect())
      return
    }

    let glassEffect = UIGlassEffect(style: preferredStyle)

    glassEffect.isInteractive = interactive
    glassEffect.tintColor = effectTintColor

    applyEffect(glassEffect)

    // UIGlassEffect can reconfigure the internal contentView in a way that
    // disables user interaction when no subviews are present at the time the
    // effect is applied. In React Native (Fabric), child component views may
    // be mounted into contentView *after* setupView() has applied the effect,
    // leaving contentView with userInteractionEnabled == false for the
    // lifetime of this view. Force it back on so touches always reach children.
    self.contentView.isUserInteractionEnabled = true
  }

  private func applyEffect(_ effect: UIVisualEffect) {
    // Don't animate the effect when attaching to a window or when animation is disabled
    // This ensures that the effect animation isn't visible on window attachment
    // e.g. on initial mount, reattachment, or moving to another window
    if isFirstEffectApplicationForWindow || !animated {
      self.effect = effect
      isFirstEffectApplicationForWindow = false
      return
    }

    if hasAnimationDuration {
      UIView.animate(withDuration: TimeInterval(animationDuration)) {
        self.effect = effect
      }
    } else {
      UIView.animate {
        self.effect = effect
      }
    }
  }
}

#else

@objc public class LiquidGlassViewImpl: UIView {}

#endif
