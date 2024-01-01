import router from '@ohos.router'

@CustomDialog
struct CustomDialogComm{
  controller: CustomDialogController
  onLock:()=>void
  onDesktop:()=>void
  onAll:()=>void
  build(){
    Column(){
      Button({ type: ButtonType.Normal }){
        Text("应用锁屏").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(()=>{
        this.onLock()
      })
      Button({ type: ButtonType.Normal }){
        Text("应用桌面").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(()=>{
        this.onDesktop()
      })
      Button({ type: ButtonType.Normal }){
        Text("应用全部").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(()=>{
        this.onAll()
      })
      Button('取消', { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(0xeeeeee)
        .width("90%")
        .height(44)
        .margin({top:15})
        .fontColor(0x000000)
        .onClick(() => {
          this.controller.close()
        })
    }.backgroundColor(0xffffff).borderRadius(14).padding({top:25,bottom:20}).width("90%")
  }
}
@Entry
@Component
struct SetWallpaper {
  @State list: String[] = [
    "https://images.pexels.com/photos/3052361/pexels-photo-3052361.jpeg",
    "https://images.pexels.com/photos/3565746/pexels-photo-3565746.jpeg",
    "https://images.pexels.com/photos/1366913/pexels-photo-1366913.jpeg"
  ]
  dialogController:CustomDialogController = new CustomDialogController({
    builder:CustomDialogComm({
      onLock:this.onLock,
      onDesktop:this.onDesktop,
      onAll:this.onAll
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    autoCancel: true,
    customStyle:true
  })
  onLock(){
    console.log("应用锁屏")
  }
  onDesktop(){
    console.log("应用桌面")
  }
  onAll(){
    console.log("应用全部")
  }
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Swiper() {
        ForEach(this.list, (item: string) => {
          Image(item).width("100%").height("100%").backgroundColor('0xffeeeeee')
        }, item => item)
      }.indicator(false)

      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image($r("app.media.close")).width("70px").height("70px")
      }
      .position({ x: "82%",y:'6%' })
      .width("120px")
      .height("120px")
      .backgroundColor(0x000000)
      .opacity(0.6)
      .borderRadius(100)
      .onClick(()=>{
        router.back({url:'pages/Index'});
      })
      Row() {
        Image($r("app.media.love_white")).width(20).height(20).margin({ right: 20 })
        Button('应用壁纸', { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0xffffff)
          .width("80%")
          .fontColor(0x000000)
          .onClick(() => {
            if(this.dialogController != undefined){
              this.dialogController.open()
            }
          })
      }.position({ y: "92%", x: '5%' }).width("90%")
    }.height("100%").width("100%")
  }
}