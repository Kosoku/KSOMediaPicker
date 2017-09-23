//
//  PHAsset+KSOMediaPickerExtensions.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/23/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "PHAsset+KSOMediaPickerExtensions.h"

@implementation PHAsset (KSOMediaPickerExtensions)

- (UIImage *)KSO_image {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setSynchronous:YES];
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    __block UIImage *retval = nil;
    
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        retval = result;
    }];
    
    return retval;
}
- (NSData *)KSO_imageData {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setSynchronous:YES];
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    __block NSData *retval = nil;
    
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        retval = imageData;
    }];
    
    return retval;
}

- (void)KSO_requestImageWithCompletion:(void (^)(UIImage * _Nullable, NSError * _Nullable))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result,info[PHImageErrorKey]);
    }];
}
- (void)KSO_requestImageDataWithCompletion:(void (^)(NSData * _Nullable, NSString * _Nullable, UIImageOrientation, NSError * _Nullable))completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestImageDataForAsset:self options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        completion(imageData,dataUTI,orientation,info[PHImageErrorKey]);
    }];
}

- (void)KSO_requestLivePhotoWithCompletion:(void (^)(PHLivePhoto * _Nullable, NSError * _Nullable))completion {
    PHLivePhotoRequestOptions *options = [[PHLivePhotoRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestLivePhotoForAsset:self targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
        completion(livePhoto,info[PHImageErrorKey]);
    }];
}

- (void)KSO_requestPlayerItemWithDeliveryMode:(PHVideoRequestOptionsDeliveryMode)deliveryMode completion:(void (^)(AVPlayerItem * _Nullable, NSError * _Nullable))completion {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:deliveryMode];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        completion(playerItem,info[PHImageErrorKey]);
    }];
}
- (void)KSO_requestExportSessionWithExportPresetName:(NSString *)exportPresetName completion:(void (^)(AVAssetExportSession * _Nullable, NSError * _Nullable))completion; {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestExportSessionForVideo:self options:options exportPreset:exportPresetName resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        completion(exportSession,info[PHImageErrorKey]);
    }];
}
- (void)KSO_requestAVAssetWithCompletion:(void (^)(AVAsset * _Nullable, AVAudioMix * _Nullable, NSError * _Nullable))completion {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    
    [options setNetworkAccessAllowed:YES];
    [options setDeliveryMode:PHVideoRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        completion(asset,audioMix,info[PHImageErrorKey]);
    }];
}

@end
