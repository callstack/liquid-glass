/* eslint-disable react-native/no-inline-styles */
import {
  ScrollView,
  StyleSheet,
  Text,
  ImageBackground,
  useWindowDimensions,
  Animated,
  View,
  Pressable,
} from 'react-native';
import {
  LiquidGlassView,
  isLiquidGlassSupported,
} from '@callstack/liquid-glass';
import { useEffect, useState } from 'react';

const AnimatedLiquidGlassView =
  Animated.createAnimatedComponent(LiquidGlassView);

export default function App() {
  const { height } = useWindowDimensions();

  return (
    <>
      <ImageBackground
        style={{
          alignItems: 'center',
          justifyContent: 'center',
          height,
          width: '100%',
          position: 'absolute',
        }}
        source={{
          uri: 'https://images.unsplash.com/photo-1755289445810-bfe6381d51c4?q=80&w=500&auto=format&fit=crop',
        }}
      />
      <ScrollView style={styles.container}>
        <WeatherWidget />
        <Button />
        <MergingCircles />
      </ScrollView>
    </>
  );
}

function Button() {
  return (
    <LiquidGlassView style={styles.button} interactive colorScheme="dark">
      <Text
        style={{
          padding: 20,
          color: 'white',
          fontSize: 24,
          fontWeight: 'bold',
        }}
      >
        Click me
      </Text>
    </LiquidGlassView>
  );
}

function WeatherWidget() {
  return (
    <View style={{ flexDirection: 'row', gap: 10, marginBottom: 20 }}>
      <LiquidGlassView
        style={[
          styles.weather,
          !isLiquidGlassSupported && { backgroundColor: 'rgba(255,165,0,0.3)' },
        ]}
        interactive={true}
        effect={'clear'}
        tintColor={'orange'}
      >
        <View style={{ padding: 20 }}>
          <Text style={styles.small}>Wrocław</Text>
          <Text style={styles.temperature}>25°</Text>
          <Text style={styles.icon}>☀</Text>
          <Text style={styles.small}>Sunny</Text>
        </View>
      </LiquidGlassView>

      <LiquidGlassView style={styles.weather} effect={'clear'} interactive>
        <View style={{ padding: 20 }}>
          <Text style={styles.small}>Miami</Text>
          <Text style={styles.temperature}>35°</Text>
          <Text style={styles.icon}>☀</Text>
          <Text style={styles.small}>Sunny</Text>
        </View>
      </LiquidGlassView>
    </View>
  );
}

function MergingCircles() {
  const [translateX] = useState(() => new Animated.Value(0));
  const [merged, setMerged] = useState(false);

  useEffect(() => {
    Animated.timing(translateX, {
      toValue: merged ? -120 : 30,
      duration: 2000,
      useNativeDriver: false,
    }).start();
  }, [translateX, merged]);

  return (
    <Pressable
      style={styles.circles}
      onPress={() => setMerged((prev) => !prev)}
    >
      <AnimatedLiquidGlassView style={styles.circle} />
      <AnimatedLiquidGlassView
        style={[styles.circle, { transform: [{ translateX }] }]}
      />
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 60,
    paddingHorizontal: 20,
  },

  box: {
    width: 200,
    height: 200,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 20,
  },
  sliderContainer: {
    position: 'absolute',
    bottom: 50,
    left: 50,
    right: 50,
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
    borderRadius: 15,
    padding: 20,
  },
  slider: {
    width: '100%',
    height: 40,
  },
  sliderLabel: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  sliderValue: {
    color: 'white',
    fontSize: 14,
    marginTop: 10,
  },
  button: {
    alignItems: 'center',
    borderRadius: 20,
    marginBottom: 20,
  },
  weather: {
    borderRadius: 20,
    borderCurve: 'continuous',
    minWidth: 170,
  },
  small: {
    color: 'white',
    fontSize: 24,
  },
  icon: {
    color: 'yellow',
    fontSize: 30,
  },
  temperature: {
    color: 'white',
    fontSize: 60,
  },
  circle: {
    height: 120,
    width: 120,
    borderRadius: 20,
    color: 'white',
  },
  circles: {
    flexDirection: 'row',
    gap: 10,
  },
});
