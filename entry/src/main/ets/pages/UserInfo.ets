import picker from '@ohos.file.picker';
import uploadRequest from '@ohos.request';
import fs from '@ohos.file.fs';
import { SignInter, UinfoInter } from '../interface/index'
import request from '../utils/http'
import storage from '../utils/storage'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import { toast } from '../component/ShowToast'
import { touchBgColor } from '../utils/tools'
import { base_url } from '../utils/env';


@CustomDialog
struct DialogEditUname {
  @Link uname: string
  inputController: TextInputController = new TextInputController()
  controller: CustomDialogController
  onCancel: () => void
  onSubmit: () => void

  build() {
    Column() {
      Text("编辑昵称").fontSize(18)
      Column() {
        TextInput({ text: this.uname, controller: this.inputController })
          .placeholderFont({ size: 14, weight: 400 })
          .caretColor(0xa794ff)
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
          .onChange((value: any) => {
            this.uname = value;
          })
      }
      .width("90%")
      .height(48)
      .backgroundColor(0xffffff)
      .borderRadius(12)
      .borderWidth(2)
      .margin({ top: 20, bottom: 20 })
      .borderColor(0xa794ff)

      Flex({ justifyContent: FlexAlign.Center }) {
        Button('取消', { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0xeeeeee)
          .width("40%")
          .height(44)
          .fontColor(0x000000)
          .onClick(() => {
            this.controller.close()
          })
        Button('确定', { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0xa794ff)
          .width("40%")
          .height(44)
          .margin({ left: 15 })
          .fontColor(0xffffff)
          .onClick(async () => {
            try {
              const res: any = await request.post("/api/sign/put_user", { uname: this.uname })
              if (res.code === 200) {
              } else {
                toast.error(res.msg)
              }
            } catch (err) {
              toast.error()
            }
            this.onSubmit()

          })
      }.margin({ top: 10 })

    }.backgroundColor(0xffffff).borderRadius(14).padding({ top: 25, bottom: 20 }).width("90%")
  }
}


@Entry
@Component
struct UserInfo {
  controller: TextInputController = new TextInputController()
  @State uname: string = ""
  @State sex_tit: string = "男"
  @State sex: string = "1"
  @State touchBgColor_1: number = 0xffffff
  @State touchBgColor_2: number = 0xffffff
  @State touchBgColor_3: number = 0xffffff
  @State touchBgColor_4: number = 0xffffff
  @State touchBgColor_5: number = 0xffffff
  @State loading: boolean = false
  @State info: UinfoInter = {
    avatar: "",
    sex_tit: "",
    uname: ""
  }

  onPageShow() {
    this.getUserInfo()
  }

  onCancel() {
    this.dialogController.close()
  }

  onSubmit() {
    this.dialogController.close()
    this.info.uname = this.uname
  }
  // 打开相册
  async selectImage() {
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1
      const photoPicker = new picker.PhotoViewPicker();
      const result = await photoPicker.select(PhotoSelectOptions)
      this.uploadAvatar(result)
      console.log("选择的图片文件：", JSON.stringify(result))
    } catch (e) {
      console.log("打开相册错误：", JSON.stringify(e))
    }
  }
  // 上传头像
  async uploadAvatar(data: any) {
    try {
      const file = fs.openSync(data.photoUris[0], fs.OpenMode.READ_ONLY)
      const spm = new Date().getTime().toString()
      const dstPath = getContext(this).cacheDir + "/" + spm + '.png'
      fs.copyFileSync(file.fd, dstPath);
      let uri = "internal://cache/" + dstPath.split("cache/")[1];
      console.log("***********", dstPath, uri)
      const uploadTask = await uploadRequest.uploadFile(getContext(this), {
        url: base_url + '/api/upload/avatar',
        header: { 'Accept': '*/*' },
        method: "POST",
        files: [{ filename: `${spm}.png`, name: "avatar", uri, type: 'image/png' }],
        data: []
      })
      uploadTask.on("complete", (data) => {
        this.getAvatarPath(data[0].path)
      })
    } catch (e) {
      console.log("上传图片异常：", JSON.stringify(e))
    }
  }
  // 获取上传的头像路径
  async getAvatarPath(file_name) {
    try {
      const res: any = await request.get(`/api/upload/path?file_name=${file_name}`)
      if (res.code === 200) {
        this.updateUserInfo({ avatar: res.data.file_path })
      } else {
        toast.error("未找到该头像资源")
      }
    } catch (e) {
      toast.error()
    }
  }
  //个人信息
  async getUserInfo() {
    try {
      const res: any = await request.get("/api/sign/get_user")
      if (res.code === 200) {
        this.info = res.data
        let dateStr: string[] = new Date(res.data.reg_time).toLocaleDateString().split("/")
        this.info.reg_time = `${dateStr[2]}-${dateStr[0]}-${dateStr[1]}`
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      toast.error()
    }
  }
  // 更新用户信息
  async updateUserInfo(params) {
    try {
      const res: any = await request.post("/api/sign/put_user", params)
      if (res.code === 200) {
        if (params.uname) {
          this.info.uname = this.uname
          this.dialogController.close()
        }
        if (params.sex) {
          this.info.sex_tit = this.sex_tit
        }
        if (params.avatar) {
          this.info.avatar = params.avatar
        }
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      toast.error()
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DialogEditUname({
      onCancel: this.onCancel,
      onSubmit: this.onSubmit,
      uname: $uname,
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -40 },
    autoCancel: true,
    customStyle: true
  })

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
            Image(this.info.avatar ? base_url + this.info.avatar : $r('app.media.user')).width(40).height(40).border({
              width: 1,
              color: 0xeeeeee,
              radius: 40,
            })
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })
        }.width("100%").height(60).backgroundColor(this.touchBgColor_1).onTouch((event) => {
          this.touchBgColor_1 = touchBgColor(event)
          this.selectImage()
        })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("昵称")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Text(this.info.uname).fontSize(14).fontColor(0x999999)
            Image($r("app.media.arrow")).width(20).height(25).fillColor(0xcccccc)
          }.height("100%").width("70%").justifyContent(FlexAlign.End).margin({ right: 25 })
        }
        .width("100%")
        .height(60)
        .backgroundColor(this.touchBgColor_2)
        .onTouch((event) => {
          this.touchBgColor_2 = touchBgColor(event)
        })
        .onClick(() => {
          if (this.dialogController != undefined) {
            this.uname = this.info.uname
            this.dialogController.open()
          }
        })

        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text("注册日期")
            .fontSize(16)
            .fontWeight(800)
            .margin({ left: 20 })
            .height("100%")
            .lineHeight(26)
          Row() {
            Text(this.info.reg_time).fontSize(14).fontColor(0x999999)
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
              { value: '女', icon: $r("app.media.woman") },
              { value: '男', icon: $r("app.media.man") },
            ])
              .value(this.info.sex_tit)
              .font({ size: 16, weight: 500 })
              .fontColor(0x999999)
              .optionFont({ size: 16, weight: 400 })
              .onSelect((index: number) => {
                this.sex_tit = index == 1 ? "男" : "女"
                this.sex = index == 1 ? "1" : "0"
                this.updateUserInfo({ sex: this.sex, sex_tit: this.sex_tit })
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
          Text(this.info.nation)
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
