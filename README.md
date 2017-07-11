# HHModule
This is a cool hover interactive view, Integrated the commonly used waithud and refresh manager. Do not need to rely on third-party libraries.
这个一个炫酷的悬停交互视图，集成了多种样式的waithud和刷新控件，不需要依赖第三方库。


- **详细介绍** ：请移步[CSDN](http://blog.csdn.net/kyjsj2013/article/details/71882377)

**使用方式：**
>将下载文件中的HHModule直接拖入自己的工程目录

该视图包含三个小模块:

- **BaseConstruct** ：可选8中waitHud样式，提醒文字，错误页面;
- **RefreshManager** ：包含三种刷新样式，KVO监听，使用简单;
- **LinkageView** ：指示器联动

<font color=#FF0000>详见各个类中的说明</font>

**说明：**
此控件为UIView，分三个部分，顶部为headerView，setter方法设置，用户自己管理视图，中间的title视图为可以滚动的scrollView，可以设置标题选择和未选择的颜色，底部为collectionView嵌套的tableView，而tableView为用户注册的类名加载而来,需要继承<font color=#FF0000>"HHBaseTableView"</font>，重写父类的一些方法，用户只需要管理headerView和tableView即可,详见<font color=#FF0000>"Demo"</font>,.

**传值：**
传值方式为：字典传值，控制器定义`Block`，以`key`值区分事件，保存在`HHHoverLinkageView`的`actionDict`中，父视图负责分发到各个模块
```objc
AddBlockAction(_hoverView.actionDict, HeaderViewButtonClick, ^(NSString *text){
        
        [wSelf showText:text];
    });
```

**常用方法：**
```objc
_hoverView.linkageView.titleArray = self.titleArray;//决定中间title的标题
_hoverView.tableViewClassName = NSStringFromClass([HHHoverTableView class]);//注册类名需要继承"HHBaseTableView"，加载用户自定义的tableView
```
```objc
@property (nonatomic, assign) RefreshManagerType refreshType;//子类重写 "setter" 方法设置刷新样式,基类有三种, 优先级低于 "loadRefreshModel:(RefreshManagerType)refreshType"
@property (nonatomic, strong) NSMutableDictionary *actionDict;//存储 block 事件的字典
@property (nonatomic, strong) HHRefreshManager * refreshManager;//刷新控件管理类
@property (nonatomic, weak) id <HHBaseTableViewDelegate> refreshDelegate;
@property (nonatomic, copy)   NSDictionary *dataDict;//子类重写 "setter" 获得数据
@property (nonatomic, copy)   NSArray *dataArray;//子类重写 "setter" 获得数据
@property (nonatomic, strong) NSIndexPath *indexPath;//子类重写"setter" 获得索引

- (void)configInitialInfo;//子类重写作为初始化入口
- (void)loadRefreshModel:(RefreshManagerType)refreshType;//重写此方法覆盖刷新控件，由用户自定义

- (void)beginRefreshWithType:(RefreshType)type; //子类重写接收开始刷新事件，需要调用父类的方法
- (void)endRefreshAnimation;//子类直接调用结束刷新
```



