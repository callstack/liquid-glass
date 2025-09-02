import UIKit

#if compiler(>=6.2)

@objc public class LiquidGlassConatinerViewImpl: UIVisualEffectView {
  public override func layoutSubviews() {
    if #available(iOS 26.0, *) {
      setupView()
    }
  }
  
  @available(iOS 26.0, *)
  private func setupView() {
    self.effect = UIGlassContainerEffect()
  }
  
  @objc public func setSpacing(_ spacing: CGFloat) {
    if #available(iOS 26.0, *) {
      (self.effect as? UIGlassContainerEffect)?.spacing = spacing
    }
  }
}

#else

@objc public class LiquidGlassConatinerViewImpl: UIView {}

#endif
