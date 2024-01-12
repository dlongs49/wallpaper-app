import router from '@ohos.router'
import wallpaper from '@ohos.wallpaper';
import request from '@ohos.request';
import requests from '@system.request';
import document from '@ohos.document';
import { OpearInter } from '../interface/index'
@Entry
@Component
struct Sign {
  @State opearList: Array<OpearInter> = [
    { icon: $r("app.media.order"), title: "我的壁纸" },
    { icon: $r("app.media.love"), title: "我的收藏" },
    { icon: $r("app.media.about"), title: "关于壁纸" },
  ]
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()

  @Builder NavigationTitle() {
    Column() {
    }.backgroundColor(0xe9e5fb).height(52).width("100%")
  }

  build() {
    Navigation() {
      this.NavigationTitle()
      Column() {
        List() {
          ForEach(this.opearList, (item) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Image(item.icon).width(20).height(20)
                  Text(`${item.title}`).fontSize(14).margin({ left: 14 })
                }

                Image($r("app.media.arrow")).width(20).height(20)
              }
            }.margin({ bottom: 30 })
          })

        }.width("90%").margin({ top: 50 })
        Button('退出登录', { type: ButtonType.Capsule, stateEffect: true }).backgroundColor(0xa99ee9).width("90%")
      }.justifyContent(FlexAlign.Start).height("100%").width("100%").linearGradient({
        direction: GradientDirection.Top,
        angle: 180,
        colors: [[0xe9e5fb, 0.0], [0xffffff, 0.5], [0xffffff, 1.0]]
      })
    }.width('100%').height('100%').hideTitleBar(true)
  }
}