import router from '@ohos.router'
@Component
export default struct TopNav {
  @Prop title: string
  @Prop url: string
  build() {
    Row(){
      Flex({ justifyContent: FlexAlign.SpaceBetween,alignContent: FlexAlign.End , alignItems: ItemAlign.End  }) {
        Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center  }) {
          Image($r("app.media.back")) {
          }.width(25).height(25)
        }.width(50).height(50).onClick(() =>{
          router.back({
            url:this.url
          })
        })
        Text(this.title).height(50)
        Flex(){}.width(40)
      }.height('100%')
    }.width('88%').height(100)
  }
}