//
//  KSOMediaPickerAssetCollectionViewController.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
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

#import "KSOMediaPickerAssetCollectionViewController.h"
#import "KSOMediaPickerAssetCollectionViewLayout.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetCollectionViewCell.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerTheme.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOMediaPickerAssetCollectionViewController () <UICollectionViewDataSourcePrefetching>
@property (strong,nonatomic) KSOMediaPickerModel *model;

@property (assign,nonatomic) BOOL hasPerformedSetup;
@end

@implementation KSOMediaPickerAssetCollectionViewController

- (NSString *)title {
    return self.model.selectedAssetCollectionModel.title;
}

- (void)dealloc {
    KSTLogObject(self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setAllowsMultipleSelection:self.model.allowsMultipleSelection];
    [self.collectionView registerClass:[KSOMediaPickerAssetCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([KSOMediaPickerAssetCollectionViewCell class])];
    [self.collectionView setPrefetchDataSource:self];
    
    if (self.model.allowsMultipleSelection) {
        [self.navigationItem setRightBarButtonItems:@[self.model.doneBarButtonItem]];
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
    }
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,selectedAssetIdentifiers)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            for (NSIndexPath *indexPath in self.collectionView.indexPathsForVisibleItems) {
                KSOMediaPickerAssetCollectionViewCell *cell = (KSOMediaPickerAssetCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                
                [cell reloadSelectedOverlayView];
                
                if ([self.model isAssetModelSelected:cell.model]) {
                    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                }
                else {
                    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
                }
            }
        });
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.collectionView setBackgroundColor:value.backgroundColor];
        });
    }];
}
- (void)viewWillLayoutSubviews {
    if (!self.hasPerformedSetup) {
        [self setHasPerformedSetup:YES];
        
        kstWeakify(self);
        [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,selectedAssetCollectionModel.countOfAssetModels)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            kstStrongify(self);
            KSTDispatchMainAsync(^{
                [self.collectionView reloadData];
                
                // scroll to the last item
                if (self.model.selectedAssetCollectionModel.countOfAssetModels > 0) {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.model.selectedAssetCollectionModel.countOfAssetModels - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                }
            });
        }];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.model stopCachingAssets];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.selectedAssetCollectionModel.countOfAssetModels;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KSOMediaPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:[self.model.selectedAssetCollectionModel assetModelAtIndex:indexPath.item]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.model startCachingForAssets:[indexPaths KQS_map:^id _Nullable(NSIndexPath * _Nonnull object, NSInteger index) {
        return [self.model.selectedAssetCollectionModel assetAtIndex:object.item];
    }] collectionViewController:self];
}
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self.model stopCachingForAssets:[indexPaths KQS_map:^id _Nullable(NSIndexPath * _Nonnull object, NSInteger index) {
        return [self.model.selectedAssetCollectionModel assetAtIndex:object.item];
    }] collectionViewController:self];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetModel *model = [(KSOMediaPickerAssetCollectionViewCell *)cell model];
    
    [(KSOMediaPickerAssetCollectionViewCell *)cell reloadSelectedOverlayView];
    
    if ([self.model isAssetModelSelected:model]) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    else {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = (KSOMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    return [self.model shouldSelectAssetModel:cell.model];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = (KSOMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    return [self.model shouldDeselectAssetModel:cell.model];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = (KSOMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.model selectAssetModel:cell.model];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = (KSOMediaPickerAssetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.model deselectAssetModel:cell.model];
}

- (instancetype)initWithModel:(KSOMediaPickerModel *)model; {
    KSOMediaPickerAssetCollectionViewLayout *layout = [[KSOMediaPickerAssetCollectionViewLayout alloc] init];
    
    [layout setMinimumLineSpacing:1.0];
    [layout setMinimumInteritemSpacing:1.0];
    
    if (!(self = [super initWithCollectionViewLayout:layout]))
        return nil;
    
    _model = model;
    
    return self;
}

@end
