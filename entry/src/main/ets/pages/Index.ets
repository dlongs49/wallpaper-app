import router from '@ohos.router'
import wallpaper from '@ohos.wallpaper';
import prompt from '@ohos.prompt'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'
import Loading from '../component/Loading'
import HomeBar from './navbar/home_bar';
import SortBar from './navbar/sort_bar';
import MineBar from './navbar/mine_bar';
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
            HomeBar()
          }

        }.tabBar(this.TabBuilder(0, '首页'))

        TabContent() {
          SortBar()
        }.tabBar(this.TabBuilder(1, '分类'))

        TabContent() {
          MineBar()
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