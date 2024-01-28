import router from '@ohos.router'
import { PageInter, WallItemInter } from '../../interface/index'
import { base_url } from '../../utils/env'
import request from '../../utils/http'
import { setBgColor } from '../../utils/tools'
import { toast } from '../../component/ShowToast'
import Loading from '../../component/Loading'
import NoData from '../../component/NoData'

@Component
export default struct HomeBar {
  scroller: Scroller = new Scroller()
  @State page: PageInter = { offset: 1, limit: 20, count: -1 }
  @State list: any = []
  @State loading: boolean = false

  aboutToAppear() {
    this.getWallpaper()
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
      if (this.page.count === 0) {
        NoData({ type: "bar", state: 0, })
      }
      WaterFlow({ scroller: this.scroller }) {
        ForEach(this.list, (item: WallItemInter, idx: number) => {
          FlowItem() {
            Column() {
              if (idx === 0) {
                Row() {
                  Image("https://www.dillonl.com/u/demo.png")
                    .width('100%')
                    .height(50)
                    .borderRadius(10)
                    .backgroundColor(0xf3a8ed)
                  Text("热门IP壁纸").offset({ x: -130, y: 2 }).fontColor(0xffffff)
                }.width('100%').height(50).margin({ bottom: 14 }).onClick(()=>{
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
      .height('100%')
      .layoutDirection(FlexDirection.Column)
      .columnsTemplate("1fr 1fr")
      .columnsGap(16)
      .onReachEnd(() => {
        console.info("onReachEnd")
      })
      if (this.loading) {
        Loading()
      }
    }.width("100%")

  }
}