//
//  KSOMediaPickerVideoPlayerView.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/22/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
