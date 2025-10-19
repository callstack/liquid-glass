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
  UIVisualEffectView *_vibrancyView;
  BOOL _autoContentColor;
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
    _autoContentColor = YES;
    
    // Create a vibrancy view to automatically adapt child content color for legibility
    // over glass material. Children will be mounted into this container when enabled.
    _vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectWithStyle:UIVibrancyEffectStyleLabel]];
    _vibrancyView.frame = _view.bounds;
    _vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view.contentView addSubview:_vibrancyView];
    
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

  // Toggle automatic content color (vibrancy) for mounted children
  if (oldViewProps.autoContentColor != newViewProps.autoContentColor) {
    BOOL newValue = newViewProps.autoContentColor;
    if (_autoContentColor != newValue) {
      _autoContentColor = newValue;
      if (_autoContentColor) {
        if (_vibrancyView.superview == nil) {
          _vibrancyView.frame = _view.bounds;
          _vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
          [_view.contentView addSubview:_vibrancyView];
        }
        for (UIView *subview in [[_view.contentView.subviews copy] objectEnumerator]) {
          if (subview == _vibrancyView) { continue; }
          [subview removeFromSuperview];
          [_vibrancyView.contentView addSubview:subview];
        }
      } else {
        for (UIView *subview in [[_vibrancyView.contentView.subviews copy] objectEnumerator]) {
          [subview removeFromSuperview];
          [_view.contentView addSubview:subview];
        }
        [_vibrancyView removeFromSuperview];
      }
    }
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
  
  if (oldViewProps.borderRadii != newViewProps.borderRadii) {
    _view.layer.cornerRadius = self.layer.cornerRadius;
    _view.layer.cornerCurve = self.layer.cornerCurve;
  }
  
  if (needsSetup) {
    [_view setupView];
  }
  
  [super updateProps:props oldProps:oldProps];
}

- (void)updateLayoutMetrics:(const LayoutMetrics &)layoutMetrics
           oldLayoutMetrics:(const LayoutMetrics &)oldLayoutMetrics
{
  [super updateLayoutMetrics:layoutMetrics oldLayoutMetrics:oldLayoutMetrics];

  // Fixes an issue with padding set only on the external view (the container holding content view).
  [_view setFrame:RCTCGRectFromRect(layoutMetrics.getPaddingFrame())];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  UIView *container = _autoContentColor ? _vibrancyView.contentView : _view.contentView;
  [container insertSubview:childComponentView atIndex:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [childComponentView removeFromSuperview];
}

#endif

@end
