//
//  ZXMixPlayer.h
//  AudioDemo
//
//  Created by Jackey on 2017/9/12.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXMixPlayer;

typedef void(^InterruptedCallback)(ZXMixPlayer *player);
typedef void(^ResumeCallback)(ZXMixPlayer *player);

@interface ZXMixPlayer : NSObject

@property (nonatomic, readonly)     BOOL                     playing;
@property (nonatomic, strong)       InterruptedCallback      resumeCallback;
@property (nonatomic, strong)       ResumeCallback           interrputedCallback;

+ (instancetype)shareInstance;

// Instance Methods

- (void)play;
- (void)stop;
- (void)pause;

- (void)adjustRate:(float)rate; // 调节播放速度， 0.5 ~ 2.0
- (void)adjustPan:(float)pan;   // 调节立体声效果，-1 ~ 1.0 默认0
- (void)adjustVolume:(float)volume; // 调节声音大小， 0.0 ~ 1.0

- (void)setSourceFromFiles:(NSArray<NSString *> *)fileURLs;
- (void)setSourceFromDatas:(NSArray<NSData *> *)audioDatas;

- (void)setSourceFromFiles:(NSArray<NSString *> *)fileURLs loops:(NSInteger)loops;
- (void)setSourceFromDatas:(NSArray<NSData *> *)audioDatas loops:(NSInteger)loops;

@end
