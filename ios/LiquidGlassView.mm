#import "LiquidGlassView.h"

#import <react/renderer/components/LiquidGlassViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/LiquidGlassViewSpec/EventEmitters.h>
#import <react/renderer/components/LiquidGlassViewSpec/Props.h>
#import <react/renderer/components/LiquidGlassViewSpec/RCTComponentViewHelpers.h>
#import "RCTImagePrimitivesConversions.h"

#import "RCTFabricComponentsPlugins.h"

#import "LiquidGlass-Swift.h"
#import "RCTConversions.h"

using namespace facebook::react;

@interface LiquidGlassView () <RCTLiquidGlassViewViewProtocol>

@end

@implementation LiquidGlassView {
  LiquidGlassViewImpl * _view;
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
- (void)layoutSubviews {
  [super layoutSubviews];
  _view.layer.cornerRadius = self.layer.cornerRadius;
  _view.layer.cornerCurve = self.layer.cornerCurve;
}


- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<LiquidGlassViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<LiquidGlassViewProps const>(props);
  
  
  if (oldViewProps.tintColor != newViewProps.tintColor) {
    _view.effectTintColor = RCTUIColorFromSharedColor(newViewProps.tintColor);
  }
  
  if (oldViewProps.effect != newViewProps.effect) {
    switch (newViewProps.effect) {
      case LiquidGlassViewEffect::Regular:
        [_view setStyle:UIGlassEffectStyleRegular];
        break;
        
      case LiquidGlassViewEffect::Clear:
        [_view setStyle:UIGlassEffectStyleClear];
        break;
    }
  }
  
  if (oldViewProps.interactive != newViewProps.interactive) {
    _view.interactive = newViewProps.interactive;
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
  }
  
  if (oldViewProps.borderRadii != newViewProps.borderRadii) {
    _view.layer.cornerRadius = self.layer.cornerRadius;
    _view.layer.cornerCurve = self.layer.cornerCurve;
  }
  
  
  [super updateProps:props oldProps:oldProps];
}

- (void)finalizeUpdates:(RNComponentViewUpdateMask)updateMask {
  [super finalizeUpdates:updateMask];
  
  if (updateMask == RNComponentViewUpdateMaskProps) {
    [_view setupView];
  }
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [_view.contentView insertSubview:childComponentView atIndex:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [childComponentView removeFromSuperview];
}

@end
