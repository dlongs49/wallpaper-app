import router from '@ohos.router'
import { PageInter, WallItemInter } from '../../interface/index'
import { base_url } from '../../utils/env'
import request from '../../utils/http'
import { setBgColor } from '../../utils/tools'
import { toast } from '../../component/ShowToast'
import Loading from '../../component/Loading'
import NoData from '../../component/NoData'

@Component
export default struct SortBar {
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: -1 }
  @State list: any = []
  @State loading: boolean = false

  aboutToAppear() {
    this.getWallpaperType()
  }
  // 壁纸分类
  async getWallpaperType() {
    try {
      this.loading = true
      let api = `/api/wallpaper/app/get_wallpaper_type?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api)
      this.loading = false
      if (res.code === 200) {
        this.page.count = res.data.count
        this.list = [...setBgColor(res.data.rows), ...setBgColor(res.data.rows), ...setBgColor(res.data.rows), ...setBgColor(res.data.rows)]
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
      if (this.page.count === 0) {
        NoData({ type: "bar", state: 0, })
      }
      Scroll(this.scroller) {
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
      }
      .width("100%")
      .scrollBar(BarState.Off)
      .height('100%')
      .onScrollEdge((side: Edge) => {
        console.info('滚动****',JSON.stringify(side))
      })
      if (this.loading) {
        Loading()
      }
    }.width("100%")

  }
}