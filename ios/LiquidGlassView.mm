#import "LiquidGlassView.h"

#import <react/renderer/components/LiquidGlassViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/LiquidGlassViewSpec/EventEmitters.h>
#import <react/renderer/components/LiquidGlassViewSpec/Props.h>
#import <react/renderer/components/LiquidGlassViewSpec/RCTComponentViewHelpers.h>
#import "RCTImagePrimitivesConversions.h"

#import "RCTFabricComponentsPlugins.h"
#import "RCTConversions.h"

#if __has_include("LiquidGlass/LiquidGlass-Swift.h")
#import "LiquidGlass/LiquidGlass-Swift.h"
#else
#import "LiquidGlass-Swift.h"
#endif

using namespace facebook::react;

@interface LiquidGlassView () <RCTLiquidGlassViewViewProtocol>

@end

@implementation LiquidGlassView {
  LiquidGlassViewImpl * _view;
  BOOL _needsInvalidateLayer;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<LiquidGlassViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const LiquidGlassViewProps>();
    _props = defaultProps;
    
    _view = [[LiquidGlassViewImpl alloc] init];
    
    self.contentView = _view;
  }
  
  return self;
}

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000 /* __IPHONE_26_0 */
- (void)layoutSubviews {
  [super layoutSubviews];
  _view.layer.cornerRadius = self.layer.cornerRadius;
  _view.layer.cornerCurve = self.layer.cornerCurve;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<LiquidGlassViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<LiquidGlassViewProps const>(props);
  BOOL needsSetup = NO;
  
  if (oldViewProps.tintColor != newViewProps.tintColor) {
    _view.effectTintColor = RCTUIColorFromSharedColor(newViewProps.tintColor);
    needsSetup = YES;
  }
  
  if (oldViewProps.effect != newViewProps.effect) {
    switch (newViewProps.effect) {
      case LiquidGlassViewEffect::Regular:
        [_view setStyle:LiquidGlassEffectRegular];
        break;
        
      case LiquidGlassViewEffect::Clear:
        [_view setStyle:LiquidGlassEffectClear];
        break;
        
      case LiquidGlassViewEffect::None:
        [_view setStyle:LiquidGlassEffectNone];
        break;
    }
    
    needsSetup = YES;
  }
  
  if (oldViewProps.interactive != newViewProps.interactive) {
    _view.interactive = newViewProps.interactive;
    needsSetup = YES;
  }
  
  if (oldViewProps.colorScheme != newViewProps.colorScheme) {
    switch (newViewProps.colorScheme) {
      case LiquidGlassViewColorScheme::System:
        _view.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        break;
        
      case LiquidGlassViewColorScheme::Dark:
        _view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        break;
        
      case LiquidGlassViewColorScheme::Light:
        _view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        break;
    }
    needsSetup = YES;
  }
  
  // `border`
  if (oldViewProps.borderStyles != newViewProps.borderStyles || oldViewProps.borderRadii != newViewProps.borderRadii ||
      oldViewProps.borderColors != newViewProps.borderColors) {
    _needsInvalidateLayer = YES;
  }
  
  if (needsSetup) {
    [_view setupView];
  }
  
  [super updateProps:props oldProps:oldProps];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask {
  [super finalizeUpdates:updateMask];
  
  if (!_needsInvalidateLayer) {
    return;
  }
  
  _needsInvalidateLayer = NO;
  
  if (@available(iOS 26.0, *)) {
    const auto borderMetrics = _props->resolveBorderMetrics(_layoutMetrics);
    
    if (!borderMetrics.borderRadii.isUniform()) {
      // TODO: Handle non uniform border radius
      NSLog(@"[@callstack/liquid-glass] Using uneven border radius is not yet supported on glass elements.");
    }
    
    // Use topLeft.horizontal same as React Native RCTViewComponentView implementation: https://github.com/facebook/react-native/blob/b823b26a3765cbf4506df0981e3350e0bae3ad62/packages/react-native/React/Fabric/Mounting/ComponentViews/View/RCTViewComponentView.mm#L988C26-L988C80
    _view.cornerConfiguration = [UICornerConfiguration configurationWithRadius:[UICornerRadius fixedRadius:borderMetrics.borderRadii.topLeft.horizontal]];
  }
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];

  // Fixes an issue with padding set only on the external view (the container holding content view).
  [_view setFrame:RCTCGRectFromRect(layoutMetrics.getPaddingFrame())];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [_view.contentView insertSubview:childComponentView atIndex:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [childComponentView removeFromSuperview];
}

#endif

@end
