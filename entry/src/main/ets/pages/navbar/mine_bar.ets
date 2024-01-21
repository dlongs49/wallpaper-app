import router from '@ohos.router'
import { OpearInter, UinfoInter } from '../../interface/index'
import { base_url } from '../../utils/env'
import request from '../../utils/http'
import { toast } from '../../component/ShowToast'
import { touchBgColor } from '../../utils/tools'

@Component
export default struct MineBar {
  @State opearList: Array<OpearInter> = [
    { icon: $r("app.media.order"), title: "我的壁纸", url: "pages/MineWall", touchColor: Color.Transparent },
    { icon: $r("app.media.love"), title: "我的收藏", url: "pages/MineCollect", touchColor: Color.Transparent },
    { icon: $r("app.media.about"), title: "关于壁纸", url: "pages/AboutUs", touchColor: Color.Transparent },
  ]
  @State touchBgColor:number[] = [Color.Transparent,Color.Transparent,Color.Transparent]
  @State info: UinfoInter = {
    avatar: "",
    uname: ""
  }
  aboutToAppear() {
    this.getUserInfo()
  }
  //个人信息
  async getUserInfo() {
    try {
      const res: any = await request.get("/api/sign/get_user")
      if (res.code === 200) {
        this.info = res.data
      } else {
        this.info = {
          avatar: "",
          uname: ""
        }
      }
    } catch (err) {
      toast.error()
    }
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Image(this.info.avatar ? base_url + this.info.avatar : $r('app.media.user'))
          .width(60)
          .height(60)
          .borderRadius(60)
          .backgroundColor(0xe7e7e7)
        Text(this.info.uname ? this.info.uname : '未登录')
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .margin({ top: 10 })
      }.height(100).margin({ top: 50 }).onClick(() => {
        if (this.info.uname) {
          router.pushUrl({ url: "pages/UserInfo" })
        } else {
          router.pushUrl({ url: "pages/Sign" })
        }
      })

      List() {
        ForEach(this.opearList, (item, i: number) => {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Row() {
                Image(item.icon).width(20).height(20)
                Text(`${item.title}`).fontSize(14).margin({ left: 14 })
              }

              Image($r("app.media.arrow")).width(20).height(20)
            }
            .width("90%")
            .height("100%")
            .margin({ left: 10, right: 10 })
          }
          .height(65)
          .width("100%")
          .backgroundColor(this.touchBgColor[i])
          .onTouch((event) => {
            this.touchBgColor[i] = touchBgColor(event) === 0xffffff ? Color.Transparent : touchBgColor(event)
          })
          .onClick(() => {
            router.pushUrl({ url: item.url })
          })
        })

      }.width("100%").margin({ top: 50 })

      if (this.info.id) {
        Button('退出登录', { type: ButtonType.Capsule, stateEffect: true }).backgroundColor(0xa99ee9).width("90%")
      }
    }.justifyContent(FlexAlign.Start).height("100%").width("100%").linearGradient({
      direction: GradientDirection.Top,
      angle: 180,
      colors: [[0xe9e5fb, 0.0], [0xffffff, 0.5], [0xffffff, 1.0]]
    })
  }
}