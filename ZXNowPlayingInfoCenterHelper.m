//
//  ZXNowPlayingInfoCenterHelper.m
//  AudioDemo
//
//  Created by Jackey on 2017/10/15.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import "ZXNowPlayingInfoCenterHelper.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation NowPlayingModel

@end

@implementation ZXNowPlayingInfoCenterHelper

+ (void)setupNowPlayingInfoCenterWith:(NowPlayingModel *)model {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 设置歌曲名称
    
    [dict setObject:model.title ? model.title : @"" forKey:MPMediaItemPropertyTitle];
    
    // 设置歌手名
    
    [dict setObject:model.singer ? model.singer : @"" forKey:MPMediaItemPropertyArtist];
    
    // 设置专辑名
    
    [dict setObject:model.album ? model.album : @"" forKey:MPMediaItemPropertyAlbumTitle];
    
    // 设置封面
    
    if (model.albumImage) {
        
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:model.albumImage]
                 forKey:MPMediaItemPropertyArtwork];
    }
    
    // 设置歌曲时长
    
    if (model.duration) {
        
        [dict setObject:[NSNumber numberWithFloat:model.duration]
                 forKey:MPMediaItemPropertyPlaybackDuration];
    }
    
    // 设置已经播放时长
    
    if (model.currentTime) {
        
        [dict setObject:[NSNumber numberWithFloat:model.currentTime]
                 forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    }
    
    // 更新设置
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}

@end
