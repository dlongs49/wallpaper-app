import common from '@ohos.app.ability.common';
import TopNav from '../component/TopNav';
import { touchBgColor } from '../utils/tools';

@Entry
@Component
struct AboutUs {
  @State cardList: any = [
    { title: "github", url: "https://github.com/dlongs49" },
    { title: "gitee", url: "https://gitee.com/dlongs49" },
  ]
  @State touchBgColor: number[] = [Color.Transparent, Color.Transparent, Color.Transparent]

  onPageShow() {
  }

  async toUrl(url) {
    try {
      let want = {
        "action": "android.intent.action.VIEW",
        "entities": ["entity.system.browsable"],
        "uri": url,
        "type": "text/plain"
      }
      let context = getContext(this) as common.UIAbilityContext;
      await context.startAbility(want)
      console.info(`URL成功`)
    } catch (error) {
      console.info(`URI异常： ${JSON.stringify(error)}`)
    }
  }

  build() {
    Column() {
      TopNav({ title: "关于壁纸", url: "pages/Index" })
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Image($r("app.media.icon"))
          .width(70)
          .height(70)
          .borderRadius(10)
          .backgroundColor(0xe7e7e7)
        Text('壁纸小屋')
          .fontSize(16)
          .margin({ top: 14 })
        Text('v1.0.1')
          .fontSize(12)
          .margin({ top: 14 }).fontColor(0x8f8f8f)
      }.margin({ top: 50 }).height(120)

      List() {
        ForEach(this.cardList, (item: any, i: number) => {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text(`${item.title}`).fontSize(14).margin({ left: 14 })
              Image($r("app.media.arrow")).width(20).height(20)
            }.width("90%")
          }
          .width("100%")
          .height(65)
          .backgroundColor(this.touchBgColor[i])
          .onTouch((event) => {
            this.touchBgColor[i] = touchBgColor(event) === 0xffffff ? Color.Transparent : touchBgColor(event)
          })
          .onClick(() => {
            this.toUrl(item.url)
          })
        })

      }.width("100%").margin({ top: 40 })
    }.justifyContent(FlexAlign.Start).height("100%").width("100%")
  }
}