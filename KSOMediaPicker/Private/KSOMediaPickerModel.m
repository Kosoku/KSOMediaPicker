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

#import <Quicksilver/Quicksilver.h>
#import <Agamotto/Agamotto.h>
#import <Stanley/KSTScopeMacros.h>
#import <Ditko/UIBarButtonItem+KDIExtensions.h>

#import <Photos/Photos.h>

@interface KSOMediaPickerModel ()
@property (readwrite,copy,nonatomic,nullable) NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (readwrite,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;

@property (readwrite,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (readwrite,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;
@end

@implementation KSOMediaPickerModel

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:NULL];
    _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:NULL];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@"doneBarButtonItemBlock",@"cancelBarButtonItemBlock"] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([keyPath isEqualToString:@"doneBarButtonItemBlock"]) {
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
    
    return self;
}

- (NSArray<KSOMediaPickerAssetModel *> *)selectedAssetModels {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    for (NSString *assetIdentifier in self.selectedAssetIdentifiers) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        
        [options setWantsIncrementalChangeDetails:NO];
        [options setFetchLimit:1];
        
        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:options].firstObject;
        
        [retval addObject:asset];
    }
    
    return [retval KQS_map:^id _Nullable(PHAsset * _Nonnull object, NSInteger index) {
        return [[KSOMediaPickerAssetModel alloc] initWithAsset:object];
    }];
}

@end
