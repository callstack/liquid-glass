package com.callstack.liquidglass

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.LiquidGlassViewManagerInterface
import com.facebook.react.viewmanagers.LiquidGlassViewManagerDelegate

@ReactModule(name = LiquidGlassViewManager.NAME)
class LiquidGlassViewManager : SimpleViewManager<LiquidGlassView>(),
  LiquidGlassViewManagerInterface<LiquidGlassView> {
  private val mDelegate: ViewManagerDelegate<LiquidGlassView>

  init {
    mDelegate = LiquidGlassViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<LiquidGlassView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): LiquidGlassView {
    return LiquidGlassView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: LiquidGlassView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "LiquidGlassView"
  }
}
