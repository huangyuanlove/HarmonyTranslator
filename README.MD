## 随译
基于鸿蒙3.1/4.0，使用Stage 模型和 ArkUI 开发
由于身边没有对应的设备，只在MetaPadPro 2019 鸿蒙4.0.0上验证



## 翻译api 

[ x ] [百度翻译开放平台](https://fanyi-api.baidu.com/)

[ ] 百度机器翻译

[ ] 有道翻译


## 版权声明

虽然极大概率不会有啥培训机构看上这个仓库，但还是先声明一下 ：**禁止商用**，想要商用请联系作者本人取得授权；**禁止商用**，想要商用请联系作者本人取得授权；**禁止商用**，想要商用请联系作者本人取得授权
邮箱：huangyuan@huangyuanlove.com
或者在github 或者 gitee 上都能找到联系方式

图标来源于 https://www.iconfont.cn/

## 使用的开源项目

*  [crypto-js](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fcrypto-js) 

## 踩坑

### 三方库
#### crypto-js
* [crypto-js](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fcrypto-js) 该库在2.0.3版本将最小api版本为10，个人认为现在的这个时间段(2023年11月18日，harmonyos next 还只对企业合作伙伴开放，部分手机还在使用HarmonyOS4测试版)，将api最低版本从9提升到10应该更新一个大版本号，不应该只更新小版本号。应用中锁定了版本为**2.0.1**


### 系统api

#### 冻屏、黑屏、假死

运行环境是MetaPadPro 2019 鸿蒙4.0.0，使用api9+stage模型开发，运行在模拟器上正常，但是运行在该设备上出现冻屏现象，页面轮播图无法轮播，滑动组件无法发滑动，就像卡在了这一帧上一样。点击输入框键盘能弹出，但页面是黑的。可以通过锁屏、解锁或者音量键刷新页面
感觉上就是屏幕不会主动刷新，需要按物理键让屏幕刷新一次似的。
询问过朋友后发现，这个现象只会出现在麒麟系列芯片的收集或平板上，看到论坛也有人咨询相同的问题。向官方提工单后官方回复是已知问题，将会在HarmonyOS next系统中修复
如果只是自己写着玩，可以安装 [scrcpy](https://github.com/Genymobile/scrcpy) 将屏幕内容同步到电脑上，在电脑上操作是没有问题的。
如果是公司用，建议等等，直接上HarmonyOS Next进行开发。或者降低api版本。

#### PersistentStorage和@StorageLink
* 项目中有些用户偏好设置需要持久化存储，于是选择了PersistentStorage和@StorageLink方式进行存储，大致如下
``` TypeScript
export class User {
  constructor(name: string, age: number) {
    this.name = name
    this.age = age
  }
  name: string
  age: number
}

PersistentStorage.PersistProp<User>('user', new User('xuan',18))
@Entry
@Component
struct Tmp {
  @StorageLink('user') user: User = new User('xuan', 18)
  build() {
    Text(`${this.user.name} : ${this.user.age}`)
  }
}

```
当我第一运行的时候，页面显示正常，Text显示的内容是`xuan : 18`<br/>
但是当我重新打开应用(不是重新编译，就是简单的在设备上关掉应用然后点击桌面图标打开应用)的时候，Text显示内容是 `undefined : undefined`<br/>
打上断点发现重新打开应用的时候 `user` 是一个字符串类型，值为 {'name':'xuan','age':18}，但字符串对象没有name和age属性，所以显示了 undefined.<br/>
看到文档中有写 https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/arkts-state-management-0000001504151156-V3#ZH-CN_TOPIC_0000001523808562__persistprop
> AppStorage的属性向PersistentStorage中持久化的允许的类型是：<br/>
> number，string，boolean，enum基础类型。<br/>
> Object中可序列化的属性。<br/>
> 不允许undefined和null。

但同样的，在指南中同样有描述 https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-persiststorage-0000001474017166-V3#section610120319595

> PersistentStorage允许的类型和值有：<br/>
> number, string, boolean, enum 等简单类型。<br/>
> 可以被JSON.stringify()和JSON.parse()重构的对象。例如Date, Map, Set等内置类型则不支持，以及对象的属性方法不支持持久化。<br/>

看到论坛有同样的求助，有开发者回复说他是将对象转成字符串保存的，使用的时候再parse一下。

#### 剪贴板 pasteboard.getSystemPasteboard()



在使用剪贴板时需要先创建剪贴板数据，
创建方法如下 

> createData(mimeType: string, value: ValueType): PasteData
> createRecord(mimeType: string, value: ValueType):PasteDataRecord;

第一个参数含义为：自定义数据的MIME类型。 文档中 [鸿蒙开发api参考](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/js-apis-pasteboard-0000001544384177-V3#ZH-CN_TOPIC_0000001523648478__pasteboardcreatedata9)
中写的示例
```typescript
import pasteboard from '@ohos.pasteboard';
let dataXml = 'Hello World';
let pasteDataRecord = pasteboard.createRecord('app/xml', dataXml);
```
实际中发现时不能使用这自定义的`app/xml`值，会崩溃，只能使用pasteboard中预定义的MIME类型


#### 对象属性从有值变为空，应用会崩溃

```typescript
@Entry
@Component
struct PlayGround {
  @State people:People = new People()


  private log(log:string):boolean{
    console.error(`---------${log}---------`)
    return true
  }

  build(){
    Column() {
      if(this.people){
        Text(`姓名： ${this.people.name}  年龄：${this.people.age}`)
        if(this.people.address){
          if(this.log('address 有值')){
            Text( `地址： ${this.people.address.name}  邮编：${this.people.address.zipCode}`)
          }
          else{
            Text('address 为空 内部')
          }
        }else{
          if(this.log('address 为空 最外层')){
            Text('address 为空 最外层')
          }
        }
      }
      Button('网络请求返回一个有地址的对象').onClick(()=>{
        let tmpPeople = new People()
        let tmpAddress = new Address()
        tmpAddress.name = '测试地址'
        tmpAddress.zipCode = -1000
        tmpPeople.address = tmpAddress

        tmpPeople.age = 10
        tmpPeople.name = '有地址'
        this.people = tmpPeople
      })

      Button('网络请求返回一个没有地址的对象').onClick(()=>{
        let tmpPeople = new People()
        tmpPeople.age = 10
        tmpPeople.name = '没有地址'
        this.people = tmpPeople
      })
    }.margin({top:48})
  }
}
class  Address{
  zipCode:number
  name:string
}
class  People{
  name:string
  age:number
  address :Address
}
```

很简单的页面，展示对象属性，
刚开始运行，一切正常。点击返回有地址的对象，页面正常刷新并且展示。然后点击返回没有地址的对象，这时候会崩溃。
日志指向了 `Text( `地址： ${this.people.address.name}  邮编：${this.people.address.zipCode}`)`
说是`不能从undefined对象中读取name属性` 具体可以看这里：[开发这论坛](https://developer.huawei.com/consumer/cn/forum/topic/0204136377582311317?fid=0102683795438680754)
规避方案：我有一个朋友，尝试出了使用 `?.`来规避的方法。 取对象属性除了要用if判断来控制渲染之外，需要用 `?.`来取值，防崩溃，将上面的代码修改为
`Text( `地址： ${this.people.address?.name}  邮编：${this.people.address?.zipCode}`)`
应用不会崩溃，这个对象也不会渲染在页面上


