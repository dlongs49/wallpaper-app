import router from '@ohos.router'
import wallpaper from '@ohos.wallpaper';
import request from '@ohos.request';
import requests from '@system.request';
import document from '@ohos.document';
import { OpearInter } from '../interface/index'
@Entry
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @State list: Array<string> = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '',]
  @State opearList: Array<OpearInter> = [
    { icon: $r("app.media.order"), title: "我的壁纸" },
    { icon: $r("app.media.love"), title: "我的收藏" },
    { icon: $r("app.media.about"), title: "关于壁纸" },
  ]
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()

  @Builder NavigationTitle() {
    Column() {
    }.backgroundColor(this.currentIndex == 2 ? 0xe9e5fb : '').height(52).width("100%")
  }

  @Builder TabBuilder(index: number, title: string) {
    Column() {
      Image(this.currentIndex === index ? `../resources/base/media/${index}_.svg` : `../resources/base/media/${index}.svg`)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(10)
        .fontWeight(500)
        .lineHeight(14)
    }.width('100%')
  }

  build() {
    Navigation() {
      this.NavigationTitle()
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          if (this.currentIndex == 0) {
            WaterFlow({ scroller: this.scroller }) {
              ForEach(this.list, (item: string, idx: number) => {
                FlowItem() {
                  Column() {
                    if (idx === 0) {
                      Row() {
                        Image("https://www.dillonl.com/u/demo.png").width(110).height(50).borderRadius(10)
                        Text("热门IP壁纸").offset({ x: -90, y: 2 }).fontColor(0xffffff)
                      }.width(110).height(50).margin({ bottom: 14 })
                    }
                    Column() {
                      Image("https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg?auto=compress&cs=tinysrgb&w=600")
                        .width("100%")
                        .height(320)
                        .borderRadius(10)
                        .backgroundColor(0xffdbdbdb)
                      Text("自然风光").fontSize(14).margin({ top: '5' })
                      Text("9张").fontSize(12).fontColor(0xffcccccc).margin({ top: 5 })
                    }.width("100%").alignItems(HorizontalAlign.Start).onClick((e: ClickEvent) => {
                      router.pushUrl({
                        url:"pages/SetWallpaper",
                        params:{}
                      }).then().catch(err=>{
                        console.error("路由跳转错误："+JSON.stringify(err))
                      })
                      // let  downloadTask
                      // try {
                      //   request.downloadFile(getContext(this), {
                      //     url: "http://localhost:8000/s.jpg",
                      //     filePath: "/data/storage/el2/base/haps/entry/files/s.jpg",
                      //     // filePath: `${getContext(this).filesDir}/s.jpg`,
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
                      //     };
                      //     downloadTask.on('complete', completeCallback);
                      //     let pauseCallback = () => {
                      //       console.info('下载暂停');
                      //       downloadTask.delete((err, result)=>{
                      //         if(err) {
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
                      // let wallpaperPath = "/data/storage/el2/base/haps/entry/files/Cup_ic.jpg";
                      // wallpaper.setWallpaper(wallpaperPath, wallpaper.WallpaperType.WALLPAPER_SYSTEM, (error) => {
                      //   if (error) {
                      //     console.error(`错误: ${JSON.stringify(error)}`);
                      //     return;
                      //   }
                      //   console.log(`成功`);
                      // });
                    })
                  }.alignItems(HorizontalAlign.Start)
                }.width("50%").margin({ bottom: 18 })

              }, item => item)

            }
            .width('95%')
            .height('100%')
            .layoutDirection(FlexDirection.Column)
            .columnsTemplate("1fr 1fr")
            .columnsGap(12)
          }

        }.tabBar(this.TabBuilder(0, '首页'))

        TabContent() {
          Scroll(this.home_scroller) {
            Grid() {
              ForEach(this.list, (item) => {
                GridItem() {
                  Stack({ alignContent: Alignment.TopStart }) {
                    Image("https://www.dillonl.com/u/demo.png").borderRadius(12).width('100%')
                    Text("中国风").fontColor(0xffffffff).fontSize(18).markAnchor({ x: -14, y: -20 })
                  }.width('48.5%')
                }
              })

            }.columnsTemplate("lfr lfr").columnsGap(10).rowsGap(10).width("94%")
          }.width("100%").scrollBar(BarState.Off)
        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {
          Column() {
            Flex({
              direction: FlexDirection.Column,
              justifyContent: FlexAlign.Center,
              alignItems: ItemAlign.Center
            }) {
              Image("https://www.dillonl.com/u/demo.png")
                .width(60)
                .height(60)
                .borderRadius(60)
                .backgroundColor(0xfff4f4f4)
              Text("冰消叶散").fontWeight(FontWeight.Bold).fontSize(18).margin({ top: 10 })
            }.height(100).margin({ top: 50 })

            List() {
              ForEach(this.opearList, (item) => {
                ListItem() {
                  Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                    Row() {
                      Image(item.icon).width(20).height(20)
                      Text(`${item.title}`).fontSize(14).margin({ left: 14 })
                    }

                    Image($r("app.media.arrow")).width(20).height(20)
                  }
                }.margin({ bottom: 30 })
              })

            }.width("90%").margin({ top: 50 })

            Button('退出登录', { type: ButtonType.Capsule, stateEffect: true }).backgroundColor(0xa99ee9).width("90%")
          }.justifyContent(FlexAlign.Start).height("100%").width("100%").linearGradient({
            direction: GradientDirection.Top,
            angle: 180,
            colors: [[0xe9e5fb, 0.0], [0xffffff, 0.5], [0xffffff, 1.0]]
          })
        }.tabBar(this.TabBuilder(2, '我的'))
      }
      .vertical(false)
      .barHeight(56)
      .onChange((index: number) => {
        if (index === 0) {
          this.selectedFontColor = '#e6dd23'
        } else if (index === 1) {
          this.selectedFontColor = '#a99ee9'
        } else {
          this.selectedFontColor = '#ea569f'
        }
        this.currentIndex = index
      })
      .width('100%')
      .height('94%')
    }.width('100%').height('100%').hideTitleBar(true)
  }
}