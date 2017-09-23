//
//  KSOMediaPickerAssetModel.m
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

#import "KSOMediaPickerAssetModel.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerModel.h"

#import <Stanley/Stanley.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>
#if (TARGET_OS_IOS)
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface KSOMediaPickerAssetModel ()
@property (readwrite,strong,nonatomic) PHAsset *asset;
@property (readwrite,weak,nonatomic) KSOMediaPickerAssetCollectionModel *assetCollectionModel;
@property (assign,nonatomic) PHImageRequestID imageRequestID, dataRequestID;
@end

@implementation KSOMediaPickerAssetModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@=%@",NSStringFromClass(self.class),self,@kstKeypath(self,identifier),self.identifier];
}

- (PHAsset *)mediaPickerMediaAsset {
    return self.asset;
}
- (KSOMediaPickerMediaType)mediaPickerMediaType {
    return (KSOMediaPickerMediaType)self.asset.mediaType;
}

- (instancetype)initWithAsset:(PHAsset *)asset assetCollectionModel:(KSOMediaPickerAssetCollectionModel *)assetCollectionModel; {
    if (!(self = [super init]))
        return nil;
    
    if (asset == nil) {
        return nil;
    }
    
    _asset = asset;
    _assetCollectionModel = assetCollectionModel;
    
    return self;
}

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(id _Nullable thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        completion(nil);
        return;
    }

    [self cancelAllThumbnailRequests];
    
    [self setImageRequestID:[self.assetCollectionModel.model.assetImageManager requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFill options:self.assetCollectionModel.model.assetImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }]];
    
#if (TARGET_OS_IOS)
    if (self.asset.mediaType == PHAssetMediaTypeImage) {
        for (PHAssetResource *res in [PHAssetResource assetResourcesForAsset:self.asset]) {
            if ([res.uniformTypeIdentifier isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                [self setDataRequestID:[self.assetCollectionModel.model.assetImageManager requestImageDataForAsset:self.asset options:self.assetCollectionModel.model.assetImageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    completion([[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData optimalFrameCacheSize:0 predrawingEnabled:YES]);
                }]];
                break;
            }
        }
    }
#endif
}
- (void)cancelAllThumbnailRequests; {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [self.assetCollectionModel.model.assetImageManager cancelImageRequest:self.imageRequestID];
    }
    if (self.dataRequestID != PHInvalidImageRequestID) {
        [self.assetCollectionModel.model.assetImageManager cancelImageRequest:self.dataRequestID];
    }
    
    [self setImageRequestID:PHInvalidImageRequestID];
    [self setDataRequestID:PHInvalidImageRequestID];
}

- (NSString *)identifier {
    return self.asset.localIdentifier;
}
- (KSOMediaPickerMediaType)mediaType {
    return (KSOMediaPickerMediaType)self.asset.mediaType;
}
- (UIImage *)typeImage {
    switch (self.mediaType) {
        case KSOMediaPickerMediaTypeVideo:
            return [UIImage KSO_fontAwesomeImageWithString:@"\uf03d" size:CGSizeMake(16, 16)];
        default:
            return nil;
    }
}
- (NSTimeInterval)duration {
    return ceil(self.asset.duration);
}
- (NSString *)formattedDuration {
    if (self.mediaType == KSOMediaPickerMediaTypeVideo) {
        static NSDateComponentsFormatter *kFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kFormatter = [[NSDateComponentsFormatter alloc] init];
            
            [kFormatter setAllowedUnits:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond];
            [kFormatter setUnitsStyle:NSDateComponentsFormatterUnitsStylePositional];
            [kFormatter setZeroFormattingBehavior:NSDateComponentsFormatterZeroFormattingBehaviorPad];
        });
        
        if (self.duration < 60 * 60) {
            [kFormatter setAllowedUnits:NSCalendarUnitMinute|NSCalendarUnitSecond];
        }
        else {
            [kFormatter setAllowedUnits:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond];
        }
        
        return [kFormatter stringFromTimeInterval:self.duration];
    }
    return nil;
}
- (NSDate *)creationDate {
    return self.asset.creationDate;
}
- (NSUInteger)selectedIndex {
    if ([self.assetCollectionModel.model.selectedAssetIdentifiers containsObject:self.identifier]) {
        return [self.assetCollectionModel.model.selectedAssetIdentifiers indexOfObject:self.identifier];
    }
    return NSNotFound;
}

@end
