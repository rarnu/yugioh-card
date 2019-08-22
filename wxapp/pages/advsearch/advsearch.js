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

  // parsers
  parseCardType: function() {
    if (this.data.cardtype == 1) {
      return '魔法'
    } else if (this.data.cardtype == 2) {
      return '陷阱'
    } else {
      return '怪兽'
    }
  },
  buildMagicCardType: function() {
    var k = ''
    if (this.data.magicType.indexOf('0') != -1) { k += '通常,' }
    if (this.data.magicType.indexOf('1') != -1) { k += '装备,' }
    if (this.data.magicType.indexOf('2') != -1) { k += '速攻,' }
    if (this.data.magicType.indexOf('3') != -1) { k += '永续,' }
    if (this.data.magicType.indexOf('4') != -1) { k += '场地,' }
    if (this.data.magicType.indexOf('5') != -1) { k += '仪式,' }
    k = k.replace(/,$/gi, '')
    return k
  },
  buildTrapCardType: function() {
    var k = ''
    if (this.data.trapType.indexOf('0') != -1) { k += '通常,' }
    if (this.data.trapType.indexOf('1') != -1) { k += '永续,' }
    if (this.data.trapType.indexOf('2') != -1) { k += '反击,' }
    k = k.replace(/,$/gi, '')
    return k
  },

  buildMonsterCardType: function() {
    var k = ''
    if (this.data.monsterSubType.indexOf('0') != -1) { k += '通常,' }
    if (this.data.monsterSubType.indexOf('1') != -1) { k += '效果,' }
    if (this.data.monsterSubType.indexOf('2') != -1) { k += '仪式,' }
    if (this.data.monsterSubType.indexOf('3') != -1) { k += '融合,' }
    if (this.data.monsterSubType.indexOf('4') != -1) { k += '同调,' }
    if (this.data.monsterSubType.indexOf('5') != -1) { k += 'XYZ,' }
    if (this.data.monsterSubType.indexOf('6') != -1) { k += '卡通,' }
    if (this.data.monsterSubType.indexOf('7') != -1) { k += '同盟,' }
    if (this.data.monsterSubType.indexOf('8') != -1) { k += '灵魂,' }
    if (this.data.monsterSubType.indexOf('9') != -1) { k += '调整,' }
    if (this.data.monsterSubType.indexOf('10') != -1) { k += '二重,' }
    if (this.data.monsterSubType.indexOf('11') != -1) { k += '灵摆,' }
    if (this.data.monsterSubType.indexOf('12') != -1) { k += '反转,' }
    if (this.data.monsterSubType.indexOf('13') != -1) { k += '特殊召唤,' }
    if (this.data.monsterSubType.indexOf('14') != -1) { k += '连接,' }
    k = k.replace(/,$/gi, '')
    return k
  },
  buildMonsterRace: function() {
    var k = ''
    if (this.data.monsterRace.indexOf('0') != -1) { k += '水,' }
    if (this.data.monsterRace.indexOf('1') != -1) { k += '兽,' }
    if (this.data.monsterRace.indexOf('2') != -1) { k += '兽战士,' }
    if (this.data.monsterRace.indexOf('3') != -1) { k += '创造神,' }
    if (this.data.monsterRace.indexOf('4') != -1) { k += '恐龙,' }
    if (this.data.monsterRace.indexOf('5') != -1) { k += '幻神兽,' }
    if (this.data.monsterRace.indexOf('6') != -1) { k += '龙,' }
    if (this.data.monsterRace.indexOf('7') != -1) { k += '天使,' }
    if (this.data.monsterRace.indexOf('8') != -1) { k += '恶魔,' }
    if (this.data.monsterRace.indexOf('9') != -1) { k += '鱼,' }
    if (this.data.monsterRace.indexOf('10') != -1) { k += '昆虫,' }
    if (this.data.monsterRace.indexOf('11') != -1) { k += '机械,' }
    if (this.data.monsterRace.indexOf('12') != -1) { k += '植物,' }
    if (this.data.monsterRace.indexOf('13') != -1) { k += '念动力,' }
    if (this.data.monsterRace.indexOf('14') != -1) { k += '炎,' }
    if (this.data.monsterRace.indexOf('15') != -1) { k += '爬虫类,' }
    if (this.data.monsterRace.indexOf('16') != -1) { k += '岩石,' }
    if (this.data.monsterRace.indexOf('17') != -1) { k += '海龙,' }
    if (this.data.monsterRace.indexOf('18') != -1) { k += '魔法师,' }
    if (this.data.monsterRace.indexOf('19') != -1) { k += '雷,' }
    if (this.data.monsterRace.indexOf('20') != -1) { k += '战士,' }
    if (this.data.monsterRace.indexOf('21') != -1) { k += '鸟兽,' }
    if (this.data.monsterRace.indexOf('22') != -1) { k += '不死,' }
    if (this.data.monsterRace.indexOf('23') != -1) { k += '幻龙,' }
    if (this.data.monsterRace.indexOf('24') != -1) { k += '电子界,' }
    k = k.replace(/,$/gi, '')
    return k
  },
  buildMonsterElement: function() {
    var k = ''
    if (this.data.monsterAttr.indexOf('0') != -1) { k += '光,' }
    if (this.data.monsterAttr.indexOf('1') != -1) { k += '暗,' }
    if (this.data.monsterAttr.indexOf('2') != -1) { k += '炎,' }
    if (this.data.monsterAttr.indexOf('3') != -1) { k += '水,' }
    if (this.data.monsterAttr.indexOf('4') != -1) { k += '地,' }
    if (this.data.monsterAttr.indexOf('5') != -1) { k += '风,' }
    if (this.data.monsterAttr.indexOf('6') != -1) { k += '神,' }
    k = k.replace(/,$/gi, '')
    return k
  },
  buildMonsterLinkArrow: function() {
    let k = ''
    if (this.data.linkArrow.indexOf('1') != -1) { k += '1,' }
    if (this.data.linkArrow.indexOf('2') != -1) { k += '2,' }
    if (this.data.linkArrow.indexOf('3') != -1) { k += '3,' }
    if (this.data.linkArrow.indexOf('4') != -1) { k += '4,' }
    if (this.data.linkArrow.indexOf('6') != -1) { k += '6,' }
    if (this.data.linkArrow.indexOf('7') != -1) { k += '7,' }
    if (this.data.linkArrow.indexOf('8') != -1) { k += '8,' }
    if (this.data.linkArrow.indexOf('9') != -1) { k += '9,' }
    k = k.replace(/,$/gi, '')
    return k
  },

  // search
  bindSearch: function(e) {
    var key = ` +(类:${this.parseCardType()})`
    if (this.data.effect !== '') {
      key += ` +(效果:${this.data.effect})`
    }

    if (this.data.cardtype == 1) {
      var ct2 = this.buildMagicCardType()
      if (ct2 !== '') {
        key += ` +(类:${ct2})`
      }
    } else if (this.data.cardtype == 2) {
      let ct2 = this.buildTrapCardType()
      if (ct2 !== '') {
        key += ` +(类:${ct2})`
      }
    } else {
      if (this.data.atk !== '') {
        key += ` +(atk:${this.data.atk})`
      }
      if (this.data.def !== '') {
        key += ` +(def:${this.data.def})`
      }
      if (this.data.level !== '') {
        key += ` +(level:${this.data.level})`
      }
      if (this.data.scale !== '') {
        key += ` +(刻度:${this.data.scale})`
      }
      if (this.data.link !== '') {
        key += ` +(link:${this.data.link})`
      }
      var ct2 = this.buildMonsterCardType()
      if (ct2 !== '') {
        key += ` +(类:${ct2})`
      }
      var race = this.buildMonsterRace()
      if (race !== '') {
        key += ` +(族:${race})`
      }
      var ele = this.buildMonsterElement()
      if (ele !== '') {
        key += ` +(属性:${ele})`
      }
      var la = this.buildMonsterLinkArrow()
      if (la !== '') {
        key += ` +(linkArrow:${la})`
      }
    }

    wx.navigateTo({
      url: `../cardlist/cardlist?keyword=${key}`
    })

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