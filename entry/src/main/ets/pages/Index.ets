@Entry
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @State list: Array<string> = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '']
  scroller: Scroller = new Scroller()

  @Builder TabBuilder(index: number, title: string) {

    Column() {
      Image(this.currentIndex === index ? `../resources/base/media/${index}_.svg` : `../resources/base/media/${index}.svg`)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(10)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
            WaterFlow({ scroller: this.scroller }) {
              ForEach(this.list, (item: string,index:number) => {
                FlowItem() {
                  Column(){
                    if(index === 0){
                      Row() {
                        Image("https://www.dillonl.com/u/demo.png").width(110).height(50).borderRadius(10)
                        Text("热门IP壁纸").offset({ x: -90, y: 2 }).fontColor(0xffffff)
                      }.width(110).height(50).margin({ bottom: 14 })
                    }
                    Column() {
                      Image("https://www.dillonl.com/u/demo.png").width("100%").height(320).borderRadius(10)
                      Text("自然风光").fontSize(14).margin({ top: '5' })
                      Text("9张").fontSize(12).fontColor(0xffcccccc).margin({ top: 5 })
                    }.width("100%").alignItems(HorizontalAlign.Start)
                  }.alignItems(HorizontalAlign.Start)

                }.width("50%").margin({ bottom: 18 })

              })

            }.width('95%').height('100%').layoutDirection(FlexDirection.Column).columnsTemplate("1fr 1fr").columnsGap(12)
        }.tabBar(this.TabBuilder(0, '首页'))

        TabContent() {
          Column() {
            Text('Tab2')
              .fontSize(36)
              .fontColor('#182431')
              .fontWeight(500)
              .opacity(0.4)
              .margin({ top: 30, bottom: 56.5 })
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }.width('100%')
        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {
          Column() {
            Text('Tab3')
              .fontSize(36)
              .fontColor('#182431')
              .fontWeight(500)
              .opacity(0.4)
              .margin({ top: 30, bottom: 56.5 })
            Divider()
              .strokeWidth(0.5)
              .color('#182431')
              .opacity(0.05)
          }.width('100%')
        }.tabBar(this.TabBuilder(2, '我的'))
      }
      .vertical(false)
      .barHeight(56)
      .onChange((index: number) => {
        if (index === 0) {
          this.selectedFontColor = '#e6dd23'
        } else if (index === 1) {
          this.selectedFontColor = '#a99ee9'
        } else {
          this.selectedFontColor = '#ea569f'
        }
        this.currentIndex = index
      })
      .width('100%')
      .height('100%')
    }.width('100%').height('100%')
  }
}