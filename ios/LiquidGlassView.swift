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

@objc public class LiquidGlassViewImpl: UIVisualEffectView {
  private static let isGlassEffectAvailable: Bool = {
    guard let glassEffectClass = NSClassFromString("UIGlassEffect") as? NSObject.Type else {
      return false
    }

    return glassEffectClass.responds(to: #selector(UIBlurEffect.init(style:)))
  }()

  private var hasConfiguredEffect: Bool = false
  private var hasLaidOutInCurrentWindow: Bool = false
  private var visibilityLink: CADisplayLink?

  // Composited alpha at or below which UIKit will not build the glass effect.
  private static let minimumRenderableAlpha: CGFloat = 0.02

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
      teardownEffect()
    }
  }

  public override func didMoveToWindow() {
    super.didMoveToWindow()

    guard window != nil else {
      return
    }

    // The view may keep the same bounds when it returns to a window, which
    // means UIKit does not otherwise need to run layout again.
    setNeedsLayout()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    guard window != nil, !hasLaidOutInCurrentWindow else {
      return
    }

    hasLaidOutInCurrentWindow = true

    // Assigning an empty effect forces UIKit to discard stale glass state
    // before a new effect is created for the current window.
    setEffectWithoutAnimation(UIVisualEffect())
    setupView()

    if !hasConfiguredEffect {
      setEffectWithoutAnimation(nil)
    }
  }

  @objc public func setupView() {
    // We shouldn't add the effect before the view's first layout in a window
    // React Native may call setupView() through updateProps before mount
    // So we need to explicitly check that layout has completed
    guard hasLaidOutInCurrentWindow else {
      return
    }

    guard #available(iOS 26.0, tvOS 26.0, *) else {
      return
    }

    // Early iOS 26 beta releases may not have a usable UIGlassEffect API.
    guard Self.isGlassEffectAvailable else {
      return
    }

    guard let preferredStyle = style.converted else {
      stopWaitingForVisibility()
      applyEffect(nil)
      return
    }

    // UIKit silently skips a glass effect created while the view is effectively
    // transparent, and never retries it, so a view that fades in from 0 would
    // keep rendering as a plain view. Wait until it is actually visible.
    guard isEffectRenderable else {
      waitForVisibility()
      return
    }

    stopWaitingForVisibility()

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

  @objc public func resetInteractiveEffect() {
    guard hasConfiguredEffect else { return }

    // Changing isInteractive on an existing instance doesn't do anything
    // So we need to set it to nil and reapply it with the new interactive value
    setEffectWithoutAnimation(nil)
    hasConfiguredEffect = false
    setupView()
  }

  @available(iOS 26.0, tvOS 26.0, *)
  private func applyEffect(_ effect: UIVisualEffect?) {
    if !hasConfiguredEffect || !animated {
      setEffectWithoutAnimation(effect)
      hasConfiguredEffect = true
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

  private func teardownEffect() {
    stopWaitingForVisibility()
    setEffectWithoutAnimation(nil)
    hasConfiguredEffect = false
    hasLaidOutInCurrentWindow = false
  }

  // The effect is rendered against the composited result of the whole superview
  // chain, so an opaque view inside a parent that is fading in is skipped too.
  private var isEffectRenderable: Bool {
    var opacity: CGFloat = 1
    var view: UIView? = self

    while let current = view {
      if current.isHidden {
        return false
      }

      opacity *= current.alpha
      view = current.superview
    }

    return opacity > Self.minimumRenderableAlpha
  }

  private func waitForVisibility() {
    guard visibilityLink == nil else {
      return
    }

    let link = CADisplayLink(
      target: WeakDisplayLinkProxy(self),
      selector: #selector(WeakDisplayLinkProxy.tick)
    )

    // A view that never becomes visible keeps this link alive, so do not ask for
    // the display's full rate: 30Hz is imperceptible within a fade and a quarter
    // of the wake-ups on a 120Hz screen.
    link.preferredFrameRateRange = CAFrameRateRange(minimum: 15, maximum: 60, preferred: 30)
    link.add(to: .main, forMode: .common)
    visibilityLink = link
  }

  fileprivate func onVisibilityTick() {
    guard isEffectRenderable else {
      return
    }

    setupView()
  }

  private func stopWaitingForVisibility() {
    visibilityLink?.invalidate()
    visibilityLink = nil
  }

  deinit {
    visibilityLink?.invalidate()
  }

  private func setEffectWithoutAnimation(_ effect: UIVisualEffect?) {
    UIView.performWithoutAnimation {
      self.effect = effect
    }
  }
}

// CADisplayLink retains its target, which would keep the view alive forever.
private final class WeakDisplayLinkProxy: NSObject {
  private weak var view: LiquidGlassViewImpl?

  init(_ view: LiquidGlassViewImpl) {
    self.view = view
  }

  @objc func tick() {
    view?.onVisibilityTick()
  }
}

#else

@objc public class LiquidGlassViewImpl: UIView {}

#endif
