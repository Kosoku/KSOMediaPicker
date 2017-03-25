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

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerAssetCollectionTableViewCell ()
@property (strong,nonatomic) KSOMediaPickerThumbnailView *thumbnailView1, *thumbnailView2, *thumbnailView3;
@property (strong,nonatomic) UILabel *titleLabel, *subtitleLabel;
@property (strong,nonatomic) UIView *labelContainerView;
@end

@implementation KSOMediaPickerAssetCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    _labelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [_labelContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_labelContainerView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_labelContainerView addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_subtitleLabel setTextColor:[UIColor darkGrayColor]];
    [_subtitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_labelContainerView addSubview:_subtitleLabel];
    
    _thumbnailView3 = [[KSOMediaPickerThumbnailView alloc] initWithFrame:CGRectZero];
    [_thumbnailView3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_thumbnailView3];
    
    _thumbnailView2 = [[KSOMediaPickerThumbnailView alloc] initWithFrame:CGRectZero];
    [_thumbnailView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_thumbnailView2];
    
    _thumbnailView1 = [[KSOMediaPickerThumbnailView alloc] initWithFrame:CGRectZero];
    [_thumbnailView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_thumbnailView1];
    
    CGFloat const kWidthHeight = 64.0;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view(==width)]" options:0 metrics:@{@"width": @(kWidthHeight)} views:@{@"view": _thumbnailView1}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view(==height)]-|" options:0 metrics:@{@"height": @(kWidthHeight)} views:@{@"view": _thumbnailView1}]];
    
    CGFloat const kWidthHeight2 = kWidthHeight - 3.0;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_thumbnailView1 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_thumbnailView1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kWidthHeight2]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kWidthHeight2]];
    
    CGFloat const kWidthHeight3 = kWidthHeight2 - 3.0;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView3 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_thumbnailView2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_thumbnailView2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kWidthHeight3]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kWidthHeight3]];
    
    [_labelContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _titleLabel}]];
    [_labelContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil views:@{@"view": _titleLabel}]];
    
    [_labelContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _subtitleLabel}]];
    [_labelContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview][view]|" options:0 metrics:nil views:@{@"view": _subtitleLabel, @"subview": _titleLabel}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-|" options:0 metrics:nil views:@{@"view": _labelContainerView, @"subview": _thumbnailView1}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model.model.theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self setBackgroundColor:value.backgroundColor];
            [self setSelectedBackgroundView:value.assetCollectionTableViewCellSelectedBackgroundViewClass == Nil ? Nil : [[value.assetCollectionTableViewCellSelectedBackgroundViewClass alloc] initWithFrame:CGRectZero]];
            
            [self.titleLabel setFont:value.titleFont];
            [self.titleLabel setTextColor:value.titleColor];
            [self.titleLabel setHighlightedTextColor:value.highlightedTitleColor];
            
            [self.subtitleLabel setFont:value.subtitleFont];
            [self.subtitleLabel setTextColor:value.subtitleColor];
            [self.subtitleLabel setHighlightedTextColor:value.highlightedSubtitleColor];
            
            [self.thumbnailView1 setBorderColor:value.backgroundColor];
            [self.thumbnailView2 setBorderColor:value.backgroundColor];
            [self.thumbnailView3 setBorderColor:value.backgroundColor];
        });
    }];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.model cancelAllThumbnailRequests];
}

- (void)setModel:(KSOMediaPickerAssetCollectionModel *)model {
    _model = model;
    
    [self.titleLabel setText:_model.title];
    [self.subtitleLabel setText:_model.subtitle];
    
    kstWeakify(self);
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView1.thumbnailImageView.frame.size) thumbnailIndex:0 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView1.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView2.thumbnailImageView.frame.size) thumbnailIndex:1 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView2.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailView3.thumbnailImageView.frame.size) thumbnailIndex:2 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailView3.thumbnailImageView setImage:thumbnailImage];
    }];
}

@end
