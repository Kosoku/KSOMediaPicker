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

#import <Photos/Photos.h>

@interface KSOMediaPickerAssetModel ()
@property (readwrite,strong,nonatomic) PHAsset *asset;
@property (assign,nonatomic) PHImageRequestID imageRequestID;
@end

@implementation KSOMediaPickerAssetModel

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> identifier=%@",NSStringFromClass(self.class),self,self.identifier];
}

- (PHAsset *)mediaPickerMediaAsset {
    return self.asset;
}
- (KSOMediaPickerMediaType)mediaPickerMediaType {
    return (KSOMediaPickerMediaType)self.asset.mediaType;
}

- (instancetype)initWithAsset:(PHAsset *)asset; {
    if (!(self = [super init]))
        return nil;
    
    if (asset == nil) {
        return nil;
    }
    
    _asset = asset;
    
    return self;
}

- (void)requestThumbnailImageOfSize:(CGSize)size completion:(void(^)(UIImage * _Nullable thumbnailImage))completion; {
    NSParameterAssert(completion);
    
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        completion(nil);
        return;
    }

    [self cancelAllThumbnailRequests];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeFastFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeFast];
    [options setNetworkAccessAllowed:YES];
    
    [self setImageRequestID:[[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completion(result);
    }]];
}
- (void)cancelAllThumbnailRequests; {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHCachingImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    [self setImageRequestID:PHInvalidImageRequestID];
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
            return [UIImage imageNamed:@"type_video" inBundle:[NSBundle KSO_mediaPickerFrameworkBundle] compatibleWithTraitCollection:nil];
        default:
            return nil;
    }
}
- (NSTimeInterval)duration {
    return self.asset.duration;
}
- (NSString *)formattedDuration {
    if (self.mediaType == KSOMediaPickerMediaTypeVideo) {
        NSTimeInterval duration = self.duration;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:duration];
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:duration] options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (comps.hour > 0) {
            [dateFormatter setDateFormat:@"H:mm:ss"];
        }
        else {
            [dateFormatter setDateFormat:@"m:ss"];
        }
        
        date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}
- (NSDate *)creationDate {
    return self.asset.creationDate;
}

@end
