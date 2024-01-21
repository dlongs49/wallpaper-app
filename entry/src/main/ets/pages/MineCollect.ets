import router from '@ohos.router'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { CollectWallInter, PageInter } from '../interface/index'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import NoData from '../component/NoData'
import { toast } from '../component/ShowToast'
import { hmRect, setBgColor } from '../utils/tools'
import emitter from '@ohos.events.emitter'
import observer from '@ohos.telephony.observer';
import connection from '@ohos.net.connection';

@Entry
@Component
struct MineCollect {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: 0 }
  @State show: boolean = false
  @State y: number = 80
  @State hmHeight: number = 0;
  @State loading: boolean = false

  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight
    this.watchNetWork()

  }

  onPageShow() {
    this.loading = true
    this.getWallpaper()
    var innerEvent = { eventId: 10000 }
    emitter.on(innerEvent, this.onEventHandel.bind(this))
  }

  watchNetWork() {
    observer.on('networkStateChange', data => {
      console.log("监听网络状态：" + JSON.stringify(data));
    });
    let netCon: connection.NetConnection = connection.createNetConnection();
    netCon.register((error) => {
      console.log("44444", JSON.stringify(error));
    });
    netCon.on('netAvailable', (data: connection.NetHandle) => {
      console.log("**********************", JSON.stringify(data));
    })
  }

  onEventHandel() {
  }
  // 我的收藏壁纸
  async getWallpaper() {
    try {
      let api = `/api/sign/app/get_collect_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.get(api)
      this.loading = false
      if (res.code === 200) {
        this.page.count = res.data.count
        this.list = setBgColor(res.data.rows).map(x => {
          let arr: string[] = new Date(x.create_time).toLocaleDateString().split("/")
          // 处理时间
          return { ...x, create_time: `${arr[2]}/${arr[0]}/${arr[1]}` }
        })
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      this.loading = false
      toast.error()
    }
  }
  // 删除收藏的壁纸项
  async handleDelete() {
    try {
      const ids = this.list.filter(x => x.is_checked).map(x => x.id)
      if (ids.length === 0) {
        return
      }
      this.loading = true
      const res: any = await request.post("/api/sign/app/del_collect_wallpaper", ids)
      this.loading = false
      if (res.code === 200) {
        this.list = this.list.filter(x =>!x.is_checked)
        this.show = false
        this.y = 0
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      this.loading = false
      toast.error()
    }
  }

  build() {
    Column() {

      TopNav({ title: "我的收藏", url: "pages/Index" })
      if (this.list.length === 0) {
        NoData({ type: "page", state: 0, })
      }
      Scroll(this.scroller) {
        Grid() {
          ForEach(this.list, (item: CollectWallInter, idx: number) => {
            GridItem() {
              Column() {
                Stack() {
                  Column() {
                    Image(item.wallpaper_type == 0 ? base_url + item.wallpaper_url : item.wallpaper_url)
                      .width("100%")
                      .height(200)
                      .borderRadius(10)
                      .backgroundColor(item.color)
                    Text(item.create_time).fontSize(10).margin({ top: 5, right: 5 }).fontColor(0x585858)
                  }.alignItems(HorizontalAlign.End)

                  if (this.show) {
                    Checkbox({ name: item.id, group: 'checkIds', })
                      .select(item.is_checked)
                      .selectedColor(0x027eff)
                      .position({ x: '74%', y: 170 })
                      .onChange((value: boolean) => {
                        // 选中当前项更改选中状态
                        this.list[idx].is_checked = value
                        let flag = this.list.find(x => x.is_checked)
                        if (!flag) {
                          this.y = 80
                          this.show = false
                        }
                      })
                  }
                }.gesture(
                  LongPressGesture({ repeat: true, duration: 200 })
                    .onAction((event: GestureEvent) => {
                      if (event.repeat) {
                        // 长按选中当前这一项 使其删除控件出现 更改 y 执行动画
                        this.list[idx].is_checked = true
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
      .height(!this.show ? this.hmHeight - 300 + 'px' : (this.hmHeight - 570) + 'px')
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
          this.handleDelete()

        })
      }.backgroundColor(0xf5f5f5).height("270px").translate({ y: this.y }).animation({
        duration: 200,
      })

      if (this.loading) {
        Loading()
      }
    }.width('100%')
  }
}