# WJLaunchAdManager
iOS启动广告模块
![page1.png](http://upload-images.jianshu.io/upload_images/436419-87bae951acecba0a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

原理：在window最顶层放一个视图，倒计时消失

* 网络请求获取数据源
* 判断是网络请求成功
* 网络成功加载数据源并进行数据存储
* 网络失败加载本地缓存
* 抓取启动页并当作背景图
* 加载广告在合适的位置
