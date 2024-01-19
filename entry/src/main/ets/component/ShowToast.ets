import promptAction from '@ohos.promptAction'

@Preview
@Component
export default struct ShowToast {
  build() {
    // 自定义待定
  }
}

export const toast =  {
  success:(message: string, duration = 2000) => {
    promptAction.showToast({
      message,
      bottom: 400,
      duration,
    });
  },
  error:(message = "服务异常,请重试!",duration = 2000) => {
    promptAction.showToast({
      message,
      bottom: 400,
      duration,
    });
  }
}
// export const toast = Toast()