package com.rarnu.yugioh.card

import android.Manifest
import android.actionsheet.demo.com.khoiron.actionsheetiosforandroid.ActionSheet
import android.actionsheet.demo.com.khoiron.actionsheetiosforandroid.Interface.ActionSheetCallBack
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.support.design.internal.FlowLayout
import android.view.*
import android.widget.*
import com.luck.picture.lib.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.rarnu.android.*
import com.rarnu.yugioh.HotCard
import com.rarnu.yugioh.HotPack
import com.rarnu.yugioh.YGOData
import com.rarnu.yugioh.YGORequest
import com.rarnu.yugioh.card.adapter.SimpleCardAdapter
import com.rarnu.yugioh.card.adapter.SimplePackAdapter
import com.rarnu.yugioh.card.adapter.SimpleSearchAdapter
import kotlinx.android.synthetic.main.activity_main.*
import java.io.File
import java.net.URL
import kotlin.concurrent.thread


class MainActivity : Activity(), View.OnClickListener, AdapterView.OnItemClickListener {

    private val MENUID_LIMIT = 0
    private val MENUID_PACK = 1
    private val MENUID_DECK = 2

    private val listSearch = mutableListOf<String>()
    private lateinit var adapterSearch: SimpleSearchAdapter
    private val listCard = mutableListOf<HotCard>()
    private lateinit var adapterCard: SimpleCardAdapter
    private val listPack = mutableListOf<HotPack>()
    private lateinit var adapterPack: SimplePackAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        initUI()
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        btnSearch.setOnClickListener(this)
        btnAdvSearch.setOnClickListener(this)
        btnImageSearch.setOnClickListener(this)
        if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), 0)
        }
        adapterSearch = SimpleSearchAdapter(this, listSearch)
        gvSearch.adapter = adapterSearch
        adapterCard = SimpleCardAdapter(this, listCard)
        lvHotCard.adapter = adapterCard
        adapterPack = SimplePackAdapter(this, listPack)
        lvHotPack.adapter = adapterPack

        gvSearch.onItemClickListener = this
        lvHotCard.onItemClickListener = this
        lvHotPack.onItemClickListener = this
        tvChangeHotCard.setOnClickListener { loadHotest() }

        btnHelp.setOnClickListener(this)
        loadHotest()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?) {
        if (requestCode == 0) {
            if (grantResults != null) {
                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                    finish()
                }
            }
        }
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.btnSearch -> {
                val key = edtSearch.text.toString()
                if (key == "") {
                    toast(resStr(R.string.toast_empty_search_key))
                    return
                }
                startActivity(Intent(this, CardListActivity::class.java).apply { putExtra("key", key) })
            }
            R.id.btnAdvSearch -> startActivity(Intent(this, SearchActivity::class.java))
            R.id.btnImageSearch -> {
                ActionSheet(this, mutableListOf("拍照", "从相册选取"))
                        .setTitle("选择卡图")
                        .setCancelTitle("取消")
                        .setColorTitleCancel(Color.RED)
                        .setColorTitle(Color.LTGRAY)
                        .setColorData(Color.DKGRAY)
                        .setColorSelected(Color.DKGRAY)
                        .create(object : ActionSheetCallBack {
                            override fun data(data: String, position: Int) {
                                when (position) {
                                    0 -> takePhoto()
                                    1 -> choosePhotoLibrary()
                                }
                            }
                        })
            }
            R.id.btnHelp -> startActivity(Intent(this, HelpActivity::class.java))
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menu.add(0, MENUID_LIMIT, 0, R.string.card_limit).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        menu.add(0, MENUID_PACK, 1, R.string.card_pack).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        menu.add(0, MENUID_DECK, 2, R.string.card_deck).apply { setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS) }
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            MENUID_LIMIT -> startActivity(Intent(this, LimitActivity::class.java))
            MENUID_PACK -> startActivity(Intent(this, PackActivity::class.java))
            MENUID_DECK -> startActivity(Intent(this, DeckListActivity::class.java))
        }
        return true
    }

    private fun loadHotest() = thread {
        val ret = YGOData.hotest()
        listSearch.clear()
        listSearch.addAll(ret.search)
        listCard.clear()
        listCard.addAll(ret.card)
        listPack.clear()
        listPack.addAll(ret.pack)
        runOnMainThread {
            adapterSearch.setNewList(listSearch)
            resetGridHeight()
            adapterCard.setNewList(listCard)
            resetListHeight(lvHotCard, listCard.size)
            adapterPack.setNewList(listPack)
            resetListHeight(lvHotPack, listPack.size)
        }
    }


    private fun resetGridHeight() {
        var line = listSearch.size / 5
        if (listSearch.size % 5 != 0) {
            line++
        }
        val lay = gvSearch.layoutParams
        lay.height = (line * 41).dip2px()
        gvSearch.layoutParams = lay
    }

    private fun resetListHeight(lv: ListView, lines: Int) {
        lv.layoutParams = lv.layoutParams.apply { height = (lines * 41).dip2px() }
    }

    override fun onItemClick(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
        when (parent) {
            gvSearch -> startActivity(Intent(this, CardListActivity::class.java).apply { putExtra("key", listSearch[position]) })
            lvHotCard -> startActivity(Intent(this, CardDetailActivity::class.java).apply {
                putExtra("name", listCard[position].name)
                putExtra("hashid", listCard[position].hashid)
            })
            lvHotPack -> startActivity(Intent(this, PackDetailActivity::class.java).apply {
                putExtra("url", listPack[position].packid)
                putExtra("name", listPack[position].name)
            })
        }
    }

    private fun takePhoto() {
        PictureSelector.create(this)
                .openCamera(PictureMimeType.ofImage())
                .previewImage(false)
                .forResult(PictureConfig.CHOOSE_REQUEST)
    }

    private fun choosePhotoLibrary() {
        PictureSelector.create(this)
                .openGallery(PictureMimeType.ofImage())
                .selectionMode(PictureConfig.SINGLE)
                .previewImage(false)
                .isCamera(false)
                .forResult(PictureConfig.CHOOSE_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (resultCode == RESULT_OK) {
            when (requestCode) {
                PictureConfig.CHOOSE_REQUEST -> {
                    val path = PictureSelector.obtainMultipleResult(data).firstOrNull()?.path
                    if (path != null && path != "") {
                        toast(getString(R.string.toast_uploading))
                        imageSearch(path)
                    }
                }
            }
        }
    }

    private fun findOneCard(imgid: String) = thread {
        val list = YGOData.findCardByImageId(imgid)
        runOnMainThread {
            if (list.isEmpty()) {
                toast(getString(R.string.toast_no_matching_card))
            } else {
                startActivity(Intent(this, CardDetailActivity::class.java).apply {
                    putExtra("hashid", list[0])
                    putExtra("name", list[1])
                })
            }
        }
    }

    private fun imageSearch(file: String) = thread {
        val list = YGOData.imageSearch(File(file))
        runOnMainThread {
            when {
                list.isEmpty() -> toast(getString(R.string.toast_no_matching_card))
                list.size == 1 -> findOneCard(list[0])
                else -> showPopupCard(list)
            }
        }
    }

    private fun showPopupCard(imgids: List<String>) {
        val w = ((UI.width * 0.8 - 32.dip2px()) / 5).toInt()
        val h = (w * 23 / 16)
        val lines = imgids.size / 5 + (if (imgids.size % 5 != 0) 1 else 0)
        val sw = (UI.width * 0.8).toInt()
        val sh = lines * h + 96.dip2px()
        val pop = PopupCardView(this).apply {
            layoutParams = RelativeLayout.LayoutParams(sw, sh).apply {
                addRule(RelativeLayout.CENTER_IN_PARENT, RelativeLayout.TRUE)
            }
            loadImages(imgids)
        }
        layRoot.addView(pop)
    }

    @SuppressLint("RestrictedApi")
    inner class PopupCardView(context: Context?) : RelativeLayout(context) {

        private val layCard: CardFlowLayout

        init {
            setBackgroundResource(R.drawable.view_round)
            addView(TextView(context).apply {
                text = "找到多张卡片"
                setTextColor(Color.WHITE)
                layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, 40.dip2px()).apply {
                    topMargin = 4.dip2px()
                    leftMargin = 8.dip2px()
                }
                textSize = 18f
                gravity = Gravity.CENTER_VERTICAL
            })

            addView(Button(context).apply {
                background = null
                setTextColor(Color.WHITE)
                text = "Close"
                layoutParams = LayoutParams(65.dip2px(), 40.dip2px()).apply {
                    addRule(ALIGN_PARENT_BOTTOM, TRUE)
                    addRule(ALIGN_PARENT_RIGHT, TRUE)
                    bottomMargin = 8.dip2px()
                    rightMargin = 8.dip2px()
                }
                setOnClickListener {
                    (this@PopupCardView.parent as RelativeLayout).removeView(this@PopupCardView)
                }
            })

            layCard = CardFlowLayout(context).apply {
                layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT).apply {
                    topMargin = 48.dip2px()
                    leftMargin = 8.dip2px()
                }
            }
            addView(layCard)
        }

        fun loadImages(imgids: List<String>) {
            val w = ((UI.width * 0.8 - 32.dip2px()) / 5).toInt()
            val h = 23 * w / 16
            imgids.forEach { p ->
                layCard.addView(ImageView(context).apply {
                    layoutParams = ViewGroup.LayoutParams(w, h)
                    scaleType = ImageView.ScaleType.FIT_CENTER
                    isClickable = true
                    isFocusable = true
                    thread {
                        val img = BitmapFactory.decodeStream(URL(YGORequest.RES_URL.format(p.toInt())).openStream())
                        runOnMainThread {
                            setImageBitmap(img)
                        }
                    }
                    setOnClickListener {
                        findOneCard(p)
                    }
                })
            }
        }
    }

    @SuppressLint("RestrictedApi")
    inner class CardFlowLayout(context: Context?) : FlowLayout(context) {
        init {
            itemSpacing = 4.dip2px()
            lineSpacing = 4.dip2px()
        }
    }

}

