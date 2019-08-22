//index.js
const app = getApp()

Page({
  data: {
    // private
    change: '<换一批>',

    keyword: '',
    hotwords: [],
    hotcards: [],
    hotpacks: []
  },
  getHotestData: function() {
    var that = this
    var cmd = `${app.globalData.baseUrl}/hotest`
    wx.request({
      url: cmd,
      success: res => {
        that.setData({
          hotwords: res.data.search,
          hotcards: res.data.card,
          hotpacks: res.data.pack
        })
      }
    })
  },
  onLoad: function() {
    this.getHotestData()
  },
  bindKeywordInput: function(e) {
      this.data.keyword = e.detail.value
  },
  btnSearchTap: function(e) {
    this.jumpToCardList()
  },
  bindSearchConfirm: function (e) {
      this.jumpToCardList()
  },
  jumpToCardList: function() {
    if (this.data.keyword.length == 0) {
      wx.showToast({
        title: "关键字不能为空",
        image: "../../images/error.png"
      })
      return;
    } else {
      wx.navigateTo({
        url: `../cardlist/cardlist?keyword=${this.data.keyword}`
      })
    }
  },
  bindAdvTap: function(e) {
    wx.navigateTo({
      url: '../advsearch/advsearch',
    })
  },
  bindLimitTap: function(e) {
    wx.navigateTo({
      url: '../limit/limit',
    })
  },
  bindPackTap: function(e) {
    wx.navigateTo({
      url: '../pack/pack',
    })
  },
  bindDeckTap: function(e) {
    wx.navigateTo({
      url: '../decklist/decklist',
    })
  },
  bindHotwordTap: function(e) {
    var key = e.currentTarget.dataset.id
    this.data.keyword = key
    this.jumpToCardList()
  },
  bindHotcardTap: function(e) {
    var hash = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../carddetail/carddetail?hash=${hash}`
    })
  },
  bindHotdeckTap: function(e) {
    var url = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../packdetail/packdetail?url=${url}`,
    })
  },
  bindAboutTap: function(e) {
    wx.navigateTo({
      url: '../about/about',
    })
  },
  bindChangeTap: function(e) {
    this.getHotestData()
  }
})
