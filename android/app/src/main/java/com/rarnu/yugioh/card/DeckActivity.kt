package com.rarnu.yugioh.card

import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.webkit.WebView
import android.widget.LinearLayout
import android.widget.LinearLayout.LayoutParams
import android.widget.TextView
import com.rarnu.android.BackActivity
import com.rarnu.android.dip2px
import com.rarnu.android.runOnMainThread
import com.rarnu.yugioh.DeckCard
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.YGORequest.DECK_URL
import kotlinx.android.synthetic.main.activity_deckdetail.*
import kotlin.concurrent.thread

class DeckActivity : BackActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_deckdetail)
        val code = intent.getStringExtra("code")

        thread {
            val list = YGOData.deck(code)
            runOnMainThread {
                list.forEach {
                    layDeck.addView(TextView(this).apply {
                        text = it.name
                        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT).apply {
                            topMargin = 4.dip2px()
                            bottomMargin = 4.dip2px()
                        }
                        textSize = 20F
                    })

                    layDeck.addView(LinearLayout(this).apply {
                        orientation = LinearLayout.HORIZONTAL
                        weightSum = 3F
                        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT)
                        addCardContent(it.monster)
                        addCardContent(it.magictrap)
                        addCardContent(it.extra)
                    })

                    layDeck.addView(WebView(this).apply {
                        settings.useWideViewPort = true
                        settings.loadWithOverviewMode = true
                        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT).apply {
                            topMargin = 4.dip2px()
                            bottomMargin = 4.dip2px()
                        }
                        loadUrl("$DECK_URL${it.image}")
                    })

                    layDeck.addView(View(this).apply {
                        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, 1).apply {
                            topMargin = 8.dip2px()
                            bottomMargin = 8.dip2px()
                        }
                        setBackgroundColor(Color.LTGRAY)
                    })

                }

            }
        }
    }

    private fun LinearLayout.addCardContent(list: List<DeckCard>) {
        addView(TextView(this@DeckActivity).apply {
            layoutParams = LayoutParams(0, LayoutParams.WRAP_CONTENT).apply {
                weight = 1F
            }
            gravity = Gravity.TOP or Gravity.START
            text = list.joinToString("\n") { "${it.count} ${it.name}" }
            textSize = 13F
        })
    }

}