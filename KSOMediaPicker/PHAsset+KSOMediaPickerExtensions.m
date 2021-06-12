//
//  PHAsset+KSOMediaPickerExtensions.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/23/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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
