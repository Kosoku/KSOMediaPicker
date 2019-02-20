//
//  KSOMediaPickerAssetCollectionModel.h
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
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>

#import <KSOMediaPicker/KSOMediaPickerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOMediaPickerModel,KSOMediaPickerAssetModel;

@interface KSOMediaPickerAssetCollectionModel : NSObject

@property (readonly,weak,nonatomic,nullable) KSOMediaPickerModel *model;

@property (readonly,strong,nonatomic) PHAssetCollection *assetCollection;
@property (readonly,strong,nonatomic) PHFetchResult<PHAsset *> *fetchResult;

@property (readonly,nonatomic) NSString *identifier;
@property (readonly,nonatomic) KSOMediaPickerAssetCollectionSubtype subtype;
@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) NSString *subtitle;
@property (readonly,nonatomic,nullable) UIImage *typeImage;

@property (readonly,nonatomic) NSUInteger countOfAssetModels;
- (KSOMediaPickerAssetModel *)assetModelAtIndex:(NSUInteger)index;
- (PHAsset *)assetAtIndex:(NSUInteger)index;

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(nullable KSOMediaPickerModel *)model;

- (void)reloadFetchResult;

- (void)requestThumbnailImageOfSize:(CGSize)size thumbnailIndex:(NSUInteger)thumbnailIndex completion:(void(^)(UIImage * _Nullable thumbnailImage))completion;
- (void)cancelAllThumbnailRequests;

@end

NS_ASSUME_NONNULL_END
