package com.yugioh.android.base

import android.content.Context

abstract class BaseAdapter<T>(context: Context, list: MutableList<T>?) : InnerAdapter<T>(context, list)