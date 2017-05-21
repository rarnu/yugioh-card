package com.yugioh.android.base

import android.graphics.Canvas

/**
 * Created by rarnu on 3/24/16.
 */
interface CanvasTransformer {

    fun transformCanvas(canvas: Canvas?, percentOpen: Float)
}