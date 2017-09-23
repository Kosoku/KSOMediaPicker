//
//  PHAsset+KSOMediaPickerExtensions.h
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

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (KSOMediaPickerExtensions)

/**
 Get the image of the receiver, blocking until it is available. This should only be called on a background thread.
 */
@property (readonly,nonatomic,nullable) UIImage *KSO_image;
/**
 Get the image data of the receiver, blocking until it is available. This should only be called on a background thread.
 */
@property (readonly,nonatomic,nullable) NSData *KSO_imageData;

/**
 Requests the image of the receiver and invokes *completion* when it is available. If *image* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param completion The completion block to invoke when the image is available
 */
- (void)KSO_requestImageWithCompletion:(void(^)(UIImage * _Nullable image, NSError * _Nullable error))completion;
/**
 Requests the image data of the receiver and invokes *completion when it is available. If *image* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param completion The completion block to invoke when the image data is available
 */
- (void)KSO_requestImageDataWithCompletion:(void(^)(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSError * _Nullable error))completion;

/**
 Requests the live photo for the receiver and invokes *completion* when it is available. If *livePhoto* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param completion The completion block to invoke when the live photo is available
 */
- (void)KSO_requestLivePhotoWithCompletion:(void(^)(PHLivePhoto * _Nullable livePhoto, NSError * _Nullable error))completion;

/**
 Requests the AVPlayerItem intended for playback of the receiver with provided *deliveryMode* and invokes *completion* when it is available. If *playerItem* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param deliveryMode The quality of playback desired
 @param completion The completion block to invoke when the player item is available
 */
- (void)KSO_requestPlayerItemWithDeliveryMode:(PHVideoRequestOptionsDeliveryMode)deliveryMode completion:(void(^)(AVPlayerItem * _Nullable playerItem, NSError * _Nullable error))completion;
/**
 Requests an AVExportSession for the receiver with the *exportPresetName* preset and invokes *completion* when it has been created. If *exportSession* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param exportPresentName The AVExportSession preset name, see AVExportSession.h for more information
 @param completion The completion block to invoke when the export session has been created
 */
- (void)KSO_requestExportSessionWithExportPresetName:(NSString *)exportPresetName completion:(void(^)(AVAssetExportSession * _Nullable exportSession, NSError * _Nullable error))completion;
/**
 Requests an AVAsset for the receiver and invokes *completion* when it is available. If *asset* is nil, *error* will contain more information about the reason for failure. The *completion* block is invoked on an arbitrary queue.
 
 @param completion The completion block to invoke when the AVAsset is available
 */
- (void)KSO_requestAVAssetWithCompletion:(void(^)(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

