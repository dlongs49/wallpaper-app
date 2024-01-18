import router from '@ohos.router'
import prompt from '@ohos.prompt'
import window from '@ohos.window'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { OpearInter, PageInter, UinfoInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
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
  @State y: number = 80
  @State wwidth: number = 0;
  @State wheight: number = 0;
  @State loading:boolean = false
  async aboutToAppear() {
    let win = await window.getLastWindow(getContext(this))
    let area: any = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    console.log(area.bottomRect.height);
    console.log(JSON.stringify(area));
    this.wwidth = area.bottomRect.width;
    this.wheight = area.bottomRect.top;
  }

  onPageShow() {
    this.loading = true
    this.getWallpaper()
  }
  // 壁纸
  async getWallpaper() {
    try {
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      setTimeout(()=>{
        this.loading = false
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
      },2000)

    } catch (err) {
      this.loading = false
      prompt.showToast({
        message: "服务出现异常!",
        bottom: 400,
        duration: 2000,
      });
    }
  }

  handleTopNav(data) {
    console.log("****", data)
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
                    Checkbox({ name: item.id, group: 'deleteIds', })
                      .select(true)
                      .selectedColor(0x027eff)
                      .position({ x: '74%', y: 170 })
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
      }
      .height(!this.show ? this.wheight - 300 + 'px' : (this.wheight - 570) + 'px')
      .edgeEffect(EdgeEffect.Spring)
      .onScrollEdge(() => {
        console.log("564654654646546465464")
      })
      .onScroll((xOffset: number, yOffset: number) => {
        console.info(xOffset + ' ' + yOffset)
      })
      .onScrollEdge((side: Edge) => {
        console.info('To the edge')
      })
      .onScrollEnd(() => {
        console.info('Scroll Stop')
      })

      Flex({ justifyContent: FlexAlign.Center }) {
        Column() {
          Image($r('app.media.delete')).width(20).height(20)
          Text("删除").fontSize(12).margin({ top: 5 })
        }
        .width("100%")
        .width(40)
        .margin({ top: 15 })
        .onClick(() => {
          this.show = false
          this.y = 0
        })
      }.backgroundColor(0xf5f5f5).height("270px").translate({ y: this.y }).animation({
        duration: 200,
      })
      if(this.loading){
        Loading()
      }
    }.width('100%')
  }
}