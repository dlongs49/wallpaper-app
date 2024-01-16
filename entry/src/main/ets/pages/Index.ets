import router from '@ohos.router'
import wallpaper from '@ohos.wallpaper';
import prompt from '@ohos.prompt'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'

@Entry
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @State list: Array<any> = []
  @State opearList: Array<OpearInter> = [
    { icon: $r("app.media.order"), title: "我的壁纸",url:"pages/MineWall" },
    { icon: $r("app.media.love"), title: "我的收藏",url:"pages/MineCollect" },
    { icon: $r("app.media.about"), title: "关于壁纸",url:"pages/AboutUs" },
  ]
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: 0 }
  @State info: UinfoInter = {
    avatar: "",
    uname: ""
  }
  @State typeList: any = []

  onPageShow() {
    this.getWallpaper()
    this.getUserInfo()
    this.getWallpaperType()
  }
  // 壁纸
  async getWallpaper() {
    try {
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      if (res.code === 200) {
        this.page.count = res.data.count
        this.list = res.data.rows
      } else {
        prompt.showToast({
          message: res.msg,
          bottom: 400,
          duration: 2000,
        });
      }
    } catch (err) {
      prompt.showToast({
        message: "服务出现异常!",
        bottom: 400,
        duration: 2000,
      });
    }
  }
  //个人信息
  async getUserInfo() {
    try {
      const res: any = await request.get("/api/sign/get_user")
      if (res.code === 200) {
        this.info = res.data
        console.log("***", JSON.stringify(this.info))
      } else {
        this.info = {
          avatar: "",
          uname: ""
        }
      }
    } catch (err) {
      prompt.showToast({
        message: "服务出现异常!",
        bottom: 400,
        duration: 2000,
      });
    }
  }
  // 壁纸分类
  async getWallpaperType() {
    try {
      let api = `/api/wallpaper/app/get_wallpaper_type?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      if (res.code === 200) {
        this.page.count = res.data.count
        this.typeList = res.data.rows
      } else {
        prompt.showToast({
          message: res.msg,
          bottom: 400,
          duration: 2000,
        });
      }
    } catch (err) {
      prompt.showToast({
        message: "服务出现异常!",
        bottom: 400,
        duration: 2000,
      });
    }
  }
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
              ForEach(this.list, (item: WallItemInter, idx: number) => {
                FlowItem() {
                  Column() {
                    if (idx === 0) {
                      Row() {
                        Image("https://www.dillonl.com/u/demo.png").width('100%').height(50).borderRadius(10)
                        Text("热门IP壁纸").offset({ x: -130, y: 2 }).fontColor(0xffffff)
                      }.width('100%').height(50).margin({ bottom: 14 })
                    }
                    Column() {
                      Image(item.url_type == 0 ? base_url + item.url : item.url)
                        .width("100%")
                        .height(320)
                        .borderRadius(10)
                        .backgroundColor(0xffdbdbdb)
                      Text(item.title).fontSize(14).margin({ top: '5' })
                    }.width("100%").alignItems(HorizontalAlign.Start).onClick((e: ClickEvent) => {
                      router.pushUrl({
                        url: "pages/SetWallpaper",
                        params: {
                          id: item.id
                        }
                      })
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
              ForEach(this.typeList, (item:any) => {
                GridItem() {
                  Stack({ alignContent: Alignment.TopStart }) {
                    Image(item.cover_type === 0 ? base_url + item.cover_url : item.cover_url).borderRadius(12).width('100%')
                    Text(item.title).fontColor(0xffffffff).fontSize(18).markAnchor({ x: -14, y: -20 })
                  }.width('48.5%')
                }.onClick(()=>{
                  router.pushUrl({
                    url:"pages/Wallpaper",
                    params:{
                      id:item.id
                    }
                  })
                })
              })
            }
            .columnsTemplate("lfr lfr")
            .columnsGap(10)
            .rowsGap(10)
            .layoutDirection(GridDirection.Row)
            .width("94%")
          }.width("100%").scrollBar(BarState.Off).height('100%')
        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {
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
              ForEach(this.opearList, (item) => {
                ListItem() {
                  Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                    Row() {
                      Image(item.icon).width(20).height(20)
                      Text(`${item.title}`).fontSize(14).margin({ left: 14 })
                    }

                    Image($r("app.media.arrow")).width(20).height(20)
                  }
                }.margin({ bottom: 30 }).onClick(() => {
                  router.pushUrl({ url: item.url})
                })
              })

            }.width("90%").margin({ top: 50 })

            if (this.info.id) {
              Button('退出登录', { type: ButtonType.Capsule, stateEffect: true }).backgroundColor(0xa99ee9).width("90%")
            }
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