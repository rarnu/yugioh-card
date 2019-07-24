/**
 * 显示菜单
 */
function showMenu () {

  const prompt = require('@system.prompt')
  const router = require('@system.router')

  prompt.showContextMenu({
    itemList: ['禁限卡表', '卡包列表', '添加到桌面快捷方式', '关于', '取消'],
    success: function (ret) {
      switch (ret.index) {
      case 0:
        router.push({
          uri: '/Limit'
        })
        break
      case 1:
        router.push({
          uri: '/Pack'
        })
        break
      case 2:        
        createShortcut()
        break
      case 3:
        router.push({
          uri: '/About'
        })
        break
      case 4:
        break
      default:
        prompt.showToast({
          message: '2333'
        })
      }
    }
  })
}

/**
 * 创建桌面图标
 * 注意：使用加载器测试`创建桌面快捷方式`功能时，请先在`系统设置`中打开`应用加载器`的`桌面快捷方式`权限
 */
function createShortcut () {
  const prompt = require('@system.prompt')
  const shortcut = require('@system.shortcut')
  shortcut.hasInstalled({
    success: function (ret) {
      if (ret) {
        prompt.showToast({
          message: '已创建桌面图标'
        })
      } else {
        shortcut.install({
          success: function () {
            prompt.showToast({
              message: '成功创建桌面图标'
            })
          },
          fail: function (errmsg, errcode) {
            prompt.showToast({
              message: `${errcode}: ${errmsg}`
            })
          }
        })
      }
    }
  })
}

export default {
  showMenu,
  createShortcut
}
