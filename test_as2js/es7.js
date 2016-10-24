class C{
  constructor(){
    this.a = 10;
  }
  f(x, y=1){
    this.a = y;
  }
  instance = 5;
  static g(){}
}
