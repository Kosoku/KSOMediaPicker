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

#import <Photos/Photos.h>

@interface KSOMediaPickerModel () <PHPhotoLibraryChangeObserver>
@property (readwrite,assign,nonatomic) KSOMediaPickerAuthorizationStatus authorizationStatus;

@property (readwrite,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;

@property (readwrite,copy,nonatomic) NSString *title;
@property (readwrite,copy,nonatomic,nullable) NSString *subtitle;

@property (readwrite,copy,nonatomic,nullable) NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (readwrite,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;

- (void)_updateTitle;
- (void)_updateSubtitle;
- (void)_reloadAssetCollectionModels;
@end

@implementation KSOMediaPickerModel

- (void)dealloc {
    KSTLogObject(self.class);
    
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    for (KSOMediaPickerAssetCollectionModel *model in self.assetCollectionModels) {
        PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:model.fetchResult];
        
        if (!details) {
            continue;
        }
        
        if (details.hasIncrementalChanges &&
            (details.removedIndexes.count > 0 || details.insertedIndexes.count > 0 || details.changedIndexes.count > 0)) {
            [model reloadFetchResult];
        }
        else if (details.fetchResultAfterChanges) {
            [model reloadFetchResult];
        }
    }
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _authorizationStatus = (KSOMediaPickerAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
    
    _hidesEmptyAssetCollections = YES;
    _mediaTypes = KSOMediaPickerMediaTypesAll;
    _initiallySelectedAssetCollectionSubtype = KSOMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary;
    
    _theme = KSOMediaPickerTheme.defaultTheme;
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    kstWeakify(self);
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
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,selectedAssetIdentifiers)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, NSOrderedSet<NSString *> * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self.doneBarButtonItem setEnabled:value.count > 0];
    }];
    
    [self _updateTitle];
    [self _updateSubtitle];
    [self _reloadAssetCollectionModels];
    
    return self;
}

- (BOOL)isAssetModelSelected:(KSOMediaPickerAssetModel *)assetModel; {
    return [self.selectedAssetIdentifiers containsObject:assetModel.identifier];
}
- (BOOL)shouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel; {
    return [self.delegate mediaPickerModelShouldSelectAssetModel:assetModel];
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
    NSMutableOrderedSet *temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.selectedAssetIdentifiers];
    
    [temp removeObject:assetModel.identifier];
    
    [self setSelectedAssetIdentifiers:temp];
    
    [self.delegate mediaPickerModelDidDeselectAssetModel:assetModel];
}
- (void)deselectAllAssetModels; {
    for (KSOMediaPickerAssetModel *assetModel in self.selectedAssetModels) {
        [self deselectAssetModel:assetModel];
    }
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
        return [[KSOMediaPickerAssetModel alloc] initWithAsset:object];
    }];
}

- (void)_updateTitle; {
    if (self.selectedAssetCollectionModel == nil) {
        switch ([PHPhotoLibrary authorizationStatus]) {
            case PHAuthorizationStatusAuthorized:
                [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_AUTHORIZED_TITLE", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Authorized", @"media picker authorized title")];
                break;
            case PHAuthorizationStatusDenied:
                [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_DENIED_TITLE", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Denied", @"media picker denied title")];
                break;
            case PHAuthorizationStatusNotDetermined:
                [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_REQUESTING_AUTHORIZATION_TITLE", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Requesting Authorization", @"media picker requesting authorization title")];
                break;
            case PHAuthorizationStatusRestricted:
                [self setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_RESTRICTED_TITLE", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Restricted", @"media picker restricted title")];
                break;
            default:
                break;
        }
    }
    else {
        [self setTitle:self.selectedAssetCollectionModel.title];
    }
}
- (void)_updateSubtitle; {
    [self setSubtitle:self.selectedAssetCollectionModel == nil ? nil : NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_DEFAULT_SUBTITLE", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Tap to select album ▼", @"media picker default subtitle")];
}
- (void)_reloadAssetCollectionModels; {
    __block __weak void(^weakBlock)(PHAuthorizationStatus) = nil;
    
    void(^block)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status){
        [self setAuthorizationStatus:(KSOMediaPickerAuthorizationStatus)status];
        
        switch (status) {
            case PHAuthorizationStatusAuthorized: {
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
                
                // select camera roll by default
                if (self.selectedAssetCollectionModel == nil) {
                    for (KSOMediaPickerAssetCollectionModel *collection in self.assetCollectionModels) {
                        if (collection.subtype == self.initiallySelectedAssetCollectionSubtype) {
                            [self setSelectedAssetCollectionModel:collection];
                            break;
                        }
                    }
                }
                
                // if still no selection, select the first asset collection
                if (self.selectedAssetCollectionModel == nil) {
                    [self setSelectedAssetCollectionModel:self.assetCollectionModels.firstObject];
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined: {
                void(^strongBlock)(PHAuthorizationStatus) = weakBlock;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    strongBlock(status);
                }];
            }
                break;
            case PHAuthorizationStatusDenied:
                break;
            case PHAuthorizationStatusRestricted:
                break;
            default:
                break;
        }
        
        [self _updateTitle];
        [self _updateSubtitle];
    };
    
    weakBlock = block;
    
    block([PHPhotoLibrary authorizationStatus]);
}

@end
