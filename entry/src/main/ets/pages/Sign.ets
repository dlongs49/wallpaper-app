import router from '@ohos.router'
import prompt from '@ohos.prompt'
import { SignInter } from '../interface/index'
import request from '../utils/http'
import storage from '../utils/storage'

@Entry
@Component
struct Sign {
  controller: TextInputController = new TextInputController()
  @State form: SignInter = {
    uname: "string",
    password: "string"
  }
  @State loading:boolean = false
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
          url:"pages/Index"
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

  @Builder NavigationTitle() {
    Column() {
    }.backgroundColor(0xe9e5fb).height(52).width("100%")
  }

  build() {
    Navigation() {
      this.NavigationTitle()
      Column() {
        Column() {
        }
        .height(200)
        .width("100%")
        .margin({ left: 10, right: 10, bottom: 70 })
        .backgroundColor(0xffffff)
        .borderRadius({
          bottomLeft: 60,
          bottomRight: 60
        })

        Column() {
          TextInput({ text: this.form.uname, placeholder: '请输入账号', controller: this.controller })
            .placeholderFont({ size: 14, weight: 400 })
            .caretColor(0xa794ff)
            .width('100%')
            .height('100%')
            .fontSize(14)
            .fontColor(0x000000)
            .fontWeight(500)
            .backgroundColor(0xffffff)
            .stateStyles({
              pressed: {
                .backgroundColor(Color.Transparent)
              }
            })
            .onChange((value: string) => {
              this.form.uname = value
            })
        }
        .width("90%")
        .height(48)
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .borderWidth(2)
        .borderColor(0xa794ff)

        Column() {
          TextInput({ text: this.form.password, placeholder: '请输入密码', controller: this.controller })
            .placeholderFont({ size: 14, weight: 400 })
            .caretColor(0xa794ff)
            .type(InputType.Password)
            .showPasswordIcon(false)
            .width('100%')
            .height('100%')
            .fontSize(14)
            .fontColor(0x000000)
            .fontWeight(500)
            .backgroundColor(0xffffff)
            .stateStyles({
              pressed: {
                .backgroundColor(Color.Transparent)
              }
            })
            .onChange((value: string) => {
              this.form.password = value
            })
        }
        .width("90%")
        .height(48)
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .borderWidth(2)
        .margin({ top: 20 })
        .borderColor(0xa794ff)

        Button('登录/注册', { type: ButtonType.Capsule, stateEffect: true }){
          Row() {
            if(this.loading){
              LoadingProgress().width(24).height(24).margin({ left: 12 }).color(0xFFFFFF)
            }
            Text('登录/注册').fontSize(16).fontColor(0xffffff).margin({ left: 5 })
          }.alignItems(VerticalAlign.Center).height(46)
        }
        .backgroundColor(0xa794ff)
        .width("90%")
        .margin({ top: 40 })
      }
      .justifyContent(FlexAlign.Start)
      .height("100%")
      .width("100%")
      .linearGradient({
        direction: GradientDirection.Top,
        angle: 180,
        colors: [[0xe9e5fb, 0.0], [0xffffff, 0.5], [0xffffff, 1.0]]
      })
      .onClick(() => {
        this.sign_in()
      })
    }.width('100%').height('100%').hideTitleBar(true)
  }
}
