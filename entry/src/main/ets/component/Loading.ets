@Preview
@Component
export default struct Loading {

  build() {

     Column(){
       Image($r("app.media.loading")).width(60).height(60)
       Text("加载中...").fontSize(12).margin({top:4}).fontColor(0x000000)
     }
  }
}