// pages/advsearch/advsearch.js
Page({

  data: {
    // private
    selectedMagicType: [0,0,0,0,0,0],
    selectedTrapType: [0,0,0],
    selectedMonsterAttr: [0,0,0,0,0,0,0],
    selectedMonsterSubType: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    selectedMonsterRace: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    selectedLink: [0,0,0,0,0,0,0,0,0,0],
    
    cNormal: 'lightgray',
    cSelected: '#007AFF',
    cardtype: 0,
    magicType: [],
    trapType: [],
    monsterAttr: [],
    monsterSubType: [],
    monsterRace: [],
    linkArrow:[],
    
    effect: '',
    level: '',
    scale: '',
    atk: '',
    def: '',
    link: '',
  },
  bindEffectInput: function (e) {
    this.data.effect = e.detail.value
  },
  bindLevelInput: function (e) {
    this.data.level = e.detail.value
  },
  bindScaleInput: function (e) {
    this.data.scale = e.detail.value
  },
  bindAtkInput: function (e) {
    this.data.atk = e.detail.value
  },
  bindDefInput: function (e) {
    this.data.def = e.detail.value
  },
  bindLinkInput: function (e) {
    this.data.link = e.detail.value
  },

  bindSearch: function(e) {
    console.log('search!!!!')
  },

  onLoad: function (options) {

  },
  cMonsterTap: function(e) {
    this.setData({
      cardtype: 0
    })
  },
  cMagicTap: function(e) {
    this.setData({
      cardtype: 1
    })
  },
  cTrapTap: function(e) {
    this.setData({
      cardtype: 2
    })
  },
  cMagicTypeTap: function(e) {
    var tmp = []
    var mtype = e.currentTarget.dataset.id
    var idx = this.data.magicType.indexOf(mtype)
    if (idx == -1) {
      this.data.magicType.push(mtype)
    } else {
      this.data.magicType.splice(idx, 1)
    }
    for (var i = 0; i < 6; i++) {
      if (this.data.magicType.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedMagicType: tmp
    })
  },
  cTrapTypeTap: function(e) {
    var tmp = []
    var mtype = e.currentTarget.dataset.id
    var idx = this.data.trapType.indexOf(mtype)
    if (idx == -1) {
      this.data.trapType.push(mtype)
    } else {
      this.data.trapType.splice(idx, 1)
    }
    for (var i = 0; i < 3; i++) {
      if (this.data.trapType.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedTrapType: tmp
    })
  },
  cMonsterAttrTap: function(e) {
    var tmp = []
    var mattr = e.currentTarget.dataset.id
    var idx = this.data.monsterAttr.indexOf(mattr)
    if (idx == -1) {
      this.data.monsterAttr.push(mattr)
    } else {
      this.data.monsterAttr.splice(idx, 1)
    }
    for (var i = 0; i < 7; i++) {
      if (this.data.monsterAttr.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedMonsterAttr: tmp
    })
  },
  cMonsterSubTypeTap: function(e) {
    var tmp = []
    var msub = e.currentTarget.dataset.id
    var idx = this.data.monsterSubType.indexOf(msub)
    if (idx == -1) {
      this.data.monsterSubType.push(msub)
    } else {
      this.data.monsterSubType.splice(idx, 1)
    }
    for (var i = 0; i < 15; i++) {
      if (this.data.monsterSubType.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedMonsterSubType: tmp
    })
  },
  cMonsterRaceTap: function(e) {
    var tmp = []
    var mrace = e.currentTarget.dataset.id
    var idx = this.data.monsterRace.indexOf(mrace)
    if (idx == -1) {
      this.data.monsterRace.push(mrace)
    } else {
      this.data.monsterRace.splice(idx, 1)
    }
    for (var i = 0; i < 25; i++) {
      if (this.data.monsterRace.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedMonsterRace: tmp
    })
  },
  cLinkArrowTap: function(e) {
    var tmp = []
    var mlink = e.currentTarget.dataset.id
    var idx = this.data.linkArrow.indexOf(mlink)
    if (idx == -1) {
      this.data.linkArrow.push(mlink)
    } else {
      this.data.linkArrow.splice(idx, 1)
    }
    for (var i = 0; i < 10; i++) {
      if (this.data.linkArrow.indexOf(`${i}`) == -1) {
        tmp.push(0)
      } else {
        tmp.push(1)
      }
    }
    this.setData({
      selectedLink: tmp
    })
  }


})