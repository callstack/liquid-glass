import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else {
      return
    }

    guard
      let appDelegate = UIApplication.shared.delegate as? AppDelegate,
      let reactNativeFactory = appDelegate.reactNativeFactory
    else {
      return
    }

    let window = UIWindow(windowScene: windowScene)
    self.window = window

    reactNativeFactory.startReactNative(
      withModuleName: "LiquidGlassExample",
      in: window,
      launchOptions: nil
    )

    window.makeKeyAndVisible()
  }
}
