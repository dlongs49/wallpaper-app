import HomeBar from './navbar/home_bar';
import SortBar from './navbar/sort_bar';
import MineBar from './navbar/mine_bar';
@Entry
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()

  onPageShow() {
  }
  @Builder NavigationTitle() {
    Column() {
    }.backgroundColor(this.currentIndex == 2 ? 0xe9e5fb : '').height(52).width("100%")
  }

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
    Navigation() {
      this.NavigationTitle()
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          if (this.currentIndex == 0) {
            HomeBar()
          }

        }.tabBar(this.TabBuilder(0, '首页'))

        TabContent() {
          SortBar()
        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {
          MineBar()
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
      .height('94%')
    }.width('100%').height('100%').hideTitleBar(true)
  }
}