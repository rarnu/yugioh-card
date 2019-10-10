//index.js
const app = getApp()

Page({
  data: {
    // private
    change: '<换一批>',

    showCardPopup: false,
    popupHeight: 0,

    keyword: '',
    hotwords: [],
    hotcards: [],
    hotpacks: [],
    imageids: [],
  },
  getHotestData: function() {
    var that = this
    var cmd = `${app.globalData.baseUrl}/hotest`
    wx.request({
      url: cmd,
      success: res => {
        that.setData({
          hotwords: res.data.search,
          hotcards: res.data.card,
          hotpacks: res.data.pack
        })
      }
    })
  },
  onLoad: function() {
    this.getHotestData()
  },
  bindKeywordInput: function(e) {
      this.data.keyword = e.detail.value
  },
  findOneCard: function(imgid) {
    var that = this
    wx.request({
      url: `${app.globalData.baseUrl}/findbyimage?imgid=${imgid}`,
      success: res => {
        if (res.data.result === 0) {
          wx.navigateTo({
            url: `../carddetail/carddetail?hash=${res.data.hash}`
          })
        } else {
          wx.showToast({
            title: '没有找到匹配的卡片.',
            image: "../../images/error.png"
          })
        }
      }
    })
  },
  imageSearch: function(path) {
    console.log(path)
    var that = this
    wx.uploadFile({
      url: `${app.globalData.baseUrl}/matchimage`,
      filePath: path,
      name: 'file',
      success(res) {
        var json = JSON.parse(res.data)
        if (json.result === 0) {
          var imgids = json.imgids
          if (imgids.length === 0) {
            wx.showToast({
              title: '没有找到匹配的卡片.',
              image: "../../images/error.png"
            })
          } else if (imgids.length === 1) {
            that.findOneCard(imgids[0])
          } else {
            var lines = parseInt(imgids.length / 5)
            if (imgids.length % 5 !== 0) {
              lines++
            }            
            that.setData({
              popupHeight: lines * 163,
              imageids: imgids,
              showCardPopup: true
            })
          }
        } else {
          wx.showToast({
            title: '没有找到匹配的卡片.',
            image: "../../images/error.png"
          })
        }
      },
    })
  },

  takePhoto: function() {
    var that = this
    wx.chooseImage({
      count: 1,
      sizeType: ['original'],
      sourceType: ['camera'],
      success(res) {
        var tempFilePaths = res.tempFilePaths
        that.imageSearch(tempFilePaths[0])
      }
    })
  },
  chooseLibrary: function() {
    var that = this
    wx.chooseImage({
      count: 1,
      sizeType: ['original'],
      sourceType: ['album'],
      success(res) {
        var tempFilePaths = res.tempFilePaths
        that.imageSearch(tempFilePaths[0])
      }
    })
  },
  bindImageTap: function(e) {
    var that = this
    wx.showActionSheet({
      itemList: ['拍照', '从相册选取'],
      success(res) {
        switch(res.tapIndex) {
          case 0:
            that.takePhoto()
            break
          case 1:
            that.chooseLibrary()
            break
        } 
      },
    })
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
    wx.navigateTo({
      url: '../decklist/decklist',
    })
  },
  bindMineTap: function(e) {
    if (app.globalData.loginState) {
      console.log('6666')
    } else {
      wx.showToast({
        title: '请先进行登录.',
      })
    }
  },
  bindHotwordTap: function(e) {
    var key = e.currentTarget.dataset.id
    this.data.keyword = key
    this.jumpToCardList()
  },
  bindHotcardTap: function(e) {
    var hash = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../carddetail/carddetail?hash=${hash}`
    })
  },
  bindHotdeckTap: function(e) {
    var url = e.currentTarget.dataset.id
    wx.navigateTo({
      url: `../packdetail/packdetail?url=${url}`,
    })
  },
  bindAboutTap: function(e) {
    wx.navigateTo({
      url: '../about/about',
    })
  },
  bindChangeTap: function(e) {
    this.getHotestData()
  },

  popupCardTap: function(e) {
    var imgid = e.currentTarget.dataset.id
    this.findOneCard(imgid)
  },

  popupClose: function(e) {
    this.setData({
     showCardPopup: false
    })
  }
})
