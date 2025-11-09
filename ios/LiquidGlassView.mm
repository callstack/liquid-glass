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


    auto borderRadii = borderMetrics.borderRadii;
    
    CGFloat topLeftRadius = MAX(borderRadii.topLeft.horizontal, borderRadii.topLeft.vertical);
    CGFloat topRightRadius = MAX(borderRadii.topRight.horizontal, borderRadii.topRight.vertical);
    CGFloat bottomLeftRadius = MAX(borderRadii.bottomLeft.horizontal, borderRadii.bottomLeft.vertical);
    CGFloat bottomRightRadius = MAX(borderRadii.bottomRight.horizontal, borderRadii.bottomRight.vertical);

    UICornerRadius *topLeft = [UICornerRadius fixedRadius:topLeftRadius];
    UICornerRadius *topRight = [UICornerRadius fixedRadius:topRightRadius];
    UICornerRadius *bottomLeft = [UICornerRadius fixedRadius:bottomLeftRadius];
    UICornerRadius *bottomRight = [UICornerRadius fixedRadius:bottomRightRadius];

    _view.cornerConfiguration = [UICornerConfiguration configurationWithTopLeftRadius:topLeft topRightRadius:topRight bottomLeftRadius:bottomLeft bottomRightRadius:bottomRight];
  }
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];

  _needsInvalidateLayer = YES;

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
