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