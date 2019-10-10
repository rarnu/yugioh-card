//app.js
App({
  onLaunch: function () {
    var logs = wx.getStorageSync('logs') || []
    logs.unshift(Date.now())
    wx.setStorageSync('logs', logs)

    // login
    wx.login({
      success: res => {
        if (res.code) {
          wx.request({
            url: `${this.globalData.baseUrl}/wxlogin?code=${res.code}`,
            success: resp => {
              if (resp.data.result === 0) {
                this.globalData.loginState = true
              }
            }
          })
        }
      }
    })
  },
  globalData: {
    baseUrl: 'https://rarnu.xyz',
    loginState: false,
    debug: true
  }
})