import router from '@ohos.router'
import prompt from '@ohos.prompt'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav'

@Entry
@Component
struct MineWall {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: 0 }

  onPageShow() {
    this.getWallpaper()
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

  build() {
    Column() {
      TopNav({ title: "我的壁纸", url: "pages/Index" })
      Scroll(this.scroller) {
        Grid() {
          ForEach(this.list, (item: WallItemInter, idx: number) => {
            GridItem() {
              Stack() {
                Image(item.url_type == 0 ? base_url + item.url : item.url)
                  .width("100%")
                  .height(200)
                  .borderRadius(10)
                  .backgroundColor(0xffdbdbdb)

                Row() {
                  Text("锁屏 桌面").fontSize(10).fontColor(0xffffff)
                }
                .position({ y: 170, x: 10 })
                .backgroundColor(0x60000000)
                .opacity(0.9)
                .borderRadius(8)
                .padding({ left: 7, right: 7, top: 3, bottom: 3 })
              }.width("100%").onClick((e: ClickEvent) => {
                router.pushUrl({
                  url: "pages/SetWallpaper",
                  params: {
                    id: item.id
                  }
                })
              })
            }.width("33%").margin({ bottom: 18 })
          }, item => item)
        }
        .width('90%')
        .height('100%')
        .columnsTemplate("1fr 1fr 1fr")
        .columnsGap(12)
      }
    }.width('100%')
  }
}