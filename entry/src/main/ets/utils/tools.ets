import window from '@ohos.window'
export const hmRect = async ()=>{
  let win = await window.getLastWindow(getContext(this))
  let area: any = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  console.log("设备宽高",JSON.stringify(area));
  return {
    hmWidth:area.bottomRect.width, // 设备的宽度 px像素
    hmHeight:area.bottomRect.top   // 设备的高度 px像素
  }
}
// 加载图片交互背景 0x 90[颜色透明度] ffc63a[颜色值#ffc63a]
const colorList = [0x90ffc63a,0x904ad6ee,0x90d86af3,0x906af3a7,0x907c85f3,0x9058e16e,0x90f38abc]
export const setBgColor = (data:any)=>{
 return data.map((x,i)=>{
    return {...x,color: colorList[i%colorList.length]}
  })
}