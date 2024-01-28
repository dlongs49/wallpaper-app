import router from '@ohos.router'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { PageInter, ParamsInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import NoData from '../component/NoData'
import {PullUp,PullDown,InEnd} from '../component/ToLoad'
import { toast } from '../component/ShowToast'
import { connectNet, hmRect, setBgColor } from '../utils/tools'
import emitter from '@ohos.events.emitter'

@Entry
@Component
struct Wallpaper {
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 6, count: -1 }
  @State loading: boolean = false
  @State hmHeight: string = "90%";
  @State type_id: string = ""
  @State isLoad: boolean = false // 触底分页加载状态
  @State isPull: boolean = false // 下拉刷新状态
  @State isEnd: boolean = false // 到底了没数据了状态
  @State hei: number = 25
  @State pull_text: string = "松开刷新"
  @State state:number = 0
  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight - 300 + 'px'
  }

  onPageShow() {
    let params: ParamsInter = router.getParams();
    this.type_id = params?.id
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
      this.getWallpaper(true)
    }
  }
  // 重新加载数据事件
  onEventHandel() {
    this.watchConnect()
  }
  // 壁纸
  async getWallpaper(flag = false) {
    try {
      // 第一次进入页面的 loading 加载
      if (flag) {
        this.loading = true
      }
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api, { type_id: this.type_id})
      this.loading = this.isLoad = false
      if (res.code === 200) {
        this.page.count = res.data.count
        // 给图片增加背景交互色
        const rows = setBgColor(res.data.rows)
        // 此处为下拉刷新
        if (this.isPull) {
          this.list = rows
          this.isPull = false
          this.pull_text = "松开刷新"
          return
        }
        this.list = [...this.list, ...rows]
      } else {
        this.isPull = false
        toast.error(res.msg)
      }
    } catch (err) {
      this.loading = this.isLoad = this.isPull = false
      toast.error()
    }
  }

  build() {
    Column() {
      TopNav({ title: "壁纸中心", url: "pages/Index" })
      if (this.page.count === 0 || this.state === -1) {
        NoData({ type: "bar", state: this.state })
      }
      if (this.isPull) {
        PullDown({hei:this.hei,pull_text:this.pull_text})
      }
      Scroll(this.scroller) {
        Column() {
          Grid() {
            ForEach(this.list, (item: WallItemInter, idx: number) => {
              GridItem() {
                Column() {
                  Column() {
                    Image(item.url_type == 0 ? base_url + item.url : item.url)
                      .width("100%")
                      .height(320)
                      .borderRadius(10)
                      .backgroundColor(item.color)
                    Text(item.title).fontSize(14).margin({ top: 10, left: 5 })
                  }.width("100%").alignItems(HorizontalAlign.Start).onClick((e: ClickEvent) => {
                    router.pushUrl({
                      url: "pages/SetWallpaper",
                      params: {
                        id: item.id
                      }
                    })
                  })
                }.alignItems(HorizontalAlign.Start)
              }.width("48%").margin({ bottom: 18 })
            }, item => item)
          }
          .columnsTemplate("lfr lfr")
          .columnsGap(10)
          .rowsGap(10)
          .layoutDirection(GridDirection.Row)
          .width("90%")
          if (this.isLoad) {
            PullUp()
          }
          if (this.isEnd) {
            InEnd()
          }
        }.constraintSize({minHeight:this.hmHeight})
      }
      .height(this.hmHeight)
      .width("100%")
      .edgeEffect(EdgeEffect.Spring)
      .onScroll(() => {
        let y = this.scroller.currentOffset().yOffset
        // y 为 负数则为下拉刷新 为正为上拉加载
        if (y > 0) {
          return
        }
        this.pull_text = "松开刷新"
        const scroll_y = Math.floor(Math.abs(y))
        if (scroll_y === 0) {
          this.pull_text = "刷新中"
        }
        // 保持加载的圆形有高度
        if (scroll_y > 24) {
          this.isPull = true
          this.hei = scroll_y
        }
      })
      .onScrollStop(() => {
        // 滚动条停止滚动 判断是刷新操作，避免上拉加载执行
        if (this.isPull) {
          this.pull_text = "刷新中"
          this.page.offset = 1
          this.getWallpaper()
        }
      })
      .onScrollEdge((side: Edge) => {
        // 上拉分页加载
        if (Edge.Bottom === side) {
          // 分页加载的长度等于总数则不往下执行
          if (this.list.length === this.page.count) {
            this.isLoad = false
            this.isEnd = true
            return
          }
          // 如果当前上拉分页loading状态还未完成，不让其往下 执行
          if (this.isLoad) {
            return
          }
          // 分页加一 执行分页加载
          this.isLoad = true
          this.page.offset++
          this.getWallpaper()
        }
      })
      if (this.loading) {
        Loading()
      }
    }.width('100%')
  }
}