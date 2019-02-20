//
//  KSOMediaPickerAssetCollectionModel.m
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

#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerAssetModel.h"
#import "KSOMediaPickerModel.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"

#import <Stanley/Stanley.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

#import <Photos/Photos.h>

@interface KSOMediaPickerAssetCollectionModel ()
@property (readwrite,weak,nonatomic,nullable) KSOMediaPickerModel *model;
@property (readwrite,strong,nonatomic) PHAssetCollection *assetCollection;
@property (readwrite,strong,nonatomic) PHFetchResult<PHAsset *> *fetchResult;
@property (strong,nonatomic) NSMutableDictionary *thumbnailIndexesToImageRequestIDs;

- (void)_cancelThumbnailImageRequestAtIndex:(NSUInteger)thumbnailIndex;
@end

@implementation KSOMediaPickerAssetCollectionModel

+ (NSSet *)keyPathsForValuesAffectingCountOfAssetModels {
    return [NSSet setWithObject:@kstKeypath(KSOMediaPickerAssetCollectionModel.new,fetchResult)];
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)assetCollection model:(KSOMediaPickerModel *)model; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(assetCollection);
    
    _assetCollection = assetCollection;
    _model = model;
    _thumbnailIndexesToImageRequestIDs = [[NSMutableDictionary alloc] init];
    
    [self reloadFetchResult];
    
    return self;
}

- (KSOMediaPickerAssetModel *)assetModelAtIndex:(NSUInteger)index; {
    return [[KSOMediaPickerAssetModel alloc] initWithAsset:[self.fetchResult objectAtIndex:index] assetCollectionModel:self];
}
- (PHAsset *)assetAtIndex:(NSUInteger)index {
    return [self.fetchResult objectAtIndex:index];
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

- (void)requestThumbnailImageOfSize:(CGSize)size thumbnailIndex:(NSUInteger)thumbnailIndex completion:(void(^)(UIImage * _Nullable  thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (self.countOfAssetModels == 0 ||
        thumbnailIndex >= self.countOfAssetModels) {
        
        completion(nil);
        return;
    }
    
    [self _cancelThumbnailImageRequestAtIndex:thumbnailIndex];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    PHAsset *asset = [self.fetchResult objectAtIndex:self.countOfAssetModels - thumbnailIndex - 1];
    PHImageRequestID imageRequestID = [self.model.assetCollectionImageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }];
    
    [self.thumbnailIndexesToImageRequestIDs setObject:@(imageRequestID) forKey:@(thumbnailIndex)];
}
- (void)cancelAllThumbnailRequests; {
    for (NSNumber *thumbnailIndex in self.thumbnailIndexesToImageRequestIDs.allKeys) {
        [self _cancelThumbnailImageRequestAtIndex:thumbnailIndex.unsignedIntegerValue];
    }
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
    CGSize size = CGSizeMake(24, 24);
    
    switch (self.subtype) {
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumVideos:
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumSlomoVideos:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf03d" size:size];
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumRecentlyAdded:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf017" size:size];
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumFavorites:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf004" size:size];
        case KSOMediaPickerAssetCollectionSubtypeAlbumMyPhotoStream:
        case KSOMediaPickerAssetCollectionSubtypeAlbumCloudShared:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf0c2" size:size];
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumSelfPortraits:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf118" size:size];
        case KSOMediaPickerAssetCollectionSubtypeSmartAlbumScreenshots:
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf10b" size:size];
        default:
            return nil;
    }
}

- (NSUInteger)countOfAssetModels {
    return self.fetchResult.count;
}

- (void)_cancelThumbnailImageRequestAtIndex:(NSUInteger)thumbnailIndex; {
    PHImageRequestID imageRequestID = [self.thumbnailIndexesToImageRequestIDs[@(thumbnailIndex)] intValue];
    
    if (imageRequestID == PHInvalidImageRequestID) {
        return;
    }
    
    [self.thumbnailIndexesToImageRequestIDs removeObjectForKey:@(thumbnailIndex)];
    
    [self.model.assetCollectionImageManager cancelImageRequest:imageRequestID];
}

@end
