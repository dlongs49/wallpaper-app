import router from '@ohos.router'
import { PageInter, WallItemInter } from '../../interface/index'
import { base_url } from '../../utils/env'
import request from '../../utils/http'
import Loading from '../../component/Loading'
import NoData from '../../component/NoData'
import { PullUp, PullDown, InEnd } from '../../component/ToLoad'
import { toast } from '../../component/ShowToast'
import { hmRect, setBgColor } from '../../utils/tools'

@Component
export default struct SortBar {
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: -1 }
  @State loading: boolean = false
  @State hmHeight: string = "90%";
  @State type_id: string = ""
  @State isLoad: boolean = false // 触底分页加载状态
  @State isEnd: boolean = false // 到底了没数据了状态
  @State hei: number = 25

  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight - 300 + 'px'
    this.getWallpaperTypeType(true)
  }
  // 壁纸分类
  async getWallpaperTypeType(flag = false) {
    try {
      if (flag) {
        this.loading = true
      }
      let api = `/api/wallpaper/app/get_wallpaper_type?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      this.loading = this.isLoad = false
      if (res.code === 200) {
        this.page.count = res.data.count
        const rows = setBgColor(res.data.rows)
        this.list = [...this.list, ...rows]
      } else {
        toast.error(res.msg)
      }
    } catch (err) {
      this.loading = this.isLoad = false
      toast.error()
    }
  }

  build() {
    Column() {
      if (this.page.count === 0) {
        NoData({ type: "bar", state: 0, })
      }
      Scroll(this.scroller) {
        Column() {
          Grid() {
            ForEach(this.list, (item: any) => {
              GridItem() {
                Stack({ alignContent: Alignment.TopStart }) {
                  Image(item.cover_type === 0 ? base_url + item.cover_url : item.cover_url)
                    .borderRadius(12)
                    .width('100%')
                    .height(100)
                    .backgroundColor(item.color)
                  Text(item.title).fontColor(0xffffffff).fontSize(18).markAnchor({ x: -14, y: -20 })
                }.width('48.5%')
              }.onClick(() => {
                router.pushUrl({
                  url: "pages/Wallpaper",
                  params: {
                    id: item.id
                  }
                })
              })
            })
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
        }.constraintSize({ minHeight: this.hmHeight })
      }
      .height(this.hmHeight)
      .width("100%")
      .edgeEffect(EdgeEffect.Spring)
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
          this.getWallpaperTypeType()
        }
      })

      if (this.loading) {
        Loading()
      }
    }.width("100%")

  }
}