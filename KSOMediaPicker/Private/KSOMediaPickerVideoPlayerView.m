//
//  KSOMediaPickerVideoPlayerView.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/22/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KSOMediaPickerVideoPlayerView.h"
#import "KSOMediaPickerAssetModel.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface KSOMediaPickerVideoPlayerView ()
@property (readonly,nonatomic) AVPlayerLayer *layer;
@property (strong,nonatomic) AVPlayer *player;
@property (assign,nonatomic) PHImageRequestID requestID;
@end

@implementation KSOMediaPickerVideoPlayerView

- (void)dealloc {
    [_player replaceCurrentItemWithPlayerItem:nil];
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@dynamic layer;

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setClipsToBounds:YES];
    [self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPath:@kstKeypath(self,player.status) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            [self.player play];
        }
    }];
    
    [self KAG_addObserverForNotificationName:AVPlayerItemDidPlayToEndTimeNotification object:nil block:^(NSNotification * _Nonnull notification) {
        kstStrongify(self);
        if ([notification.object isEqual:self.player.currentItem]) {
            [self.player seekToTime:kCMTimeZero];
            [self.player play];
        }
    }];
    
    return self;
}

- (void)setModel:(KSOMediaPickerAssetModel *)model {
    if (_model == model) {
        return;
    }
    
    _model = model;
    
    if (_model == nil) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
        [self setPlayer:nil];
    }
    else {
        [self setPlayer:[[AVPlayer alloc] init]];
        [self.player setVolume:0.0];
        [self.player setActionAtItemEnd:AVPlayerActionAtItemEndPause];
        [self.layer setPlayer:self.player];
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        
        [options setNetworkAccessAllowed:YES];
        [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeFastFormat];
        
        [self setRequestID:[[PHImageManager defaultManager] requestPlayerItemForVideo:_model.asset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
            [self.player replaceCurrentItemWithPlayerItem:playerItem];
        }]];
    }
}

- (void)setRequestID:(PHImageRequestID)requestID {
    if (_requestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_requestID];
    }
    
    _requestID = requestID;
}

@end
