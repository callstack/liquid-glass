import { TurboModuleRegistry, type TurboModule } from 'react-native';

type LiquidGlassModuleConstants = {
  isLiquidGlassSupported: boolean;
};

export interface Spec extends TurboModule {
  getConstants(): LiquidGlassModuleConstants;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'NativeLiquidGlassModule'
);
