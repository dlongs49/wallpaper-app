import {hmRect,setBgColor} from '../utils/tools'
import emitter from '@ohos.events.emitter'
@Component
export default struct TopNav {
  @Prop type: string
  @Prop state: number
  @State hmHeight: string = "100%"
  async aboutToAppear() {
    const hr = await hmRect()
    if(this.type == "page"){
      this.hmHeight = (hr.hmHeight - 300) + "px"
    }
    if(this.type == "bar"){
      this.hmHeight = (hr.hmHeight - 56) + "px"
    }
  }
  build() {
    Column(){
      Image($r("app.media.nodata")).width(140).height(140)
      if(this.state === 0){
        Text("没有找到该内容").fontColor(0x949192).fontSize(12).margin({top:10})
      }
      if(this.state === -1){
        Text("网络不可用").fontColor(0x949192).fontSize(12).margin({top:10})
        Text("点击屏幕重新加载").fontColor(0x949192).fontSize(12).margin({top:5})
      }

    }.width('100%').height(this.hmHeight).backgroundColor(0xf6f6f6).justifyContent(FlexAlign.Center).onClick(()=>{
      if(this.state === -1){
        emitter.emit({ eventId:10000 }, {data:null});
      }
    })
  }
}