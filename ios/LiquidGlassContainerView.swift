import UIKit

#if compiler(>=6.2)

@objc public class LiquidGlassConatinerViewImpl: UIVisualEffectView {
  private var needsInitialSetup: Bool = true

  @objc public var spacing: CGFloat = 0 {
    didSet {
      if spacing != oldValue, effect != nil {
        setupView()
      }
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    guard needsInitialSetup else {
      return
    }

    needsInitialSetup = false
    setupView()
  }

  private func setupView() {
    guard #available(iOS 26.0, tvOS 26.0, *) else {
      return
    }

    guard NSClassFromString("UIGlassContainerEffect") != nil else {
      return
    }

    let effect = UIGlassContainerEffect()
    effect.spacing = spacing

    UIView.performWithoutAnimation {
      self.effect = effect
    }
  }
}

#else

@objc public class LiquidGlassConatinerViewImpl: UIView {}

#endif
