#import "LiquidGlassModule.h"

@implementation LiquidGlassModule {
  facebook::react::ModuleConstants<JS::NativeLiquidGlassModule::Constants> _constants;
}

- (void)initialize
{
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000) || \
    (defined(__TV_OS_VERSION_MAX_ALLOWED) && __TV_OS_VERSION_MAX_ALLOWED >= 260000)
  if (@available(iOS 26.0, tvOS 26.0, *)) {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    BOOL requiresDesignCompatibility = [infoPlist[@"UIDesignRequiresCompatibility"] boolValue];

    if (@available(iOS 27.0, tvOS 27.0, *)) {
      requiresDesignCompatibility =
          // iOS ignores UIDesignRequiresCompatibility for apps built with the 27 SDK.
          requiresDesignCompatibility && [infoPlist[@"DTPlatformVersion"] integerValue] < 27;
    }

    BOOL isGlassEffectAPIAvailable = NO;

    Class glassEffectClass = NSClassFromString(@"UIGlassEffect");

    if (glassEffectClass != nil) {
      isGlassEffectAPIAvailable = [glassEffectClass respondsToSelector:NSSelectorFromString(@"effectWithStyle:")];
    }

    _constants = facebook::react::typedConstants<JS::NativeLiquidGlassModule::Constants>({
      .isLiquidGlassSupported = !requiresDesignCompatibility && isGlassEffectAPIAvailable
    });

    return;
  }
#endif

  _constants = facebook::react::typedConstants<JS::NativeLiquidGlassModule::Constants>({
    .isLiquidGlassSupported = NO
  });
}

- (facebook::react::ModuleConstants<JS::NativeLiquidGlassModule::Constants>)constantsToExport
{
  return (facebook::react::ModuleConstants<JS::NativeLiquidGlassModule::Constants>)[self getConstants];
}

+ (NSString *)moduleName {
  return @"NativeLiquidGlassModule";
}


- (facebook::react::ModuleConstants<JS::NativeLiquidGlassModule::Constants>)getConstants
{
  return _constants;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeLiquidGlassModuleSpecJSI>(params);
}

@end
