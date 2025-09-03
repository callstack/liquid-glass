import {
  codegenNativeComponent,
  type ViewProps,
  type CodegenTypes,
} from 'react-native';

export interface NativeProps extends ViewProps {
  /**
   * The distance between elements at which they begin to merge.
   * Defaults to 0.
   */
  spacing?: CodegenTypes.Float;
}

export default codegenNativeComponent<NativeProps>('LiquidGlassContainerView');
