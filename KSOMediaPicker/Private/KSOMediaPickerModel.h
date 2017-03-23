//
//  KSOMediaPickerModel.h
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

#import <UIKit/UIKit.h>

#import <KSOMediaPicker/KSOMediaPickerDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOMediaPickerAssetCollectionModel,KSOMediaPickerAssetModel,KSOMediaPickerTheme;
@protocol KSOMediaPickerModelDelegate;

@interface KSOMediaPickerModel : NSObject

@property (weak,nonatomic) id<KSOMediaPickerModelDelegate> delegate;

@property (readonly,assign,nonatomic) KSOMediaPickerAuthorizationStatus authorizationStatus;

@property (assign,nonatomic) BOOL allowsMultipleSelection;
@property (assign,nonatomic) BOOL hidesEmptyAssetCollections;

@property (assign,nonatomic) KSOMediaPickerMediaTypes mediaTypes;

@property (assign,nonatomic) KSOMediaPickerAssetCollectionSubtype initiallySelectedAssetCollectionSubtype;
@property (copy,nonatomic) NSSet<NSNumber *> *allowedAssetCollectionSubtypes;

@property (strong,nonatomic,null_resettable) KSOMediaPickerTheme *theme;

@property (readonly,strong,nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (copy,nonatomic) dispatch_block_t doneBarButtonItemBlock;
@property (readonly,strong,nonatomic) UIBarButtonItem *cancelBarButtonItem;
@property (copy,nonatomic) dispatch_block_t cancelBarButtonItemBlock;

@property (readonly,copy,nonatomic) NSString *title;
@property (readonly,copy,nonatomic,nullable) NSString *subtitle;

@property (readonly,copy,nonatomic,nullable) NSArray<KSOMediaPickerAssetCollectionModel *> *assetCollectionModels;
@property (strong,nonatomic,nullable) KSOMediaPickerAssetCollectionModel *selectedAssetCollectionModel;
@property (readonly,copy,nonatomic,nullable) NSOrderedSet<NSString *> *selectedAssetIdentifiers;
@property (readonly,nonatomic,nullable) NSArray<KSOMediaPickerAssetModel *> *selectedAssetModels;

- (BOOL)isAssetModelSelected:(KSOMediaPickerAssetModel *)assetModel;
- (BOOL)shouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (BOOL)shouldDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)selectAssetModel:(KSOMediaPickerAssetModel *)assetModel notifyDelegate:(BOOL)notifyDelegate;
- (void)deselectAssetModel:(KSOMediaPickerAssetModel *)assetModel;
- (void)deselectAllAssetModels;

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
