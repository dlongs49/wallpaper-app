import router from '@ohos.router'
import prompt from '@ohos.prompt'
import { SignInter } from '../interface/index'
import request from '../utils/http'
import storage from '../utils/storage'
import TopNav from '../component/TopNav'

@Entry
@Component
struct Sign {
  controller: TextInputController = new TextInputController()
  @State form: SignInter = {
    uname: "wallpaper",
    password: "string"
  }
  @State loading: boolean = false

  onPageShow() {
  }

  async sign_in() {
    try {
      this.loading = true
      const res: any = await request.post("/api/sign/reg_login", this.form)
      this.loading = false
      if (res.code === 200) {
        await storage.set('token', res.data)
        router.replaceUrl({
          url: "pages/Index"
        })
      } else {
        prompt.showToast({
          message: res.msg,
          bottom: 400,
          duration: 2000,
        });
      }
    } catch (err) {
      this.loading = false
      console.log("异常：", JSON.stringify(err))
      prompt.showToast({
        message: "服务出现异常!",
        bottom: 400,
        duration: 2000,
      });
    }
  }

  build() {
    Column() {
      TopNav({ title: "", url: "pages/Index" })
      Column() {
        Text("我的信息").fontSize(30).textAlign(TextAlign.Start).fontWeight(200).width("100%")
        Text("基础资料")
          .fontSize(10)
          .fontColor(0x999999)
          .textAlign(TextAlign.Start)
          .width("100%")
          .margin({ top: 20, bottom: 15 })
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("头像").fontSize(16).fontWeight(800)
          Row() {
            Image("https://www.dillonl.com/u/snow.jpg").width(40).height(40).border({
              width: 1,
              color: 0xeeeeee,
              radius: 40,
            })
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }
        }.margin({ bottom: 30 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("昵称").fontSize(16).fontWeight(800)
          Row() {
            Text("书本书华").fontSize(14).fontColor(0x999999)
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }
        }.margin({ bottom: 30 })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("注册日期").fontSize(16).fontWeight(800)
          Row() {
            Text("注册日期").fontSize(14).fontColor(0x999999)
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }
        }.margin({ bottom: 30 })
        Column() {}.width("100%").height(1).backgroundColor(0xf2f2f2).margin({top:10,bottom:10})
        Text("详细资料").fontSize(10)
          .fontColor(0x999999)
          .textAlign(TextAlign.Start)
          .width("100%")
          .margin({ top: 20, bottom: 20 })
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("性别").fontSize(16).fontWeight(800)
          Select([
            { value: '男', icon: $r("app.media.man") },
            { value: '女', icon:  $r("app.media.woman") }
          ])
            .selected(2)
            .value('TTTTT')
            .font({ size: 16, weight: 500 })
            .fontColor(0x999999)
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number) => {
              console.info('Select:' + index)
            })
        }.margin({ bottom: 30 })
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("国家/地区").fontSize(16).fontWeight(800)
          Text("中国").fontSize(14).fontColor(0x999999)
        }

      }.width("90%")
    }
    .width("100%")
  }
}
