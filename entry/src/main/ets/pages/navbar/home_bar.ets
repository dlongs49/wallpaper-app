import router from '@ohos.router'
import { PageInter, WallItemInter } from '../../interface/index'
import { base_url } from '../../utils/env'
import request from '../../utils/http'
import { hmRect, setBgColor, connectNet } from '../../utils/tools'
import { toast } from '../../component/ShowToast'
import Loading from '../../component/Loading'
import NoData from '../../component/NoData'
import connection from '@ohos.net.connection'
import emitter from '@ohos.events.emitter'

@Component
export default struct HomeBar {
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 6, count: -1 }
  @State list: any = []
  @State loading: boolean = false
  @State hmHeight: string = "90%";
  @State state: number = 0

  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight - 300 + 'px'
    this.watchConnect()
    let innerEvent = { eventId: 10000 }
    emitter.on(innerEvent, this.onEventHandel.bind(this))
  }

  async watchConnect() {
    this.loading = true
    // 监听网络连接状态 模拟器无效  真机正常
    const state = await connectNet()
    this.state = state
    if (state === -1) {
      this.loading = false
    }
    if (state != -1) {
      this.getWallpaper()
    }
  }
  // 重新加载数据事件
  onEventHandel() {
    this.watchConnect()
  }
  // 壁纸
  async getWallpaper() {
    try {
      this.loading = true
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      this.loading = false
      if (res.code === 200) {
        this.page.count = res.data.count
        const rows = setBgColor(res.data.rows)
        this.list = [...this.list, ...rows]
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
      if (this.page.count === 0 || this.state === -1) {
        NoData({ type: "page", state: this.state, })
      }
      WaterFlow({ scroller: this.scroller }) {
        ForEach(this.list, (item: WallItemInter, idx: number) => {
          FlowItem() {
            Column() {
              if (idx === 0) {
                Row() {
                  Image($r("app.media.ip_show"))
                    .width('100%')
                    .height(50)
                    .borderRadius(10)
                    .backgroundColor(0xf3a8ed)
                  Text("热门IP壁纸").offset({ x: -130, y: 2 }).fontColor(0xffffff)
                }.width('100%').height(50).margin({ bottom: 14 }).onClick(() => {
                  router.pushUrl({
                    url: "pages/Wallpaper"
                  })
                })
              }
              Column() {
                Image(item.url_type == 0 ? base_url + item.url : item.url)
                  .width("100%")
                  .height(300)
                  .borderRadius(10)
                  .backgroundColor(item.color)
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
          }.width("45%").margin({ bottom: 18 })
        }, item => item)
      }
      .width('90%')
      .layoutDirection(FlexDirection.Column)
      .columnsTemplate("1fr 1fr")
      .columnsGap(16)
      .onReachEnd(() => {
        if (this.page.count === -1) {
          return
        }
        // 分页加载的长度等于总数则不往下执行
        if (this.list.length === this.page.count) {
          this.loading = false
          return
        }
        // 如果当前上拉分页loading状态还未完成，不让其往下 执行
        if (this.loading) {
          return
        }
        // 分页加一 执行分页加载
        this.loading = true
        this.page.offset++
        this.getWallpaper()
      })

      if (this.loading) {
        Loading()
      }
    }.width('100%')
  }
}