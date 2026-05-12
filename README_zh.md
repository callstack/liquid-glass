<div align="center">
  <h1>React Native Liquid Glass 🔍</h1>

[![mit licence](https://img.shields.io/dub/l/vibe-d.svg?style=for-the-badge)](https://github.com/callstack/liquid-glass/blob/main/LICENSE)
[![npm version](https://img.shields.io/npm/v/@callstack/liquid-glass?style=for-the-badge)](https://www.npmjs.org/package/@callstack/liquid-glass)
[![npm downloads](https://img.shields.io/npm/dt/@callstack/liquid-glass.svg?style=for-the-badge)](https://www.npmjs.org/package/@callstack/liquid-glass)
[![npm downloads](https://img.shields.io/npm/dm/@callstack/liquid-glass.svg?style=for-the-badge)](https://www.npmjs.org/package/@callstack/liquid-glass)

`@callstack/liquid-glass` 为 iOS 上的 React Native 应用带来 iOS 26 液态玻璃效果。

https://github.com/user-attachments/assets/44c18136-8760-49f2-ae16-62557c3ae2e1

</div>

## 功能特性

- ✨ iOS 26 液态玻璃视觉效果
- 🎨 可自定义着色颜色
- 🔧 两种效果模式：`clear`（透明）和 `regular`（标准）

## 文档

### 安装

```bash
npm install @callstack/liquid-glass
# 或者
yarn add @callstack/liquid-glass
```

> [!WARNING]
> 请确保使用 Xcode >= 26 编译你的应用。需要 React Native 0.80+ 版本。

> [!WARNING]
> 此库不支持 [Expo Go](https://expo.dev/go)。



### 使用方法

```tsx
import {
  LiquidGlassView,
  LiquidGlassContainerView,
  isLiquidGlassSupported,
} from '@callstack/liquid-glass';

function MyComponent() {
  return (
    <LiquidGlassView
      style={[
        { width: 200, height: 100, borderRadius: 20 },
        !isLiquidGlassSupported && { backgroundColor: 'rgba(255,255,255,0.5)' },
      ]}
      interactive
      effect="clear"
    >
      <Text>Hello World</Text>
    </LiquidGlassView>
  );
}

// 合并多个玻璃元素
function MergingGlassElements() {
  return (
    <LiquidGlassContainerView spacing={20}>
      <LiquidGlassView style={{ width: 100, height: 100, borderRadius: 50 }} />
      <LiquidGlassView style={{ width: 100, height: 100, borderRadius: 50 }} />
    </LiquidGlassContainerView>
  );
}
```

要实现基于玻璃视图后方背景自动适配文字颜色，可使用 `react-native` 中的 `PlatformColor`：

> [!NOTE]
> 玻璃效果自动适配文字颜色似乎存在尺寸限制。如果玻璃视图高度 >= 65，则不会自动适配后方材质。

https://github.com/user-attachments/assets/199bce70-dab4-43bc-9de1-605f561760e5

```tsx
import { PlatformColor } from 'react-native';
import { LiquidGlassView } from '@callstack/liquid-glass';

function MyComponent() {
  return (
    <LiquidGlassView style={{ padding: 20, borderRadius: 20 }}>
      <Text style={{ color: PlatformColor('labelColor') }}>Hello World</Text>
    </LiquidGlassView>
  );
}
```

> [!NOTE]
> 在不支持的 iOS 版本上（低于 iOS 26），将渲染普通的 `View`，不带任何效果。

### API

#### `isLiquidGlassSupported`

一个布尔常量，指示当前设备是否支持液态玻璃效果。

```tsx
import { isLiquidGlassSupported } from '@callstack/liquid-glass';

if (isLiquidGlassSupported) {
  // 设备支持液态玻璃效果
} else {
  // 提供备用 UI
}
```

### LiquidGlassView - 属性

| 属性          | 类型                            | 默认值      | 描述                                                                                                                         |
| ------------- | ------------------------------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `interactive` | `boolean`                       | `false`     | 启用按下视图时的触摸交互效果                                                                                                 |
| `effect`      | `'clear' \| 'regular' \| 'none'` | `'regular'` | 视觉效果模式：<br/>• `clear` - 更透明的玻璃效果<br/>• `regular` - 标准玻璃模糊效果<br/>• `none` - 无玻璃效果（透明视图）<br/>**注意：** 更改此属性会触 glass 效果的显现/消失动画 |
| `tintColor`   | `ColorValue`                    | `undefined` | 应用于玻璃效果的叠加着色颜色。接受任何 React Native 颜色格式（hex、rgba、命名颜色）                                          |
| `colorScheme` | `'light' \| 'dark' \| 'system'` | `'system'`  | 颜色方案适配：<br/>• `light` - 浅色外观<br/>• `dark` - 深色外观<br/>• `system` - 跟随系统外观                                |

### LiquidGlassContainerView - 属性

| 属性      | 类型     | 默认值 | 描述                                                                                               |
| --------- | -------- | ------ | -------------------------------------------------------------------------------------------------- |
| `spacing` | `number` | `0`    | 子元素之间开始将其玻璃效果合并为组合效果的距离阈值                                                 |

## 已知问题

- `interactive` 属性不支持动态更改，仅在挂载时设置。

## 在 Callstack 用 ❤️ 制作

`liquid-glass` 是一个开源项目，将永远保持免费使用。如果你觉得它很酷，请给我们一个星标 🌟。

[Callstack][callstack-readme-with-love] 是一群 React 和 React Native 极客组成的团队，如果你需要任何帮助或只想打个招呼，请通过 [hello@callstack.com](mailto:hello@callstack.com) 联系我们！

喜欢这个项目吗？ ⚛️ [加入团队](https://callstack.com/careers/?utm_campaign=Senior_RN&utm_source=github&utm_medium=readme)，一起为客户创造精彩作品并推动 React Native 开源发展！🔥

[callstack-readme-with-love]: https://callstack.com/?utm_source=github.com&utm_medium=referral&utm_campaign=liquid-glass&utm_term=readme-with-love
[version-badge]: https://img.shields.io/npm/v/@callstack/liquid-glass?style=for-the-badge
[version]: https://github.com/callstack/liquid-glass/blob/main/LICENSE
[prs-welcome-badge]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge
[prs-welcome]: ./CONTRIBUTING.md
