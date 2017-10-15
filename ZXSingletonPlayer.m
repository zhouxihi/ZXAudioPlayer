//
//  ZXSingletonPlayer.m
//  AudioDemo
//
//  Created by Jackey on 2017/9/12.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ZXSingletonPlayer.h"

@interface ZXSingletonPlayer ()

@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ZXSingletonPlayer

static ZXSingletonPlayer *_instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

        [center addObserver:_instance
                   selector:@selector(handleInterruption:)
                       name:AVAudioSessionInterruptionNotification
                     object:[AVAudioSession sharedInstance]];

        [center addObserver:_instance
                   selector:@selector(handleRouteChange:)
                       name:AVAudioSessionRouteChangeNotification
                     object:[AVAudioSession sharedInstance]];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [ZXSingletonPlayer shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [ZXSingletonPlayer shareInstance];
}

- (void)play {
    
    if (self.player && !self.playing) {
        
        [self.player prepareToPlay];
        [self.player play];
        self.playing = YES;
    }
}

- (void)stop {
    
    if (self.player && self.playing) {
        
        [self.player stop];
        self.playing = NO;
    }
}

- (void)pause {
    
    if (self.player && self.playing) {
        
        [self.player pause];
        self.playing = NO;
    }
}

- (void)adjustRate:(float)rate {
    
    if (self.player) {
        
        if (rate > 2.0) {
            
            [self.player setRate:2.0];
        }
        else if (rate < 0.5) {
            
            [self.player setRate:0.5];
        } else {
            
            [self.player setRate:rate];
        }
    }
}

- (void)adjustPan:(float)pan {
    
    if (self.player) {
        
        if (pan > 1.0) {
            
            [self.player setPan:1.0];
        }
        else if (pan < -1) {
            
            [self.player setPan:-1.0];
        }else {
            
            [self.player setPan:pan];
        }
    }
}

- (void)adjustVolume:(float)volume {
    
    if (self.player) {
        
        if (volume > 1.0) {
            
            [self.player setVolume:1.0];
        }
        else if (volume < 0.0) {
            
            [self.player setVolume:0.0];
        }else {
            
            [self.player setVolume:volume];
        }
    }
}

- (void)setSourceFromData:(NSData *)audioData error:(NSError *)error {
    
    [self setSourceFromData:audioData loops:1 error:error];
}

- (void)setSourceFromData:(NSData *)audioData loops:(NSInteger)loops error:(NSError *)error {
    
    // 先暂停并赋nil
    if (self.player) {
        
        [self.player stop];
        self.playing = NO;
        self.player = nil;
    }
    
    // 创建新的player
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    
    // 设置loop
    if (loops > 0 || loops == -1) {
        
        self.player.numberOfLoops = loops;
    }
    
    [self.player prepareToPlay];
}

- (void)setSourceFromFile:(NSString *)fileURL error:(NSError *)error {
    
    [self setSourceFromFile:fileURL loops:1 error:error];
}

- (void)setSourceFromFile:(NSString *)fileURL loops:(NSInteger)loops error:(NSError *)error {
    
    // 先暂停并赋nil
    if (self.player) {
        
        [self.player stop];
        self.playing = NO;
        self.player = nil;
    }
    
    // 创建新的player
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fileURL] error:&error];
    
    // 设置loop
    if (loops > 0 || loops == -1) {
        
        self.player.numberOfLoops = loops;
    }
    
    [self.player prepareToPlay];
    
}

- (void)handleInterruption:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    AVAudioSessionInterruptionType type = \
    [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        
        // handle interruption began
        
        [self pause];
        if (self.interrputedCallback) {
            
            self.interrputedCallback(self);
        }
    } else {
        
        // handle interruption end
        
        AVAudioSessionInterruptionOptions options = \
        [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            
            [self play];
            if (self.resumeCallback) {
                
                self.resumeCallback(self);
            }
        }
        
    }
    
}

- (void)handleRouteChange:(NSNotification *)notification {
    
    NSDictionary *info =notification.userInfo;
    
    AVAudioSessionRouteChangeReason reason = \
    [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        
        AVAudioSessionRouteDescription *previousRoute = \
        info[AVAudioSessionRouteChangePreviousRouteKey];
        
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            
            [self pause];
            if (self.interrputedCallback) {
                
                self.interrputedCallback(self);
            }
        }
        
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
