import window from '@ohos.window'
import connection from '@ohos.net.connection';

export const hmRect = async () => {
  let win = await window.getLastWindow(getContext(this))
  let area: any = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  console.log("设备宽高", JSON.stringify(area));
  return {
    hmWidth: area.bottomRect.width, // 设备的宽度 px像素
    hmHeight: area.bottomRect.top // 设备的高度 px像素
  }
}
// 加载图片交互背景 0x 90[颜色透明度] ffc63a[颜色值#ffc63a]
const colorList = [0x90ffc63a, 0x904ad6ee, 0x90d86af3, 0x906af3a7, 0x907c85f3, 0x9058e16e, 0x90f38abc]

export const setBgColor = (data: any) => {
  return data.map((x, i) => {
    return { ...x, color: colorList[i%colorList.length] }
  })
}
// 手指按下控件背景色交互
export const touchBgColor = (event: any) => {
  if (event.type === TouchType.Down) {
    return 0xeeeeee
  }
  if (event.type === TouchType.Up) {
    return 0xffffff
  }
}

export const getRandomColor = () => {
  const i = Math.round(Math.random() * colorList.length - 1)
  return colorList[i]
}


// 监听网络状态
export const connectNet = ():Promise<number> => {
  let netCon: connection.NetConnection = connection.createNetConnection();
  return new Promise((resolve, reject) => {
    // 模拟器调试不起作用，真机正常
    netCon.register((error) => {
      console.log("监听网络状态异常：", JSON.stringify(error))
      resolve(0)
    })
    netCon.on('netAvailable', (data: connection.NetHandle) => {
      console.log("网络：",data)
      resolve(0)
    })
  })

}