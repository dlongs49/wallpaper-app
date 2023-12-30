@Entry
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @State list: Array<string> = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',]
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()

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
          if (this.currentIndex == 0) {
            WaterFlow({ scroller: this.scroller }) {
              ForEach(this.list, (item: string, idx: number) => {
                FlowItem() {
                  Column() {
                    if (idx === 0) {
                      Row() {
                        Image("https://www.dillonl.com/u/demo.png").width(110).height(50).borderRadius(10)
                        Text("热门IP壁纸").offset({ x: -90, y: 2 }).fontColor(0xffffff)
                      }.width(110).height(50).margin({ bottom: 14 })
                    }
                    Column() {
                      Image("https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=600")
                        .width("100%")
                        .height(320)
                        .borderRadius(10)
                        .backgroundColor(0xffdbdbdb)
                      Text("自然风光").fontSize(14).margin({ top: '5' })
                      Text("9张").fontSize(12).fontColor(0xffcccccc).margin({ top: 5 })
                    }.width("100%").alignItems(HorizontalAlign.Start)
                  }.alignItems(HorizontalAlign.Start)
                }.width("50%").margin({ bottom: 18 })

              }, item => item)

            }
            .width('95%')
            .height('100%')
            .layoutDirection(FlexDirection.Column)
            .columnsTemplate("1fr 1fr")
            .columnsGap(12)
          }

        }.tabBar(this.TabBuilder(0, '首页'))

        TabContent() {
          Scroll(this.home_scroller) {
            Grid() {
              ForEach(this.list, (item) => {
                GridItem() {
                  Stack({ alignContent: Alignment.TopStart }) {
                    Image("https://www.dillonl.com/u/demo.png").borderRadius(12).width('100%')
                    Text("中国风").fontColor(0xffffffff).fontSize(18).markAnchor({ x: -14, y: -20 })
                  }.width('48.5%')
                }
              })

            }.columnsTemplate("lfr lfr").columnsGap(10).rowsGap(10).width("94%")
          }.width("100%").scrollBar(BarState.Off)

        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {

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