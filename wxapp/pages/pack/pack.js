// pages/pack/pack.js
const app = getApp()

Page({
  data: {
    currentSeason: '',
    packdata: [],
    seasondata: [],
    currentPack: []
  },

  getCardPackData: function() {
    var that = this
    wx.request({
      url: `${app.globalData.baseUrl}/packlist`,
      success: res => {
        that.data.packdata = res.data.data
        that.getSeasons()
        that.getCurrentSeasonPacks()
      }
    })
  },

  seasonAdded: function(arr, s) {
    var ret = false
    arr.forEach(item => {
      if (item.name == s) {
        ret = true
      }
    })
    return ret
  },

  getSeasons: function() {
    var seasontmp = []
    this.data.packdata.forEach(item => {
      if (this.data.currentSeason === '') {
        this.data.currentSeason = item.season
      }
      if (!this.seasonAdded(seasontmp, item.season)) {
        var color = item.season == this.data.currentSeason ? 'black' : 'lightgray'
        seasontmp.push({ name: item.season, color: color })
      }
    })
    this.setData({
      seasondata: seasontmp
    })
  },

  getCurrentSeasonPacks: function() {
    var packtmp = []
    this.data.packdata.forEach(item => {
      if (item.season === this.data.currentSeason) {
        packtmp.push({ abbr: item.abbr, name: item.name, url: item.url })
      }
    })
    this.setData({
      currentPack: packtmp
    })
  },

  onLoad: function (options) {
    this.getCardPackData()
  },

  bindSeasonTap: function(e) {
    var name = e.currentTarget.dataset.id
    this.data.currentSeason = name
    this.getSeasons()
    this.getCurrentSeasonPacks()
  },
  bindPackTap: function(e) {
    var url = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../packdetail/packdetail?url=${url}`,
    })
  }


})