import router from '@ohos.router'
import request from '../utils/http'
import { base_url } from '../utils/env'
import { PageInter, ParamsInter, WallItemInter } from '../interface/index'
import TopNav from '../component/TopNav'
import Loading from '../component/Loading'
import NoData from '../component/NoData'
import { toast } from '../component/ShowToast'
import { hmRect, setBgColor } from '../utils/tools'

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
  @State isNoBom: boolean = false // 到底了没数据了状态
  @State y: number = 0

  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight - 300 + 'px'
  }

  onPageShow() {
    let params: ParamsInter = router.getParams();
    this.type_id = params.id
    this.getWallpaper(true)
  }
  // 壁纸
  async getWallpaper(flag = false) {
    try {
      if (flag) {
        this.loading = true
      }
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api, { type_id: !this.type_id || "" })
      this.loading = this.isLoad = false
      if (res.code === 200) {
        this.page.count = res.data.count
        const rows = setBgColor(res.data.rows)
        if (this.isPull) {
          this.list = rows
        }
        this.list = [...this.list, ...rows]
        this.isPull = false
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
      TopNav({ title: "壁纸中心" + this.y, url: "pages/Index" })
      if (this.page.count === 0) {
        NoData({ type: "page", state: 0, })
      }
      Scroll(this.scroller) {
        Column() {
          // if (this.isPull) {
          Text("刷新中...")
            .fontSize(13)
            .lineHeight(50)
            .textAlign(TextAlign.Center)
          // }
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
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r("app.media.loading")).width(40).height(40)
              Text("加载中...").fontSize(13)
            }.height(50).width("100%")
          }
          if (this.isNoBom) {
            Text("到底了~").fontSize(13).lineHeight(50).textAlign(TextAlign.Center)
          }
        }
      }
      .height(this.hmHeight)
      .width("100%")
      .edgeEffect(EdgeEffect.Spring)
      .onScroll((x: number, y: number) => {
        this.y = this.scroller.currentOffset().yOffset
        console.log("XXXXX", x, "YYYYYYY:", y)
      })
      .onScrollEdge((side: Edge) => {
        if (Edge.Top === side) {
          // if (this.isPull) {
          //   return
          // }
          // this.isPull = true
          // setTimeout(() => {
          //   this.page.offset = 1
          //   this.getWallpaper()
          // }, 2000)
        }
        if (Edge.Bottom === side) {

          if (this.list.length === this.page.count) {
            this.isLoad = false
            this.isNoBom = true
            return
          }
          if (this.isLoad) {
            return
          }
          this.isLoad = true
          setTimeout(() => {
            this.page.offset++
            this.getWallpaper()
          }, 1500)
        }
      })


      if (this.loading) {
        Loading()
      }
    }.width('100%')
  }
}