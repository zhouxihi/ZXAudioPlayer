//
//  ZXMixPlayer.m
//  AudioDemo
//
//  Created by Jackey on 2017/9/12.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "ZXMixPlayer.h"

@interface ZXMixPlayer ()

@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) NSMutableArray<AVAudioPlayer *>  *players;

@end

@implementation ZXMixPlayer

static ZXMixPlayer *_instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
        _instance.players = [@[] mutableCopy];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:_instance
                   selector:@selector(mixHandleInterruption:)
                       name:AVAudioSessionInterruptionNotification
                     object:[AVAudioSession sharedInstance]];
        
        [center addObserver:_instance
                   selector:@selector(mixHandleRouteChange:)
                       name:AVAudioSessionRouteChangeNotification
                     object:[AVAudioSession sharedInstance]];
    });
    
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [ZXMixPlayer shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    
    return [ZXMixPlayer shareInstance];
}

- (void)play {
    
    if (self.players.count && !self.playing) {
        
        NSTimeInterval delayTime = [self.players[0] deviceCurrentTime] + 0.01;
        for (AVAudioPlayer *player in self.players) {
            
            [player playAtTime:delayTime];
        }
        
        self.playing = YES;
    }
}

- (void)stop {
    
    if (self.players.count && self.playing) {
        
        for (AVAudioPlayer *player in self.players) {
            
            [player stop];
            player.currentTime = 0.0f;
        }
        
        self.playing = NO;
    }
}

- (void)pause {
    
    if (self.players.count && self.playing) {
        
        for (AVAudioPlayer *player in self.players) {
            
            [player pause];
        }
        
        self.playing = NO;
    }
}

- (void)adjustRate:(float)rate {
    
    if (self.players.count) {
        
        if (rate > 2.0) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setRate:2.0];
            }
        }
        else if (rate < 0.5) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setRate:0.5];
            }
        } else {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setRate:rate];
            }
        }
    }
}

- (void)adjustPan:(float)pan {
    
    if (self.players.count) {
        
        if (pan > 1.0) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setPan:1.0];
            }
        }
        else if (pan < -1) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setPan:-1];
            }
        }else {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setPan:pan];
            }
        }
    }
}

- (void)adjustVolume:(float)volume {
    
    if (self.players.count) {
        
        if (volume > 1.0) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setVolume:1.0];
            }
        }
        else if (volume < 0.0) {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setVolume:0.0];
            }
        }else {
            
            for (AVAudioPlayer *player in self.players) {
                
                [player setVolume:volume];
            }
        }
    }
}

- (void)setSourceFromFiles:(NSArray<NSString *> *)fileURLs {
    
    [self setSourceFromFiles:fileURLs loops:0];
}

- (void)setSourceFromFiles:(NSArray<NSString *> *)fileURLs loops:(NSInteger)loops {
    
    for (AVAudioPlayer *player in self.players) {
        
        [player stop];
    }
    
    self.playing = NO;
    [self.players removeAllObjects];
    
    for (NSString *fileURL in fileURLs) {
        
        AVAudioPlayer *player = \
        [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileURL] error:nil];
        
        // 设置loop
        if (loops > 0 || loops == -1) {
            
            player.numberOfLoops = loops;
        }
        
        [player prepareToPlay];
        
        [self.players addObject:player];
    
    }
}

- (void)setSourceFromDatas:(NSArray<NSData *> *)audioDatas {
    
    [self setSourceFromDatas:audioDatas loops:0];
}

- (void)setSourceFromDatas:(NSArray<NSData *> *)audioDatas loops:(NSInteger)loops {
    
    for (AVAudioPlayer *player in self.players) {
        
        [player stop];
    }
    
    self.playing = NO;
    [self.players removeAllObjects];
    
    for (NSData *data in audioDatas) {
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        // 设置loop
        if (loops > 0 || loops == -1) {
            
            player.numberOfLoops = loops;
        }
        
        [player prepareToPlay];
        [self.players addObject:player];
    }
}

- (void)mixHandleInterruption:(NSNotification *)notification {
    
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

- (void)mixHandleRouteChange:(NSNotification *)notification {
    
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
