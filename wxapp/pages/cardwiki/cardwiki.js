// pages/cardwiki/cardwiki.js
var WxParse = require('../../wxParse/wxParse.js');

Page({

  data: {
  },

  onLoad: function (options) {
    var that = this;
    wx.getStorage({
      key: 'wikidata',
      success: function (res) {
        WxParse.wxParse('wikidata', 'html', res.data, that, 5);
        
      },
    })
  },

  
})