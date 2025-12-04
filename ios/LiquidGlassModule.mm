#import "LiquidGlassModule.h"

@implementation LiquidGlassModule {
  facebook::react::ModuleConstants<JS::NativeLiquidGlassModule::Constants> _constants;
}

- (void)initialize
{
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 260000 /* __IPHONE_26_0 */
  if (@available(iOS 26.0, *)) {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    BOOL requiresDesignCompatibility = [infoPlist[@"UIDesignRequiresCompatibility"] boolValue];
    
    _constants = facebook::react::typedConstants<JS::NativeLiquidGlassModule::Constants>({
      .isLiquidGlassSupported = !requiresDesignCompatibility
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
