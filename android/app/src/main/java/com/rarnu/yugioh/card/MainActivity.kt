package com.rarnu.yugioh.card

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.rarnu.yugioh.YGOData
import kotlin.concurrent.thread

class MainActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        thread {
            // val str = YGOData.searchCommon("影依", 1)
            // val str = YGOData.cardDetail("qPs8Xb")
            // val str = YGOData.limit()
            // val str = YGOData.packageList()
            // val str = YGOData.packageDetail("/package/CP18/wwSYE")
            // Log.e("YGO", "$str")
        }

    }
}
