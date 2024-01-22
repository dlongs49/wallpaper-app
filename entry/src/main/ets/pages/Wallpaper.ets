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
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#e6dd23'
  @State currentIndex: number = 0
  @State list: Array<any> = []
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: -1 }
  @State loading: boolean = false
  @State hmHeight: string = "90%";
  @State type_id: string = ""

  async aboutToAppear() {
    const hr = await hmRect()
    this.hmHeight = hr.hmHeight - 300 + 'px'
  }

  onPageShow() {
    let params: ParamsInter = router.getParams();
    this.type_id = params.id
    this.getWallpaper()
  }
  // 壁纸
  async getWallpaper() {
    try {
      this.loading = true
      let api = `/api/wallpaper/app/get_wallpaper?offset=${this.page.offset}&limit=${this.page.limit}`
      const res: any = await request.post(api, { type_id: this.type_id })
      this.loading = false
      if (res.code === 200) {
        this.page.count = res.data.count
        this.list = setBgColor(res.data.rows)
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
      TopNav({ title: "壁纸中心", url: "pages/Index" })
      if (this.page.count === 0) {
        NoData({ type: "page", state: 0, })
      }
      Scroll(this.scroller) {
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
            }.width("50%").margin({ bottom: 18 })
          }, item => item)
        }
        .width('90%')
        .height(this.hmHeight)
        .columnsTemplate("1fr 1fr")
        .columnsGap(12)
      }

      if (this.loading) {
        Loading()
      }
    }.width('100%')
  }
}