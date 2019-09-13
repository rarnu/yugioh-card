let magicType = ['通常', '装备', '速攻', '永续', '场地', '仪式'];
let trapType = ['通常', '永续', '反击'];

let monsterAttr = ['光', '暗', '炎', '水', '地', '风', '神'];
let monsterType = [
    '通常', '效果', '仪式', '融合', '同调', 'XYZ', '卡通',
    '同盟', '灵魂', '调整', '二重', '灵摆', '反转', '特召',
    '连接'
];

let monsterRace = [
    '水', '兽', '兽战士', '创造神', '恐龙', '幻神兽', '龙',
    '天使', '恶魔', '鱼', '昆虫', '机械', '植物', '念动力',
    '炎', '爬虫类', '岩石', '海龙', '魔法师', '雷', '战士',
    '鸟兽', '不死', '幻龙', '电子界'
];

let linkArrow = [
    '↖', '↑', '↗',
    '←', '', '→',
    '↙', '↓', '↘'
];

function queryParam(name) {
    let query = window.location.search.substring(1);
    let vars = query.split("&");
    for (let i = 0; i < vars.length; i++) {
        let pair = vars[i].split("=");
        if (pair[0] === name) {
            return pair[1];
        }
    }
    return null;
}

function toast(msg, type) {
    toastr.options.closeDuration = 300;
    toastr.options.timeOut = 2000;
    toastr.options.extendedTimeOut = 60;
    toastr.options.positionClass = "toast-bottom-center";
    if (type === 0) {
        toastr.error(msg);
    } else {
        toastr.success(msg);
    }

}