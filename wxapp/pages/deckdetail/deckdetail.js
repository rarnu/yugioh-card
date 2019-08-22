// pages/deckdetail/deckdetail.js
const app = getApp()

Page({

  data: {
    code: '',
    decklist: [],
    deckshow: []
  },

  buildDeckShow: function() {
    var tmp = []
    this.data.decklist.forEach(item => {
      var name = item.name 
      var img = `https://www.ygo-sem.cn/${item.image}`
      var t1 = ""
      item.monster.forEach(m => {
        t1 += `${m.count} ${m.name}\n`
      })
      t1 = t1.trim()
      var t2 = ""
      item.magictrap.forEach(m => {
        t2 += `${m.count} ${m.name}\n`
      })
      t2 = t2.trim()
      var t3 = ""
      item.extra.forEach(m => {
        t3 += `${m.count} ${m.name}\n`
      })
      t3 = t3.trim()
      tmp.push({name: name, image: img, monster: t1, magictrap: t2, extra: t3})
    })
    this.setData({
      deckshow: tmp
    })
  },

  getDeckData: function() {
    var that = this
    var cmd = `${app.globalData.baseUrl}/deck?code=${this.data.code}`
    wx.request({
      url: cmd,
      success: res => {
        that.data.decklist = res.data
        that.buildDeckShow() 
      }
    })
  },

  onLoad: function (options) {
    this.setData({
      code: options.code
    })
    this.getDeckData() 
  },

})