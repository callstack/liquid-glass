#pragma once

#import <UIKit/UIKit.h>

// This header mirrors the @objc API of ios/LiquidGlassView.swift and ios/LiquidGlassContainerView.swift. If spm-support/SwiftHeaderPin.swift fails to compile, update both files together.
typedef NS_ENUM(NSInteger, LiquidGlassEffect) {
  LiquidGlassEffectRegular = 0,
  LiquidGlassEffectClear = 1,
  LiquidGlassEffectNone = 2,
};

#if __has_attribute(objc_runtime_name)
__attribute__((objc_runtime_name("_TtC11LiquidGlass19LiquidGlassViewImpl")))
#endif
@interface LiquidGlassViewImpl : UIVisualEffectView
@property(nonatomic, strong, nullable) UIColor *effectTintColor;
@property(nonatomic) BOOL interactive;
@property(nonatomic) LiquidGlassEffect style;
@property(nonatomic) BOOL animated;
@property(nonatomic) CGFloat animationDuration;
@property(nonatomic) BOOL hasAnimationDuration;
- (void)setupView;
- (void)resetInteractiveEffect;
@end

#if __has_attribute(objc_runtime_name)
__attribute__((objc_runtime_name("_TtC11LiquidGlass28LiquidGlassConatinerViewImpl")))
#endif
@interface LiquidGlassConatinerViewImpl : UIVisualEffectView
@property(nonatomic) CGFloat spacing;
@end
