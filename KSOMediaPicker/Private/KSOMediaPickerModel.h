//
//  KSOMediaPickerModel.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/17/17.
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

#import <UIKit/UIKit.h>
#import <KSOMediaPicker/KSOMediaPickerDefines.h>
#import <Photos/PHImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOMediaPickerAssetCollectionModel,KSOMediaPickerAssetModel,KSOMediaPickerTheme;
@protocol KSOMediaPickerModelDelegate;

@interface KSOMediaPickerModel : NSObject

@property (weak,nonatomic) id<KSOMediaPickerModelDelegate> delegate;

@property (readonly,assign,nonatomic) KSOMediaPickerAuthorizationStatus authorizationStatus;

@property (assign,nonatomic) BOOL allowsMultipleSelection;
@property (assign,nonatomic) BOOL allowsMixedMediaSelection;
@property (assign,nonatomic) NSUInteger maximumSelectedMedia;
@property (assign,nonatomic) NSUInteger maximumSelectedImages;
@property (assign,nonatomic) NSUInteger maximumSelectedVideos;
@property (assign,nonatomic) BOOL hidesEmptyAssetCollections;

@property (assign,nonatomic) KSOMediaPickerMediaTypes mediaTypes;

@property (assign,nonatomic) KSOMediaPickerAssetCollectionSubtype initiallySelectedAssetCollectionSubtype;
@property (copy,nonatomic) NSSet<NSNumber *> *allowedAssetCollectionSubtypes;

@property (strong,nonatomic,null_resettable) KSOMediaPickerTheme *theme;

@property (readonly,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (copy,nonatomic) dispatch_block_t doneBarButtonItemBlock;
@property (readonly,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (copy,nonatomic) dispatch_block_t cancelBarButtonItemBlock;

@property (readonly,copy,nonatomic,nullable) NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (strong,nonatomic,nullable) KSOMediaPickerAssetCollectionModel *selectedAssetCollectionModel;
@property (readonly,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;
@property (readonly,nonatomic,nullable) NSArray<KSOMediaPickerAssetModel *> *selectedAssetModels;

@property (readonly,strong,nonatomic) PHCachingImageManager *assetCollectionImageManager;
@property (readonly,strong,nonatomic) PHCachingImageManager *assetImageManager;
@property (readonly,nonatomic) PHImageRequestOptions *assetImageRequestOptions;

- (BOOL)isAssetModelSelected:(KSOMediaPickerAssetModel *)assetModel;
- (BOOL)shouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (BOOL)shouldDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate;
- (void)deselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)deselectAssetModel:(KSOMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate;
- (void)deselectAllAssetModels;
- (void)deselectAllAssetModelsAndNotifyDelegate:(BOOL)notifyDelegate;

- (void)startCachingForAssets:(NSArray<PHAsset *> *)assets collectionViewController:(UICollectionViewController *)collectionViewController;
- (void)stopCachingForAssets:(NSArray<PHAsset *> *)assets collectionViewController:(UICollectionViewController *)collectionViewController;
- (void)stopCachingAssets;

@end

@protocol KSOMediaPickerModelDelegate <NSObject>
@required
- (void)mediaPickerModelDidError:(NSError *)error;
- (BOOL)mediaPickerModelShouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (BOOL)mediaPickerModelShouldDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)mediaPickerModelDidSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)mediaPickerModelDidDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
@end

NS_ASSUME_NONNULL_END
