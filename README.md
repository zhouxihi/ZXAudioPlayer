#封装的一个音频播放器, 有单个音频播放和多个音频混合播放2种, 适配iOS音频规范, 使用单例模式, 支持干扰事件和恢复block回调, 以及MPNowPlayingInfoCenter配置.

#单个音频播放

使用ZXSingletonPlayer

示例代码:
```Objective-C
NSString *fileURL = [[NSBundle mainBundle] pathForResource:@"guitar" ofType:@"caf"];
[[ZXSingletonPlayer shareInstance] setSourceFromFile:fileURL error:nil];
[[ZXSingletonPlayer shareInstance] play];
```

#多个音频混合播放

使用ZXMixPlayer

示例代码:
```Objective-C
NSString *fileURL1 = [[NSBundle mainBundle] pathForResource:@"guitar" ofType:@"caf"];
NSString *fileURL2 = [[NSBundle mainBundle] pathForResource:@"drums" ofType:@"caf"];
NSString *fileURL3 = [[NSBundle mainBundle] pathForResource:@"bass" ofType:@"caf"];
    
[[ZXMixPlayer shareInstance] setSourceFromFiles:@[fileURL1, fileURL2, fileURL3]];
[[ZXMixPlayer shareInstance] play];
```

#干扰事件和恢复block回调

ZXMixPlayer:

```Objective-C
@property (nonatomic, strong)       InterruptedCallback      resumeCallback;
@property (nonatomic, strong)       ResumeCallback           interrputedCallback;
```

ZXSingletonPlay

```Objective-C
@property (nonatomic, strong)       PlaybackResumeCallback      resumeCallback;
@property (nonatomic, strong)       PlaybackInterruptedCallback interrputedCallback;
```

#配置当前播放中心

需要导入ZXNowPlayingInfoCenterHelper.h

```Objective-C
NowPlayingModel *nowPlayingModel = [[NowPlayingModel alloc] init];
    
nowPlayingModel.title       = @"爱在西元前";
nowPlayingModel.singer      = @"周杰伦";
nowPlayingModel.album       = @"范特西";
nowPlayingModel.albumImage  = [UIImage imageNamed:@"ico.png"];
nowPlayingModel.duration    = 30.0f;
nowPlayingModel.currentTime = 10.0f;
    
[ZXNowPlayingInfoCenterHelper setupNowPlayingInfoCenterWith:nowPlayingModel];
```

