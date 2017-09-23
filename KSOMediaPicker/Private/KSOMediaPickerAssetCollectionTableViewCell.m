//
//  KSOMediaPickerAssetCollectionTableViewCell.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/23/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerAssetCollectionTableViewCell.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerTheme.h"
#import "KSOMediaPickerThumbnailView.h"
#import "KSOMediaPickerDefinesPrivate.h"

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerAssetCollectionTableViewCell ()
@property (weak,nonatomic) IBOutlet KSOMediaPickerThumbnailView *thumbnailView1, *thumbnailView2, *thumbnailView3;
@property (weak,nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel, *subtitleLabel;
@end

@implementation KSOMediaPickerAssetCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.typeImageView setTintColor:UIColor.whiteColor];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model.model.theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self setBackgroundColor:value.cellBackgroundColor];
            [self setSelectedBackgroundView:value.assetCollectionTableViewCellSelectedBackgroundViewClass == Nil ? Nil : [[value.assetCollectionTableViewCellSelectedBackgroundViewClass alloc] initWithFrame:CGRectZero]];
            
            [self.titleLabel setFont:value.titleFont];
            [self.titleLabel setTextColor:value.titleColor];
            [self.titleLabel setHighlightedTextColor:value.highlightedTitleColor];
            
            [self.subtitleLabel setFont:value.subtitleFont];
            [self.subtitleLabel setTextColor:value.subtitleColor];
            [self.subtitleLabel setHighlightedTextColor:value.highlightedSubtitleColor];
            
            [self.thumbnailView1 setBorderColor:value.cellBackgroundColor];
            [self.thumbnailView2 setBorderColor:value.cellBackgroundColor];
            [self.thumbnailView3 setBorderColor:value.cellBackgroundColor];
        });
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.model cancelAllThumbnailRequests];
}

- (void)setModel:(KSOMediaPickerAssetCollectionModel *)model {
    _model = model;
    
    [self.titleLabel setText:_model.title];
    [self.subtitleLabel setText:_model.subtitle];
    [self.typeImageView setImage:[_model.typeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    kstWeakify(self);
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView1.frame.size) thumbnailIndex:0 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView1.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView2.frame.size) thumbnailIndex:1 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView2.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView3.frame.size) thumbnailIndex:2 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView3.thumbnailImageView setImage:thumbnailImage];
    }];
}

@end
