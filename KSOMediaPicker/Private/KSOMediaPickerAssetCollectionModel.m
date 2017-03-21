//
//  KSOMediaPickerAssetCollectionModel.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/18/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerAssetModel.h"
#import "KSOMediaPickerModel.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"

#import <Stanley/Stanley.h>

#import <Photos/Photos.h>

@interface KSOMediaPickerAssetCollectionModel ()
@property (readwrite,weak,nonatomic,nullable) KSOMediaPickerModel *model;
@property (readwrite,strong,nonatomic) PHAssetCollection *assetCollection;
@property (readwrite,strong,nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@end

@implementation KSOMediaPickerAssetCollectionModel

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(KSOMediaPickerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(assetCollection);
    
    _assetCollection = assetCollection;
    _model = model;
    
    [self reloadFetchResult];
    
    return self;
}

- (void)reloadFetchResult {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    
    if (self.model.mediaTypes & KSOMediaPickerMediaTypesUnknown) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@kstKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeUnknown)]];
    }
    if (self.model.mediaTypes & KSOMediaPickerMediaTypesImage) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@kstKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeImage)]];
    }
    if (self.model.mediaTypes & KSOMediaPickerMediaTypesVideo) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@kstKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeVideo)]];
    }
    if (self.model.mediaTypes & KSOMediaPickerMediaTypesAudio) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"%K == %@",@kstKeypath(PHAsset.new,mediaType),@(PHAssetMediaTypeAudio)]];
    }
    
    [options setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predicates]];
    [options setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@kstKeypath(PHAsset.new,creationDate) ascending:YES]]];
    
    [self setFetchResult:[PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options]];
}

- (NSString *)identifier {
    return self.assetCollection.localIdentifier;
}
- (KSOMediaPickerAssetCollectionSubtype)subtype {
    return (KSOMediaPickerAssetCollectionSubtype)self.assetCollection.assetCollectionSubtype;
}
- (NSString *)title {
    return self.assetCollection.localizedTitle;
}
- (NSString *)subtitle {
    return [NSNumberFormatter localizedStringFromNumber:@(self.countOfAssetModels) numberStyle:NSNumberFormatterDecimalStyle];
}
- (UIImage *)typeImage {
    switch (self.subtype) {
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumVideos:
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumSlomoVideos:
            return [UIImage imageNamed:@"type_video" inBundle:[NSBundle KSO_mediaPickerFrameworkBundle] compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}

- (NSUInteger)countOfAssetModels {
    return self.fetchResult.count;
}

@end
