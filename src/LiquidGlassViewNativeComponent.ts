import {
  codegenNativeComponent,
  type ViewProps,
  type ColorValue,
  type CodegenTypes,
} from 'react-native';

interface NativeProps extends ViewProps {
  interactive?: boolean;
  effect?: CodegenTypes.WithDefault<'clear' | 'regular', 'regular'>;
  tintColor?: ColorValue;
  colorScheme?: CodegenTypes.WithDefault<'light' | 'dark' | 'system', 'system'>;
}

export default codegenNativeComponent<NativeProps>('LiquidGlassView');
