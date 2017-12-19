//
//  KSOMediaPickerModel.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/17/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerAssetModel.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"
#import "KSOMediaPickerTheme.h"

#import <Quicksilver/Quicksilver.h>
#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <Shield/KSHPhotosAuthorization.h>

#import <Photos/Photos.h>

NSString *const KSOMediaPickerErrorDomain = @"com.kosoku.ksomediapicker.error";

@interface KSOMediaPickerModel () <PHPhotoLibraryChangeObserver>
@property (readwrite,assign,nonatomic) KSOMediaPickerAuthorizationStatus authorizationStatus;

@property (readwrite,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;

@property (readwrite,copy,nonatomic,nullable) NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (readwrite,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;

@property (readwrite,strong,nonatomic) PHCachingImageManager *assetCollectionImageManager;
@property (readwrite,strong,nonatomic) PHCachingImageManager *assetImageManager;

- (void)_reloadAssetCollectionModels;
@end

@implementation KSOMediaPickerModel

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    BOOL hasChanges = NO;
    
    for (KSOMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
        PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:model.fetchResult];
        
        if (!details) {
            continue;
        }
        
        if (details.hasIncrementalChanges &&
            (details.removedIndexes.count > 0 || details.insertedIndexes.count > 0 || details.changedIndexes.count > 0)) {
            [model reloadFetchResult];
            hasChanges = YES;
        }
        else if (details.fetchResultAfterChanges) {
            [model reloadFetchResult];
            hasChanges = YES;
        }
    }
    
    if (hasChanges) {
        [self stopCachingAssets];
        
        [self willChangeValueForKey:@kstKeypath(self,assetCollectionModels)];
        [self didChangeValueForKey:@kstKeypath(self,assetCollectionModels)];
    }
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _authorizationStatus = (KSOMediaPickerAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
    
    _allowsMixedMediaSelection = YES;
    _hidesEmptyAssetCollections = YES;
    _mediaTypes = KSOMediaPickerMediaTypesAll;
    
    _theme = KSOMediaPickerTheme.defaultTheme;
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    [self _reloadAssetCollectionModels];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,hidesEmptyAssetCollections),@kstKeypath(self,mediaTypes),@kstKeypath(self,allowedAssetCollectionSubtypes)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self _reloadAssetCollectionModels];
    }];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,doneBarButtonItemBlock),@kstKeypath(self,cancelBarButtonItemBlock)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([keyPath isEqualToString:@kstKeypath(self,doneBarButtonItemBlock)]) {
            if (value == nil) {
                [self.doneBarButtonItem setKDI_block:nil];
            }
            else {
                [self.doneBarButtonItem setKDI_block:^(UIBarButtonItem *item){
                    kstStrongify(self);
                    self.doneBarButtonItemBlock();
                }];
            }
        }
        else {
            if (value == nil) {
                [self.cancelBarButtonItem setKDI_block:nil];
            }
            else {
                [self.cancelBarButtonItem setKDI_block:^(UIBarButtonItem *item){
                    kstStrongify(self);
                    self.cancelBarButtonItemBlock();
                }];
            }
        }
    }];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,selectedAssetCollectionModel)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self deselectAllAssetModelsAndNotifyDelegate:NO];
    }];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,selectedAssetIdentifiers)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, NSOrderedSet<NSString *> * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self.doneBarButtonItem setEnabled:value.count > 0];
    }];
    
    return self;
}

- (BOOL)isAssetModelSelected:(KSOMediaPickerAssetModel *)assetModel; {
    return [self.selectedAssetIdentifiers containsObject:assetModel.identifier];
}
- (BOOL)shouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel; {
    BOOL retval = YES;
    
    // if we allow multiple selection but do not allow mixed media selection check to make sure all selected media are of the same media type
    if (self.allowsMultipleSelection &&
        !self.allowsMixedMediaSelection) {
        
        NSArray<KSOMediaPickerAssetModel *> *selectedAssetModels = self.selectedAssetModels;
        
        retval = [selectedAssetModels KQS_all:^BOOL(KSOMediaPickerAssetModel * _Nonnull object, NSInteger index) {
            return object.mediaType == selectedAssetModels.firstObject.mediaType && assetModel.mediaType == selectedAssetModels.firstObject.mediaType;
        }];
        
        if (!retval) {
            NSError *error = [NSError errorWithDomain:KSOMediaPickerErrorDomain code:KSOMediaPickerErrorCodeMixedMediaSelection userInfo:@{NSLocalizedDescriptionKey: NSLocalizedStringWithDefaultValue(@"media.picker.error.message.mixed-media-selection", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"You cannot select multiple media types.", @"multiple media types error")}];
            
            [self.delegate mediaPickerModelDidError:error];
        }
    }
    
    // if the asset model can still be selected and a maximum selected media limit has been set and selecting another media would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedMedia > 0 &&
        self.selectedAssetIdentifiers.count == self.maximumSelectedMedia) {
        
        retval = NO;
        
        NSError *error = [NSError errorWithDomain:KSOMediaPickerErrorDomain code:KSOMediaPickerErrorCodeMaximumSelectedMedia userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"media.picker.error.message.maximum-selected-media", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"You cannot select more than %lu media.", @"Also translate media.picker.error.message.maximum-selected-media entry in .stringsdict file if necessary"),self.maximumSelectedMedia]}];
        
        [self.delegate mediaPickerModelDidError:error];
    }
    
    // if the asset model can still be selected and a maximum selected images limit has been set and the asset model is an image and selecting it would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedImages > 0 &&
        assetModel.mediaType == KSOMediaPickerMediaTypeImage &&
        [self.selectedAssetModels KQS_reduceIntegerWithStart:0 block:^NSInteger(NSInteger sum, KSOMediaPickerAssetModel * _Nonnull object, NSInteger index) {
        return object.mediaType == KSOMediaPickerMediaTypeImage ? sum + 1 : sum;
    }] == self.maximumSelectedImages) {
        
        retval = NO;
        
        NSString *format = NSLocalizedStringWithDefaultValue(@"media.picker.error.message.maximum-selected-images", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"You cannot select more than %lu image(s).", @"Also translate media.picker.error.message.maximum-selected-images entry in .stringsdict file if necessary");
        NSString *title = [NSString stringWithFormat:format,self.maximumSelectedImages];
        NSError *error = [NSError errorWithDomain:KSOMediaPickerErrorDomain code:KSOMediaPickerErrorCodeMaximumSelectedImages userInfo:@{NSLocalizedDescriptionKey: title}];
        
        [self.delegate mediaPickerModelDidError:error];
    }
    
    // if the asset model can still be selected and a maximum selected videos limit has been set and the asset model is a video and selecting it would put us over the limit, surface the appropriate error
    if (retval &&
        self.maximumSelectedVideos > 0 &&
        assetModel.mediaType == KSOMediaPickerMediaTypeVideo &&
        [self.selectedAssetModels KQS_reduceIntegerWithStart:0 block:^NSInteger(NSInteger sum, KSOMediaPickerAssetModel * _Nonnull object, NSInteger index) {
        return object.mediaType == KSOMediaPickerMediaTypeVideo ? sum + 1 : sum;
    }] == self.maximumSelectedVideos) {
        
        retval = NO;
        
        NSString *format = NSLocalizedStringWithDefaultValue(@"media.picker.error.message.maximum-selected-videos", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"You cannot select more than %lu video(s).", @"Also translate media.picker.error.message.maximum-selected-videos entry in .stringsdict file if necessary");
        NSString *title = [NSString stringWithFormat:format,self.maximumSelectedVideos];
        NSError *error = [NSError errorWithDomain:KSOMediaPickerErrorDomain code:KSOMediaPickerErrorCodeMaximumSelectedVideos userInfo:@{NSLocalizedDescriptionKey: title}];
        
        [self.delegate mediaPickerModelDidError:error];
    }
    
    return retval ? [self.delegate mediaPickerModelShouldSelectAssetModel:assetModel] : NO;
}
- (BOOL)shouldDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel; {
    return [self.delegate mediaPickerModelShouldDeselectAssetModel:assetModel];
}
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel; {
    [self selectAssetModel:assetModel notifyDelegate:YES];
}
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate; {
    NSMutableOrderedSet *temp = self.allowsMultipleSelection ? [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers] : [[NSMutableOrderedSet alloc] init];
    
    [temp addObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    if (self.allowsMultipleSelection) {
        if (notifyDelegate) {
            [self.delegate mediaPickerModelDidSelectAssetModel:assetModel];
        }
    }
    else {
        self.doneBarButtonItemBlock();
    }
}
- (void)deselectAssetModel:(KSOMediaPickerAssetModel *)assetModel; {
    [self deselectAssetModel:assetModel notifyDelegate:YES];
}
- (void)deselectAssetModel:(KSOMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate; {
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers];
    
    [temp removeObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    if (notifyDelegate) {
        [self.delegate mediaPickerModelDidDeselectAssetModel:assetModel];
    }
}
- (void)deselectAllAssetModels; {
    [self deselectAllAssetModelsAndNotifyDelegate:YES];
}
- (void)deselectAllAssetModelsAndNotifyDelegate:(BOOL)notifyDelegate; {
    for (KSOMediaPickerAssetModel *assetModel in self.selectedAssetModels) {
        [self deselectAssetModel:assetModel notifyDelegate:notifyDelegate];
    }
}

- (void)startCachingForAssets:(NSArray<PHAsset *> *)assets collectionViewController:(nonnull UICollectionViewController *)collectionViewController {
    CGSize size = KDICGSizeAdjustedForMainScreenScale([(UICollectionViewFlowLayout *)collectionViewController.collectionViewLayout itemSize]);
    
    [self.assetImageManager startCachingImagesForAssets:assets targetSize:size contentMode:PHImageContentModeAspectFill options:self.assetImageRequestOptions];
}
- (void)stopCachingForAssets:(NSArray<PHAsset *> *)assets collectionViewController:(nonnull UICollectionViewController *)collectionViewController {
    CGSize size = KDICGSizeAdjustedForMainScreenScale([(UICollectionViewFlowLayout *)collectionViewController.collectionViewLayout itemSize]);
    
    [self.assetImageManager stopCachingImagesForAssets:assets targetSize:size contentMode:PHImageContentModeAspectFill options:self.assetImageRequestOptions];
}
- (void)stopCachingAssets; {
    [self.assetImageManager stopCachingImagesForAllAssets];
}

- (void)setTheme:(KSOMediaPickerTheme *)theme {
    _theme = theme ?: KSOMediaPickerTheme.defaultTheme;
}

- (NSArray<KSOMediaPickerAssetModel *> *)selectedAssetModels {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (NSString *assetIdentifier in self.selectedAssetIdentifiers) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        
        [options setWantsIncrementalChangeDetails:NO];
        [options setFetchLimit:1];
        
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:options].firstObject;
        
        if (retval != nil) {
            [retval addObject:asset];
        }
    }
    
    return [retval KQS_map:^id _Nullable(PHAsset * _Nonnull object, NSInteger index) {
        return [[KSOMediaPickerAssetModel alloc] initWithAsset:object assetCollectionModel:nil];
    }];
}
- (PHImageRequestOptions *)assetImageRequestOptions {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    return options;
}

- (void)_reloadAssetCollectionModels; {
    __block __weak void(^weakBlock)(KSHPhotosAuthorizationStatus) = nil;
    
    void(^block)(KSHPhotosAuthorizationStatus) = ^(KSHPhotosAuthorizationStatus status){
        switch (status) {
            case KSHPhotosAuthorizationStatusAuthorized: {
                if (self.assetCollectionImageManager == nil) {
                    self.assetCollectionImageManager = [[PHCachingImageManager alloc] init];
                }
                if (self.assetImageManager == nil) {
                    self.assetImageManager = [[PHCachingImageManager alloc] init];
                }
                
                NSMutableArray<PHAssetCollection *> *retval = [[NSMutableArray alloc] init];
                
                [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [retval addObject:obj];
                }];
                
                [[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil] enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [retval addObject:obj];
                }];
                
                NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels = [retval KQS_map:^id _Nullable(PHAssetCollection * _Nonnull object, NSInteger index) {
                    return [[KSOMediaPickerAssetCollectionModel alloc] initWithAssetCollection:object model:self];
                }];
                
                KSOMediaPickerAssetCollectionModel *oldSelectedAssetCollectionModel = self.selectedAssetCollectionModel;
                
                [self setAssetCollectionModels:[[assetCollectionModels KQS_reject:^BOOL(KSOMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
                    return object.title.length == 0 || (self.hidesEmptyAssetCollections && object.countOfAssetModels == 0);
                }] KQS_filter:^BOOL(KSOMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
                    return self.allowedAssetCollectionSubtypes == nil || [self.allowedAssetCollectionSubtypes containsObject:@(object.subtype)];
                }]];
                
                // try to select previously selected asset collection model
                if (oldSelectedAssetCollectionModel != nil) {
                    for (KSOMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
                        if ([model.identifier isEqualToString:oldSelectedAssetCollectionModel.identifier]) {
                            [self setSelectedAssetCollectionModel:model];
                            break;
                        }
                    }
                }
            }
                break;
            case KSHPhotosAuthorizationStatusNotDetermined: {
                void(^strongBlock)(KSHPhotosAuthorizationStatus) = weakBlock;
                
                [KSHPhotosAuthorization.sharedAuthorization requestPhotoLibraryAuthorizationWithCompletion:^(KSHPhotosAuthorizationStatus status, NSError * _Nullable error) {
                    strongBlock(status);
                }];
            }
                break;
            case KSHPhotosAuthorizationStatusDenied:
                break;
            case KSHPhotosAuthorizationStatusRestricted:
                break;
            default:
                break;
        }
        
        [self setAuthorizationStatus:(KSOMediaPickerAuthorizationStatus)status];
    };
    
    weakBlock = block;
    
    block(KSHPhotosAuthorization.sharedAuthorization.photoLibraryAuthorizationStatus);
}

@end
