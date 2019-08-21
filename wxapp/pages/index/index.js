//index.js
const app = getApp()

Page({
  data: {
    keyword: ''
  },
  onLoad: () => {
    // TODO: load hotest
    console.log(app.globalData.baseUrl)
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
    console.log('goto deck')
    wx.navigateTo({
      url: '../decklist/decklist',
    })
  }
})
