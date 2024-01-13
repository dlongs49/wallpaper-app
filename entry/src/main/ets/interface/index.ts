export interface OpearInter{
  icon: unknown,
  title: string
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