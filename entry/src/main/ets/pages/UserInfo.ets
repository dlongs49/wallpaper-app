import router from '@ohos.router'
import prompt from '@ohos.prompt'
import { SignInter, UinfoInter } from '../interface/index'
import request from '../utils/http'
import storage from '../utils/storage'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import { toast } from '../component/ShowToast'
import { touchBgColor } from '../utils/tools'

@Entry
@Component
struct Sign {
  controller: TextInputController = new TextInputController()
  @State form: SignInter = {
    uname: "wallpaper",
    password: "string"
  }
  @State touchBgColor_1: number = 0xffffff
  @State touchBgColor_2: number = 0xffffff
  @State touchBgColor_3: number = 0xffffff
  @State touchBgColor_4: number = 0xffffff
  @State touchBgColor_5: number = 0xffffff
  @State loading: boolean = false
  @State info: UinfoInter = {
    avatar: "",
    uname: ""
  }

  onPageShow() {
    this.getUserInfo()
  }
  //个人信息
  async getUserInfo() {
    try {
      const res: any = await request.get("/api/sign/get_user")
      if (res.code === 200) {
        this.info = res.data
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      toast.error()
    }
  }

  build() {
    Column() {
      TopNav({ title: "", url: "pages/Index" })
      Column() {
        Text("我的信息").fontSize(30).textAlign(TextAlign.Start).fontWeight(200).width("90%")
        Text("基础资料")
          .fontSize(10)
          .fontColor(0x999999)
          .textAlign(TextAlign.Start)
          .width("90%")
          .margin({ top: 20, bottom: 15 })
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("头像")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Image("https://www.dillonl.com/u/snow.jpg").width(40).height(40).border({
              width: 1,
              color: 0xeeeeee,
              radius: 40,
            })
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })
        }.width("100%").height(60).backgroundColor(this.touchBgColor_1).onTouch((event) => {
          this.touchBgColor_1 = touchBgColor(event)
        })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("昵称")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Text("书本书华").fontSize(14).fontColor(0x999999)
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })
        }.width("100%").height(60).backgroundColor(this.touchBgColor_2).onTouch((event) => {
          this.touchBgColor_2 = touchBgColor(event)
        })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("注册日期")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Text("注册日期").fontSize(14).fontColor(0x999999)
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })
        }.width("100%").height(60).backgroundColor(this.touchBgColor_3).onTouch((event) => {
          this.touchBgColor_3 = touchBgColor(event)
        })

        Column() {
        }.width("90%").height(1).backgroundColor(0xf2f2f2).margin({ top: 10, bottom: 10 })

        Text("详细资料")
          .fontSize(10)
          .fontColor(0x999999)
          .textAlign(TextAlign.Start)
          .width("90%")
          .margin({ top: 20, bottom: 20 })
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("性别")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Select([
              { value: '男', icon: $r("app.media.man") },
              { value: '女', icon: $r("app.media.woman") }
            ])
              .selected(2)
              .value('TTTTT')
              .font({ size: 16, weight: 500 })
              .fontColor(0x999999)
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                console.info('Select:' + index)
              })
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })

        }.width("100%").height(60).backgroundColor(this.touchBgColor_4).onTouch((event) => {
          this.touchBgColor_4 = touchBgColor(event)
        })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("国家/地区")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Text("中国")
            .fontSize(14)
            .fontColor(0x999999)
            .height("100%")
            .width("70%")
            .textAlign(TextAlign.End)
            .margin({ right: 25 })
        }.width("100%").height(60).backgroundColor(this.touchBgColor_5).onTouch((event) => {
          this.touchBgColor_5 = touchBgColor(event)
        })

      }.width("100%")
    }
    .width("100%")
  }
}
