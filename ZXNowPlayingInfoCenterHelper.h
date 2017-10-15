//
//  ZXNowPlayingInfoCenterHelper.h
//  AudioDemo
//
//  Created by Jackey on 2017/10/15.
//  Copyright © 2017年 com.zhouxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NowPlayingModel : NSObject

@property (nonatomic, strong) NSString *title;          // 歌曲名称
@property (nonatomic, strong) NSString *singer;         // 歌手名
@property (nonatomic, strong) NSString *album;          // 专辑名
@property (nonatomic, strong) UIImage  *albumImage;     // 封面图片
@property (nonatomic, assign) CGFloat   duration;       // 歌曲时长
@property (nonatomic, assign) CGFloat   currentTime;    // 已经播放时长

@end

@interface ZXNowPlayingInfoCenterHelper : NSObject

+ (void)setupNowPlayingInfoCenterWith:(NowPlayingModel *)model;

@end
