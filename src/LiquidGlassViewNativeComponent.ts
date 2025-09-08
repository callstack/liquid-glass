import {
  codegenNativeComponent,
  type ViewProps,
  type ColorValue,
  type CodegenTypes,
} from 'react-native';

export interface NativeProps extends ViewProps {
  /**
   * Make the view respond to user interactions.
   * Interactive view grow on touch and show a shimmer effect.
   *
   * Defaults to `false`.
   */
  interactive?: boolean;
  /**
   * The variant of the liquid glass material.
   *
   * Defaults to 'regular'.
   */
  effect?: CodegenTypes.WithDefault<'clear' | 'regular', 'regular'>;
  /**
   * The color of the glass effect.
   *
   * Defaults to `transparent`.
   */
  tintColor?: ColorValue;
  /**
   * The color scheme of the glass effect.
   * The effect appears dark or light based on the color scheme.
   *
   * Defaults to 'system'.
   */
  colorScheme?: CodegenTypes.WithDefault<'light' | 'dark' | 'system', 'system'>;
  /**
   * Automatically adjusts the color of child content for legibility
   * over the glass material using a vibrancy effect on iOS.
   *
   * Defaults to `true` on iOS. No-op on other platforms.
   */
  autoContentColor?: CodegenTypes.WithDefault<boolean, true>;
}

export default codegenNativeComponent<NativeProps>('LiquidGlassView');
