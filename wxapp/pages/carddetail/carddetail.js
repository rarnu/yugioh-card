// pages/carddetail.js
const app = getApp()

Page({
  data: {
    hash: '',
    carddata: {},
    cardadjust: '',
    cardwiki: '',
    isMonster: false,
    isLinkMonster: false,
    isXYZMonster: false,
    linkArrows: '',
    effect: ''
  },
  getCardDetail: function() {
    var that = this
    var cmd = `${app.globalData.baseUrl}/carddetail?hash=${this.data.hash}`
    wx.request({
      url: cmd,
      responseType: 'text',
      success: res => {
        let data = res.data
        let sarr = data.split('\\\\\\\\')
        let json = JSON.parse(sarr[0])
        if (json.result == 0) {
          that.setData({
            carddata: json.data,
            cardadjust: sarr[1],
            cardwiki: sarr[2],
            isMonster: json.data.cardtype.indexOf('怪兽') != -1,
            isLinkMonster: json.data.cardtype.indexOf('连接') != -1,
            isXYZMonster: json.data.cardtype.indexOf('XYZ') != -1,
            linkArrows: that.replaceLinkArrow(json.data.linkarrow),
            effect: that.replaceEffect(json.data.effect)
          })
        }
      }
    })
  },
  onLoad: function (options) {
    this.setData({
      hash: options.hash
    })
    this.getCardDetail()
  },
  replaceLinkArrow: function(s) {
    var str = s
    str = str.replace('1', '↙')
    str = str.replace('2', '↓')
    str = str.replace('3', '↘')
    str = str.replace('4', '←')
    str = str.replace('6', '→')
    str = str.replace('7', '↖')
    str = str.replace('8', '↑')
    str = str.replace('9', '↗')
    return str
  },
  replaceEffect: function(s) {
    let tmp = s
    if (tmp) {
      tmp = tmp.replace(/<br \/>/g, '\n')
    }
    return tmp
  },
  imgError: function(e) {
    var img = 'carddata.imageid'
    this.setData({
      [img]: '0'
    })
  },
  bindWikiTap: function(e) {
    var that = this
    wx.setStorage({
      key: 'wikidata',
      data: that.data.cardwiki
    })
    wx.navigateTo({
      url: '../cardwiki/cardwiki',
    })
  }
})