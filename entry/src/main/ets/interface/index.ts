export interface OpearInter{
  icon: unknown,
  title: string,
  url: string,
  touchColor?:number,
}

export interface SignInter{
  uname:string,
  password:string
}
export interface SignResInter{
  code?:number,
  data?:string,
  msg?:string
}
export interface PageInter{
  offset?:number,
  limit?:number,
  count?:number
}
export interface WallItemInter{
  id:string,
  title:string,
  url_type:number,
  url:string,
  is_checked:boolean,
  color:number
}
export interface ParamsInter{
  id?:string,
}
export interface UinfoInter{
  id?:string,
  avatar:string,
  uname:string,
  sex?:number,
  sex_tit?:string,
  nation?:string,
  reg_time?:string,
}
export interface CollectWallInter{
  id:string,
  wallpaper_type:number,
  wallpaper_url:string,
  create_time:string,
  is_checked:boolean,
  color:number,
  format_date:string,
}