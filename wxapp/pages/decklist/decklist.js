// pages/decklist/decklist.js
const app = getApp()

Page({

  data: {
    categoryList: [],
    themeList: []
  },

  getDeckData: function() {
    var that = this
    var cmdCategory = `${app.globalData.baseUrl}/deckcategory`
    var cmdTheme = `${app.globalData.baseUrl}/decktheme`
    wx.request({
      url: cmdCategory,
      success: res => {
        console.log(res)
        that.setData({
          categoryList: res.data
        })
      }
    })
    wx.request({
      url: cmdTheme,
      success: res => {
        that.setData({
          themeList: res.data
        })
      }
    })
  },
  onLoad: function (options) {
    this.getDeckData()
  },
  bindCategoryTap: function(e) {
    var guid = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../deckincategory/deckincategory?guid=${guid}`
    })
  },
  bindThemeTap: function(e) {
    var code = e.currentTarget.dataset.id
    console.log(code)
    // TODO: to deck view
  }

})