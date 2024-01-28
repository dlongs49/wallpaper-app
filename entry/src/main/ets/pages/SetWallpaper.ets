import router from '@ohos.router'
import use_request from '@ohos.request';
import request from '../utils/http'
import { ParamsInter } from '../interface/index'
import { base_url } from '../utils/env'
import { getRandomColor } from "../utils/tools"
import { toast } from '../component/ShowToast'
import Loading from '../component/Loading'
import wallpaper from '@ohos.wallpaper';


@CustomDialog
struct CustomDialogComm {
  controller: CustomDialogController
  onLock: () => void
  onDesktop: () => void
  onAll: () => void

  build() {
    Column() {
      Button({ type: ButtonType.Normal }) {
        Text("应用锁屏").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(() => {
        this.onLock()
      })

      Button({ type: ButtonType.Normal }) {
        Text("应用桌面").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(() => {
        this.onDesktop()
      })

      Button({ type: ButtonType.Normal }) {
        Text("应用全部").fontColor(0x000000).width("90%")
      }.width("100%").height(50).backgroundColor(0xffffff).onClick(() => {
        this.onAll()
      })

      Button('取消', { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(0xeeeeee)
        .width("90%")
        .height(44)
        .margin({ top: 15 })
        .fontColor(0x000000)
        .onClick(() => {
          this.controller.close()
        })
    }.backgroundColor(0xffffff).borderRadius(14).padding({ top: 25, bottom: 20 }).width("90%")
  }
}

@Entry
@Component
struct SetWallpaper {
  @State currentItem: any = { is_like: 0 }
  @State loading: boolean = false

  aboutToAppear() {
    let params: ParamsInter = router.getParams();
    this.getWallpaperDetail(params.id)
  }
  // 当前壁纸
  async getWallpaperDetail(id: string) {
    try {
      this.loading = true
      let api = `/api/wallpaper/app/detail_wallpaper/${id}`
      const res: any = await request.get(api)
      if (res.code === 200) {
        this.currentItem = res.data
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      toast.error()
    }
  }
  // 收藏
  async handleCollect() {
    try {
      const res: any = await request.post(`/api/sign/app/collect_wallpaper?wallpaper_id=${this.currentItem.id}`)
      if (res.code === 200) {
        this.currentItem.is_like = this.currentItem.is_like == 0 ? 1 : 0
        toast.error(res.msg)
      }

    } catch (err) {
      toast.error()
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogComm({
      onLock: this.onLock,
      onDesktop: this.onDesktop,
      onAll: this.onAll
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    autoCancel: true,
    customStyle: true
  })
  // 锁屏
  onLock() {
    this.setWallpaperApplication(1)
  }
  // 主屏幕
  onDesktop() {
    this.setWallpaperApplication(0)
  }
 // 全部
  onAll() {
    this.setWallpaperApplication(2)
  }
  // 设置壁纸
  async setWallpaperApplication(type) {
    try {
      let file_name = this.currentItem.url.slice(this.currentItem.url.lastIndexOf('/'), this.currentItem.url.length)
      let filePath = getContext(this).filesDir + file_name
      let downloadTask = await use_request.downloadFile(getContext(this), {
        url: this.currentItem.url_type == 0 ? base_url + this.currentItem.url : this.currentItem.url,
        filePath,
      })
      let progresCallback = (receivedSize, totalSize) => {
        console.info("下载壁纸进度:" + receivedSize + " totalSize:" + totalSize);
      };
      downloadTask.on('progress', progresCallback);
      let failCallback = (err) => {
        console.info('下载壁纸失败:', JSON.stringify(err));

      };
      downloadTask.on('fail', failCallback);
      let completeCallback = () => {
        if(type === 0){
          wallpaper.setWallpaper(filePath, wallpaper.WallpaperType.WALLPAPER_SYSTEM, (error) => {
            if (error) {
              console.error(`设置主屏壁纸错误: ${JSON.stringify(error)}`);
              return;
            }
            console.log("设置主屏壁纸成功");
          });
        }
        if(type === 1){
          wallpaper.setWallpaper(filePath, wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN, (error) => {
            if (error) {
              console.error(`设置锁屏壁纸错误: ${JSON.stringify(error)}`);
              return;
            }
            console.log("设置锁屏壁纸成功");
          });
        }
        if(type === 2){
          wallpaper.setWallpaper(filePath, wallpaper.WallpaperType.WALLPAPER_SYSTEM, (error) => {
            if (error) {
              console.error(`设置主屏壁纸错误: ${JSON.stringify(error)}`);
              return;
            }
            console.log("设置主屏壁纸成功");
          });
          wallpaper.setWallpaper(filePath, wallpaper.WallpaperType.WALLPAPER_LOCKSCREEN, (error) => {
            if (error) {
              console.error(`设置锁屏壁纸错误: ${JSON.stringify(error)}`);
              return;
            }
            console.log("设置锁屏壁纸成功");
          });
        }
      };
      downloadTask.on('complete', completeCallback);
      let pauseCallback = () => {
        console.info('下载壁纸暂停');
      };
      downloadTask.on('pause', pauseCallback);
      downloadTask.getTaskInfo((err, downloadInfo) => {
        if (err) {
          console.error('下载信息[error]:', JSON.stringify(err));
        } else {
          console.info('下载信息[info]:', JSON.stringify(downloadInfo));
        }
      });
    } catch (err) {
      console.error("downloadTask异常：", JSON.stringify(err));
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image(this.currentItem.url_type == 0 ? base_url + this.currentItem.url : this.currentItem.url)
        .width("100%")
        .height("100%")
        .backgroundColor(getRandomColor())
        .onComplete(() => {
          this.loading = false
        })

      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image($r("app.media.close")).width("70px").height("70px")
      }
      .position({ x: "82%", y: '6%' })
      .width("120px")
      .height("120px")
      .backgroundColor(0x000000)
      .opacity(0.4)
      .borderRadius(100)
      .onClick(() => {
        router.back({ url: 'pages/Index' });
      })

      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Image(this.currentItem.is_like === 0 ? $r("app.media.love_white") : $r("app.media.love_red"))
            .width(20)
            .height(20)
            .margin({ right: 20 })
        }.width(40).height(40).onClick(() => {
          this.handleCollect()
        })

        Button('应用壁纸', { type: ButtonType.Capsule, stateEffect: true })
          .backgroundColor(0xffffff)
          .width("80%")
          .fontColor(0x000000)
          .onClick(() => {
            if (this.dialogController != undefined) {
              this.dialogController.open()
            }
          })
      }.position({ y: "92%", x: '5%' }).width("90%")

      if (this.loading) {
        Loading()
      }
    }.height("100%").width("100%")
  }
}