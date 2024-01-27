import router from '@ohos.router'
import request from '../utils/http'
import { ParamsInter, PageInter, WallItemInter } from '../interface/index'
import { base_url } from '../utils/env'
import { getRandomColor } from "../utils/tools"
import { toast } from '../component/ShowToast'


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
  scroller: SwiperController = new SwiperController()
  @State page: PageInter = { offset: 1, limit: 2, count: 0 }
  @State list: any = []
  @State currentItem: any = {}

  aboutToAppear() {
    let params: ParamsInter = router.getParams();
    this.getWallpaperDetail(params.id)
    // this.getWallpaper()
  }
  // 当前壁纸
  async getWallpaperDetail(id: string) {
    try {
      let api = `/api/wallpaper/app/detail_wallpaper/${id}`
      const res: any = await request.get(api)
      if (res.code === 200) {
        this.list = [res.data]
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      toast.error()
    }
  }
  // 壁纸列表
  async getWallpaper() {
    try {
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      if (res.code === 200) {
        this.page.count = res.data.count
        this.list = [...this.list, ...res.data.rows]
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

  onLock() {
    console.log("应用锁屏")
    // let downloadTask
    // try {
    //   request.downloadFile(getContext(this), {
    //     url: "http://192.168.2.102:800/s.jpg",
    //     // filePath: "/data/storage/el2/base/haps/entry/files/s.jpg",
    //     filePath: `${getContext(this).filesDir}/s.jpg`,
    //     networkType: request.NETWORK_WIFI,
    //     background: true
    //   }, (err, data) => {
    //     if (err) {
    //       console.error("下载错误", JSON.stringify(err))
    //       return
    //     }
    //     downloadTask = data
    //     let progresCallback = (receivedSize, totalSize) => {
    //       console.info("进度:" + receivedSize + " totalSize:" + totalSize);
    //     };
    //     downloadTask.on('progress', progresCallback);
    //     let failCallback = (err) => {
    //       console.info('监听下载失败:' + err);
    //
    //     };
    //     downloadTask.on('fail', failCallback);
    //     let completeCallback = () => {
    //       console.info('下载完成');
    //       let filePath = getContext(this).filesDir + "/s.jpg";
    //       wallpaper.setWallpaper(filePath, wallpaper.WallpaperType.WALLPAPER_SYSTEM, (error) => {
    //         if (error) {
    //           console.error(`错误: ${JSON.stringify(error)}`);
    //           return;
    //         }
    //         console.log(`成功`);
    //       });
    //       fs.access(filePath).then((res) => {
    //         if (res) {
    //           console.info("file exists",res);
    //         }else{
    //           console.log("读取",res)
    //         }
    //       }).catch((err) => {
    //         console.info("access failed with error message: " + err.message + ", error code: " + err.code);
    //       });
    //     };
    //     downloadTask.on('complete', completeCallback);
    //     let pauseCallback = () => {
    //       console.info('下载暂停');
    //       downloadTask.delete((err, result) => {
    //         if (err) {
    //           console.error('Failed to remove the download task.');
    //           return;
    //         }
    //         if (result) {
    //           console.info('Download task removed.');
    //         } else {
    //           console.error('Failed to remove the download task.');
    //         }
    //       });
    //     };
    //     downloadTask.on('pause', pauseCallback);
    //     let removeCallback = () => {
    //       console.info('下载移除');
    //     };
    //     downloadTask.on('remove', removeCallback);
    //     downloadTask.getTaskInfo((err, downloadInfo) => {
    //       if (err) {
    //         console.error('Failed to query the download mimeType. Cause:' + JSON.stringify(err));
    //       } else {
    //         console.info('下载信息:' + JSON.stringify(downloadInfo));
    //       }
    //     });
    //   })
    // } catch (err) {
    //   console.error('错误码 : ' + err.code + ', 错误信息 : ' + err.message);
    // }
  }

  onDesktop() {
    console.log("应用桌面")
  }

  onAll() {
    console.log("应用全部")
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.list.length > 0) {
        Swiper(this.scroller) {
          ForEach(this.list, (item: WallItemInter) => {
            Image(item.url_type == 0 ? base_url + item.url : item.url)
              .width("100%")
              .height("100%")
              .backgroundColor(getRandomColor())
          }, item => item)
        }
        .width("100%")
        .height("100%")
        .indicator(false)
        .backgroundColor(getRandomColor())
        .onChange((i: number) => {
          // this.currentItem = this.list[i];
        })
      }


      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image($r("app.media.close")).width("70px").height("70px")
      }
      .position({ x: "82%", y: '6%' })
      .width("120px")
      .height("120px")
      .backgroundColor(0x000000)
      .opacity(0.6)
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
    }.height("100%").width("100%")
  }
}