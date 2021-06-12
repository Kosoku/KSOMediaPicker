//
//  KSOMediaPickerAssetModel.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/18/17.
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

NSString* KSOMediaPickerStringFromMediaType(KSOMediaPickerMediaType mediaType) {
    switch (mediaType) {
        case KSOMediaPickerMediaTypeUnknown:
            return nil;
        case KSOMediaPickerMediaTypeAudio:
            return NSLocalizedStringWithDefaultValue(@"media.type.audio", nil, NSBundle.KSO_mediaPickerFrameworkBundle, @"Audio", @"Audio");
        case KSOMediaPickerMediaTypeImage:
            return NSLocalizedStringWithDefaultValue(@"media.type.image", nil, NSBundle.KSO_mediaPickerFrameworkBundle, @"Photo", @"Photo");
        case KSOMediaPickerMediaTypeVideo:
            return NSLocalizedStringWithDefaultValue(@"media.type.video", nil, NSBundle.KSO_mediaPickerFrameworkBundle, @"Video", @"Video");
    }
}
NSString* KSOMediaPickerStringFromDuration(NSTimeInterval duration) {
    static NSDateComponentsFormatter *kFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kFormatter = [[NSDateComponentsFormatter alloc] init];
        
        kFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
        kFormatter.allowedUnits = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    });
    return [kFormatter stringFromTimeInterval:duration];
}

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
            return [UIImage KSO_fontAwesomeSolidImageWithString:@"\uf03d" size:CGSizeMake(16, 16)];
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

- (NSString *)accessibilityLabel {
    KSOMediaPickerMediaType type = self.mediaType;
    NSString *typeString = KSOMediaPickerStringFromMediaType(type);
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.creationDate dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterFullStyle];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    switch (type) {
        case KSOMediaPickerMediaTypeVideo:
        case KSOMediaPickerMediaTypeAudio:
            temp.array = @[typeString,KSOMediaPickerStringFromDuration(self.duration),dateString];
            break;
        case KSOMediaPickerMediaTypeImage:
            temp.array = @[typeString,dateString];
            break;
        default:
            break;
    }
    
    return [temp componentsJoinedByString:@", "];
}

@end
