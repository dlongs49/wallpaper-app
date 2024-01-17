import router from '@ohos.router'
import prompt from '@ohos.prompt'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav'

@Entry
@Component
struct MineCollect {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  home_scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: 0 }
  @State show: boolean = false
  @State y: number = 30

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
      TopNav({ title: "我的收藏", url: "pages/Index" })

      Scroll(this.scroller) {
        Grid() {
          ForEach(this.list, (item: WallItemInter, idx: number) => {
            GridItem() {
              Column() {
                Stack() {
                  Column() {
                    Image(item.url_type == 0 ? base_url + item.url : item.url)
                      .width("100%")
                      .height(200)
                      .borderRadius(10)
                      .backgroundColor(0xffdbdbdb)
                    Text("2023/10/12").fontSize(10).margin({ top: 5, right: 5 }).fontColor(0x585858)
                  }.alignItems(HorizontalAlign.End)

                  if (this.show) {
                    Checkbox({ name: 'checkbox1', group: 'checkboxGroup', })
                      .select(true)
                      .selectedColor(0x027eff)
                      .position({ x: '74%', y: '20%' })
                      .onChange((value: boolean) => {
                        console.info('Checkbox1 change is' + value)
                      })
                  }
                }.gesture(
                  LongPressGesture({ repeat: true, duration: 200 })
                    .onAction((event: GestureEvent) => {
                      if (event.repeat) {
                        this.show = true
                        this.y = 0
                      }
                    })
                    .onActionEnd(() => {
                      console.log("145")
                    })
                )
              }.width("100%").alignItems(HorizontalAlign.End).onClick((e: ClickEvent) => {
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
      }.height(this.show ? '80%' : '90%')

      // if (this.show) {
        Flex({ justifyContent: FlexAlign.Center }) {
          Column() {
            Image($r('app.media.delete')).width(20).height(20)
            Text("删除").fontSize(12).margin({ top: 5 })
          }
          .width("100%")
          .width(40)
          .margin({ top: 20 })
        }.backgroundColor(0xf5f5f5).translate({ y: this.y }).animation({
          duration: 200,
        })
      // }
    }.width('100%')
  }
}