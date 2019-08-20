// cardlist.js
const app = getApp()

Page({
  data: {
    keyword: '',
    currentPage: 1,
    totalPage: 0,
    listData: [],
    strFirst: '<<',
    strPrev: '<',
    strNext: '>',
    strLast: '>>'
  },
  bindCardItemTap: function (e) {
    var hash = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../carddetail/carddetail?hash=${hash}`
    })
  },
  searchCard: function() {
    var that = this;
    var cmd = `${app.globalData.baseUrl}/search?key=${this.data.keyword}&page=${this.data.currentPage}`
    wx.request({
      url: cmd,
      success: res => {
        that.setData({
          currentPage: res.data.meta.cur_page,
          totalPage: res.data.meta.total_page,
          listData: res.data.cards
        })
      }
    })
  },
  onLoad: function (options) {
    this.setData({
      keyword: options.keyword
    })
    this.searchCard()
  },
  bindFirstTap: function(e) {
    if (this.data.currentPage != 1) {
      this.data.currentPage = 1
      this.searchCard()
    }
  },
  bindPrevTap: function(e) {
    if (this.data.currentPage > 1) {
      this.data.currentPage--
      this.searchCard()
    }
  },
  bindNextTap: function(e) {
    if (this.data.currentPage < this.data.totalPage) {
      this.data.currentPage++
      this.searchCard()
    }
  },
  bindLastTap: function(e) {
    if (this.data.currentPage != this.data.totalPage) {
      this.data.currentPage = this.data.totalPage
      this.searchCard()
    }
  },
  imgError: function(e) {
    console.log(e)
    var index = e.currentTarget.dataset.index
    var img = 'listData[' + index + '].img_url'
    this.setData({
      [img]: '../../images/img0.png'
    })
  }
  
})