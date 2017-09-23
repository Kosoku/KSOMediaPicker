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
#if (TARGET_OS_IOS)
@property (weak,nonatomic) IBOutlet KSOMediaPickerThumbnailView *thumbnailView1, *thumbnailView2, *thumbnailView3;
@property (weak,nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel, *subtitleLabel;
#else
@property (strong,nonatomic) UIImageView *thumbnailImageView, *typeImageView;
@property (strong,nonatomic) UIStackView *stackView;
@property (strong,nonatomic) UILabel *titleLabel, *subtitleLabel;
#endif
@end

@implementation KSOMediaPickerAssetCollectionTableViewCell

#if (TARGET_OS_TV)
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_thumbnailImageView setClipsToBounds:YES];
    [_thumbnailImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:_thumbnailImageView];
    
//    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [_typeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_typeImageView setTintColor:UIColor.whiteColor];
//    [self.contentView addSubview:_typeImageView];
    
    _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    [_stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_stackView setAxis:UILayoutConstraintAxisVertical];
    [_stackView setSpacing:KSOMediaPickerSubviewMarginHalf];
    [_stackView setAlignment:UIStackViewAlignmentLeading];
    [self.contentView addSubview:_stackView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [_stackView addArrangedSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_subtitleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [_stackView addArrangedSubview:_subtitleLabel];
    
    CGFloat widthHeight = 88.0;
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view(==width)]" options:0 metrics:@{@"width": @(widthHeight)} views:@{@"view": _thumbnailImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=margin-[view(==height)]->=margin-|" options:0 metrics:@{@"height": @(widthHeight), @"margin": @(KSOMediaPickerSubviewMargin)} views:@{@"view": _thumbnailImageView}]];
    
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-margin-[view]" options:NSLayoutFormatAlignAllLeading metrics:@{@"margin": @(KSOMediaPickerSubviewMarginHalf)} views:@{@"view": _typeImageView, @"subview": _thumbnailImageView}]];
//    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-margin-[subview]" options:NSLayoutFormatAlignAllBottom metrics:@{@"margin": @(-KSOMediaPickerSubviewMarginHalf)} views:@{@"view": _typeImageView, @"subview": _thumbnailImageView}]];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-|" options:0 metrics:nil views:@{@"view": _stackView, @"subview": _thumbnailImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=margin-[view]->=margin-|" options:0 metrics:@{@"margin": @(KSOMediaPickerSubviewMargin)} views:@{@"view": _stackView}]];
    
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:_thumbnailImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]]];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,model.model.theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self setBackgroundColor:value.cellBackgroundColor];
            [self setSelectedBackgroundView:value.assetCollectionTableViewCellSelectedBackgroundViewClass == Nil ? Nil : [[value.assetCollectionTableViewCellSelectedBackgroundViewClass alloc] initWithFrame:CGRectZero]];
            
            [self.titleLabel setTextColor:value.titleColor];
            [self.titleLabel setHighlightedTextColor:value.highlightedTitleColor];
            
            [self.subtitleLabel setTextColor:value.subtitleColor];
            [self.subtitleLabel setHighlightedTextColor:value.highlightedSubtitleColor];
        });
    }];
    
    return self;
}
#endif
#if (TARGET_OS_IOS)
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
#endif

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.model cancelAllThumbnailRequests];
}

- (void)setModel:(KSOMediaPickerAssetCollectionModel *)model {
    _model = model;
    
#if (TARGET_OS_IOS)
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
#else
    [self.titleLabel setText:_model.title];
    [self.subtitleLabel setText:_model.subtitle];
    [self.typeImageView setImage:[_model.typeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    kstWeakify(self);
    [_model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.thumbnailImageView.frame.size) thumbnailIndex:0 completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailImageView setImage:thumbnailImage];
    }];
#endif
}

@end
