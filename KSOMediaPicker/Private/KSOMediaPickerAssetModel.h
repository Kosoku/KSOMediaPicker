//
//  KSOMediaPickerAssetModel.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/18/17.
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

#import <UIKit/UIKit.h>

#import <KSOMediaPicker/KSOMediaPickerMedia.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString* KSOMediaPickerStringFromMediaType(KSOMediaPickerMediaType mediaType);
FOUNDATION_EXTERN NSString* KSOMediaPickerStringFromDuration(NSTimeInterval duration);

@class KSOMediaPickerAssetCollectionModel;

@interface KSOMediaPickerAssetModel : NSObject <KSOMediaPickerMedia>

@property (readonly,strong,nonatomic) PHAsset *asset;

@property (readonly,weak,nonatomic) KSOMediaPickerAssetCollectionModel *assetCollectionModel;

@property (readonly,nonatomic) NSString *identifier;
@property (readonly,nonatomic) KSOMediaPickerMediaType mediaType;

@property (readonly,nonatomic) UIImage *typeImage;
@property (readonly,nonatomic) NSTimeInterval duration;
@property (readonly,nonatomic,nullable) NSString *formattedDuration;
@property (readonly,nonatomic) NSDate *creationDate;
@property (readonly,nonatomic) NSUInteger selectedIndex;

@property (readonly,nonatomic) NSString *accessibilityLabel;

- (nullable instancetype)initWithAsset:(PHAsset *)asset assetCollectionModel:(nullable KSOMediaPickerAssetCollectionModel *)assetCollectionModel;

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(id _Nullable thumbnailImage))completion;
- (void)cancelAllThumbnailRequests;

@end

NS_ASSUME_NONNULL_END
