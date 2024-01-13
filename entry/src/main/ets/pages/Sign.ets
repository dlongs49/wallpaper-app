import router from '@ohos.router'
import http from '@ohos.net.http';
import prompt from '@ohos.prompt'
import hilog from '@ohos.hilog';
import { SignInter, SignResInter } from '../interface/index'
import request from '../utils/http'
import UIAbility from '@ohos.app.ability.UIAbility';
@Entry
@Component
struct Sign {
  controller: TextInputController = new TextInputController()
  @State form: SignInter = {
    uname: "string",
    password: "string"
  }

  onPageShow() {}

  async sign_in() {
    try {
      const res: any = await request.post("/api/sign/reg_login", this.form)
      if (res.code === 200) {
        try {
          let promise = preferences.put('startup', 'auto');
          promise.then(() => {
            console.info("Succeeded in putting value of 'startup'.");
          }).catch((err) => {
            console.error("Failed to put value of 'startup'. code =" + err.code +", message =" + err.message);
          })
        } catch(err) {
          console.error("Failedsdd to put value of 'startup'. code =" + err.code +", message =" + err.message);
        }
      } else {
        prompt.showToast({
          message: res.msg,
          bottom: 400,
          duration: 2000,
        });
      }
    } catch (err) {
      console.log("异常：",JSON.stringify(err))
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
        .height(42)
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
        .height(42)
        .backgroundColor(0xffffff)
        .borderRadius(12)
        .borderWidth(2)
        .margin({ top: 20 })
        .borderColor(0xa794ff)

        Button('登录/注册', { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0xa99ee9)
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
