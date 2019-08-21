// pages/deckincategory/deckincategory.js
const app = getApp()

Page({

  data: {
    guid: '',
    listdata: []
  },

  getDeckInCategory: function() {
    var that = this
    var cmd = `${app.globalData.baseUrl}/deckincategory?hash=${this.data.guid}`
    wx.request({
      url: cmd,
      success: res => {
        that.setData({
          listdata: res.data
        })
      }
    })
  },

  onLoad: function (options) {
    this.setData({
      guid: options.guid
    })
    this.getDeckInCategory()
  },
  bindDeckTap: function(e) {
    var code = e.currentTarget.dataset.id
    console.log(code)
    // TODO: to deck view
  }
})