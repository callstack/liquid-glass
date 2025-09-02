import {
  codegenNativeComponent,
  type ViewProps,
  type CodegenTypes,
} from 'react-native';

interface NativeProps extends ViewProps {
  spacing?: CodegenTypes.Float;
}

export default codegenNativeComponent<NativeProps>('LiquidGlassContainerView');
