import router from '@ohos.router'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { CollectWallInter, PageInter } from '../interface/index'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import NoData from '../component/NoData'
import {PullUp,PullDown,InEnd} from '../component/ToLoad'
import { toast } from '../component/ShowToast'
import { connectNet, hmRect, setBgColor } from '../utils/tools'
import emitter from '@ohos.events.emitter'
import observer from '@ohos.telephony.observer';
import connection from '@ohos.net.connection';

@Entry
@Component
struct MineCollect {
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 12, count: -1 }
  @State show: boolean = false
  @State y: number = 80
  @State hmHeight: number = 0;
  @State loading: boolean = false
  @State isLoad: boolean = false // 触底分页加载状态
  @State isPull: boolean = false // 下拉刷新状态
  @State isEnd: boolean = false // 到底了没数据了状态
  @State hei: number = 25
  @State pull_text: string = "松开刷新"
  @State state:number = 0
  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight
  }

  onPageShow() {
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
  // 我的收藏壁纸
  async getWallpaper(flag = false) {
    try {
      // 第一次进入页面的 loading 加载
      if (flag) {
        this.loading = true
      }
      let api = `/api/sign/app/get_collect_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.get(api)
      this.loading = this.isLoad = false
      if (res.code === 200) {
        this.page.count = res.data.count
        const rows = setBgColor(res.data.rows)
        // 此处为下拉刷新
        if (this.isPull || flag) {
          this.list = []
          setTimeout(()=>{
            this.list = rows
          },100)
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
        this.show = false
        this.y = 0
        this.page.offset = 1
        this.getWallpaper(true)
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
      if (this.page.count === 0 || this.state === -1) {
        NoData({ type: "bar", state: this.state })
      }
      if (this.isPull) {
        PullDown({hei:this.hei,pull_text:this.pull_text})
      }
      Scroll(this.scroller) {
        Column() {
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
                      Text(item.format_date).fontSize(10).margin({ top: 5, right: 5 }).fontColor(0x585858)
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
              }.width("30%").margin({ bottom: 18 })
            }, item => item)
          }
          .columnsTemplate("lfr lfr lfr")
          .columnsGap(12)
          .rowsGap(10)
          .layoutDirection(GridDirection.Row)
          .width("90%")

          if (this.isLoad) {
            PullUp()
          }
          if (this.isEnd) {
            InEnd()
          }
        }.constraintSize({minHeight:this.hmHeight+ 'px'})
      }
      .height(!this.show ? this.hmHeight - 300 + 'px' : (this.hmHeight - 570) + 'px')
      .width("100%")
      .edgeEffect(EdgeEffect.Spring)
      .onScroll(() => {
        let y = this.scroller.currentOffset().yOffset
        // y 为 负数则为下拉刷新 为正为上拉加载 || 正在删除选中状态，不执行分页加载
        if (y > 0 || this.show) {
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
        // 正在删除选中状态，不执行分页加载
        if(this.show){
          return
        }
        // 滚动条停止滚动 判断是刷新操作，避免上拉加载执行
        if (this.isPull) {
          this.pull_text = "刷新中"
          this.page.offset = 1
          this.getWallpaper()
        }
      })
      .onScrollEdge((side: Edge) => {
        // 正在删除选中状态，不执行分页加载
        if(this.show){
          return
        }
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