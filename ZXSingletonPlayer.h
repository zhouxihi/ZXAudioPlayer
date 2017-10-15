//
//  ZXSingletonPlayer.h
//  AudioDemo
//
//  Created by Jackey on 2017/9/12.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXSingletonPlayer;

typedef void(^PlaybackInterruptedCallback)(ZXSingletonPlayer *player);
typedef void(^PlaybackResumeCallback)(ZXSingletonPlayer *player);

@interface ZXSingletonPlayer : NSObject

@property (nonatomic, readonly)     BOOL playing;
@property (nonatomic, strong)       PlaybackResumeCallback      resumeCallback;
@property (nonatomic, strong)       PlaybackInterruptedCallback interrputedCallback;

+ (instancetype)shareInstance;

// Instance Methods

- (void)play;
- (void)stop;
- (void)pause;

- (void)adjustRate:(float)rate; // 调节播放速度， 0.5 ~ 2.0
- (void)adjustPan:(float)pan;   // 调节立体声效果，-1 ~ 1.0 默认0
- (void)adjustVolume:(float)volume; // 调节声音大小， 0.0 ~ 1.0

- (void)setSourceFromFile:(NSString *)fileURL error:(NSError *)error;
- (void)setSourceFromData:(NSData *)audioData error:(NSError *)error;

- (void)setSourceFromFile:(NSString *)fileURL loops:(NSInteger)loops error:(NSError *)error;
- (void)setSourceFromData:(NSData *)audioData loops:(NSInteger)loops error:(NSError *)error;


@end
