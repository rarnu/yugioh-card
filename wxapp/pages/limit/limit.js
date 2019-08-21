// pages/limit/limit.js
const app = getApp()

Page({

  data: {
    limidata: []
  },

  getlimitData: function() {
    var that = this
    wx.request({
      url: `${app.globalData.baseUrl}/limit`,
      success: res => {
        if (res.data.result == 0) {
          that.setData({
            limidata: res.data.data
          })
        }
        console.log(res)
      }
    })
  },
  onLoad: function (options) {
    this.getlimitData()
  },
  bindCardItemTap: function(e) {
    var hash = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../carddetail/carddetail?hash=${hash}`
    })
  }

})