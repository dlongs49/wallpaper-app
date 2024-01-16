import AppContext from '@ohos.app.ability.common';
import wallpaper from '@ohos.wallpaper';
import prompt from '@ohos.prompt'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav';

@Entry
@Component
struct AboutUs {
  @State cardList: any = [
    {title:"github",url:"https://github.com/dlongs49"},
    {title:"gitee",url:"https://gitee.com/dlongs49"},
  ]

  onPageShow() {
  }

  build() {
    Column() {
      TopNav({ title: "关于壁纸", url: "pages/Index" })
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Image("")
          .width(70)
          .height(70)
          .borderRadius(6)
          .backgroundColor(0xe7e7e7)
        Text('壁纸小屋')
          .fontSize(16)
          .margin({ top: 14 })
        Text('v1.0.1')
          .fontSize(12)
          .margin({ top: 14 }).fontColor(0x8f8f8f)
      }.margin({ top: 50 }).height(120)

      List() {
        ForEach(this.cardList, (item) => {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text(`${item.title}`).fontSize(14).margin({ left: 14 })
              Image($r("app.media.arrow")).width(20).height(20)
            }
          }.margin({ bottom: 30 }).onClick(() => {

          })
        })

      }.width("90%").margin({ top: 50 })
    }.justifyContent(FlexAlign.Start).height("100%").width("100%")
  }
}