import router from '@ohos.router'
@Entry
@Component
struct SetWallpaper {
  @State list: String[] = [
    "https://images.pexels.com/photos/3052361/pexels-photo-3052361.jpeg",
    "https://images.pexels.com/photos/3565746/pexels-photo-3565746.jpeg",
    "https://images.pexels.com/photos/1366913/pexels-photo-1366913.jpeg"
  ]

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

          })
      }.position({ y: "92%", x: '5%' }).width("90%")
    }.height("100%").width("100%")
  }
}