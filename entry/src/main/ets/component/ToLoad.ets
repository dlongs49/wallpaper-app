@Preview
@Component
export struct PullUp {
  // 上拉加载
  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image($r("app.media.loading")).width(40).height(40)
      Text("加载中...").fontSize(13)
    }.height(50).width("100%")
  }
}


@Preview
@Component
export struct PullDown {
  @Prop hei:number
  @Prop pull_text:string
  // 下拉刷新
  build() {
    Column() {
      Column() {
      }.width(25).height(this.hei).border({ width: 1, color: 0x000000, radius: 25 }).margin({ bottom: 10 })
      Text(this.pull_text)
        .fontSize(13)
        .textAlign(TextAlign.Center)
    }.margin({ top: 10, bottom: 10 })
  }
}


@Preview
@Component
export struct InEnd {
  // 到底了
  build() {
    Text("到底了~").fontSize(13).lineHeight(50).textAlign(TextAlign.Center)
  }
}