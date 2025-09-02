#import "LiquidGlassContainerView.h"

#import <react/renderer/components/LiquidGlassViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/LiquidGlassViewSpec/EventEmitters.h>
#import <react/renderer/components/LiquidGlassViewSpec/Props.h>
#import <react/renderer/components/LiquidGlassViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

#import "LiquidGlass-Swift.h"

using namespace facebook::react;

@interface LiquidGlassContainerView () <RCTLiquidGlassContainerViewViewProtocol>

@end

@implementation LiquidGlassContainerView {
  LiquidGlassConatinerViewImpl * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<LiquidGlassContainerViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const LiquidGlassContainerViewProps>();
    _props = defaultProps;
    
    _view = [[LiquidGlassConatinerViewImpl alloc] init];
    
    self.contentView = _view;
  }
  
  return self;
}

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000 /* __IPHONE_26_0 */

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<LiquidGlassContainerViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<LiquidGlassContainerViewProps const>(props);
  
  if (oldViewProps.spacing != newViewProps.spacing) {
    [_view setSpacing:newViewProps.spacing];
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [_view.contentView insertSubview:childComponentView atIndex:index];
}

- (void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index {
  [childComponentView removeFromSuperview];
}
#endif

@end

