// pages/packdetail/packdetail.js
const app = getApp()

Page({

  data: {
    url: '',
    listData: [],
  },

  getPackDetail: function() {
    var cmd = `${app.globalData.baseUrl}/packdetail?url=${this.data.url}`
    var that = this
    wx.request({
      url: cmd,
      success: res => {
        that.setData({
          listData: res.data.cards
        })
      }
    })
  },

  onLoad: function (options) {
    this.setData({
      url: options.url
    })
    this.getPackDetail()
  },
  imgError: function (e) {
    var index = e.currentTarget.dataset.index
    var img = 'listData[' + index + '].img_url'
    this.setData({
      [img]: '../../images/img0.png'
    })
  },
  bindCardItemTap: function (e) {
    var hash = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../carddetail/carddetail?hash=${hash}`
    })
  }
})