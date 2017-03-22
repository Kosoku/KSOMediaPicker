//
//  KSOMediaPickerAssetCollectionViewController.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerAssetCollectionViewController.h"
#import "KSOMediaPickerAssetCollectionViewLayout.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetCollectionViewCell.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerTheme.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>

@interface KSOMediaPickerAssetCollectionViewController ()
@property (strong,nonatomic) KSOMediaPickerModel *model;

@property (assign,nonatomic) BOOL hasPerformedSetup;
@end

@implementation KSOMediaPickerAssetCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setClearsSelectionOnViewWillAppear:NO];
    [self.collectionView setAllowsMultipleSelection:self.model.allowsMultipleSelection];
    [self.collectionView registerClass:[KSOMediaPickerAssetCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([KSOMediaPickerAssetCollectionViewCell class])];
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self.collectionView setBackgroundColor:value.assetBackgroundColor];
    }];
}
- (void)viewWillLayoutSubviews {
    if (!self.hasPerformedSetup) {
        [self setHasPerformedSetup:YES];
        
        kstWeakify(self);
        [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,selectedAssetCollectionModel.countOfAssetModels)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
            kstStrongify(self);
            [self.collectionView reloadData];
            
            // scroll to the last item
            if (self.model.selectedAssetCollectionModel.countOfAssetModels > 0) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.model.selectedAssetCollectionModel.countOfAssetModels - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.selectedAssetCollectionModel.countOfAssetModels;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KSOMediaPickerAssetCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:[self.model.selectedAssetCollectionModel assetModelAtIndex:indexPath.item]];
    
    return cell;
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
