import { codegenNativeComponent, type ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  color?: string;
}

export default codegenNativeComponent<NativeProps>('LiquidGlassView');
