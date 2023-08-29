export class YoudaoHttpUtils{

  // getInputForYoudaoSign() {
  //   var len = this.inputContent.length;
  //   if (len <= 20) {
  //     return this.inputContent;
  //   }
  //   return this.inputContent.substring(0, 10) + len + this.inputContent.substring(len - 10, len);
  // }

  stringToUint8Array(str) {
    var arr = [];
    for (var i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    var tmpUint8Array = new Uint8Array(arr);
    return tmpUint8Array;
  }


}