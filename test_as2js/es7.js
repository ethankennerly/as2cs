class C{
  constructor(){
    this.a = true;
  }
  f(x, y:int=1){
    this.x = y;
  }
  x:int;
  a:Boolean;
  v:Array<int>;
  instance:String = "i";
  static g(){}
}

exports.C = C;
