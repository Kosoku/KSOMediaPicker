//
//  KSOMediaPickerAssetCollectionViewCell.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerAssetCollectionViewCell.h"
#import "KSOMediaPickerAssetModel.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView.h"

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <Loki/Loki.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerAssetCollectionViewCell ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@property (strong,nonatomic) KDIGradientView *gradientView;
@property (strong,nonatomic) UIImageView *typeImageView;
@property (strong,nonatomic) UILabel *durationLabel;

@property (strong,nonatomic) UIView<KSOMediaPickerAssetCollectionCellSelectedOverlayView> *selectedOverlayView;
@end

@implementation KSOMediaPickerAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_thumbnailImageView setClipsToBounds:YES];
    [self.contentView addSubview:_thumbnailImageView];
    
    _gradientView = [[KDIGradientView alloc] initWithFrame:CGRectZero];
    [_gradientView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_gradientView setColors:@[KDIColorWA(0.0, 0.5),KDIColorWA(0.0, 0.75)]];
    [self.contentView addSubview:_gradientView];
    
    _typeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_typeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_gradientView addSubview:_typeImageView];
    
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_durationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_durationLabel setTextColor:[UIColor whiteColor]];
    [_durationLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_durationLabel setTextAlignment:NSTextAlignmentRight];
    [_gradientView addSubview:_durationLabel];
    
    _selectedOverlayView = [[KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView alloc] initWithFrame:CGRectZero];
    
    CGFloat const kMargin = 4.0;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _thumbnailImageView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _thumbnailImageView}]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _gradientView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|" options:0 metrics:nil views:@{@"view": _gradientView}]];
    
    [_gradientView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[view]" options:0 metrics:@{@"margin": @(kMargin)} views:@{@"view": _typeImageView}]];
    [_gradientView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]-margin-|" options:0 metrics:@{@"margin": @(kMargin)} views:@{@"view": _typeImageView}]];
    [_typeImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [_gradientView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[subview]-[view]-margin-|" options:0 metrics:@{@"margin": @(kMargin)} views:@{@"view": _durationLabel, @"subview": _typeImageView}]];
    [_gradientView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]-margin-|" options:0 metrics:@{@"margin": @(kMargin)} views:@{@"view": _durationLabel}]];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,selectedOverlayView),@kstKeypath(self,model.assetCollectionModel.model.theme)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if (self.selectedOverlayView != nil &&
            self.model.assetCollectionModel.model.theme != nil) {
            
            if ([self.selectedOverlayView respondsToSelector:@selector(setTheme:)]) {
                [self.selectedOverlayView setTheme:self.model.assetCollectionModel.model.theme];
            }
        }
    }];
    
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,selectedOverlayView)] options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionOld block:^(NSString * _Nonnull keyPath, UIView<KSOMediaPickerAssetCollectionCellSelectedOverlayView> *  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        
        UIView<KSOMediaPickerAssetCollectionCellSelectedOverlayView> *oldView = [change[NSKeyValueChangeOldKey] conformsToProtocol:@protocol(KSOMediaPickerAssetCollectionCellSelectedOverlayView)] ? change[NSKeyValueChangeOldKey] : nil;
        
        [oldView removeFromSuperview];
        
        if (value != nil) {
            [value setTranslatesAutoresizingMaskIntoConstraints:NO];
            [value setHidden:!self.isSelected];
            
            if ([value respondsToSelector:@selector(setTheme:)]) {
                [value setTheme:self.model.assetCollectionModel.model.theme];
            }
            
            if ([value respondsToSelector:@selector(setAllowsMultipleSelection:)]) {
                [value setAllowsMultipleSelection:self.model.assetCollectionModel.model.allowsMultipleSelection];
            }
            
            [self.contentView addSubview:value];
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": value}]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": value}]];
        }
    }];
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.model cancelAllThumbnailRequests];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.selectedOverlayView setHidden:!selected];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    [coordinator addCoordinatedAnimations:^{
        [self.contentView setTransform:self.isFocused ? CGAffineTransformMakeScale(1.25, 1.25) : CGAffineTransformIdentity];
    } completion:nil];
}

- (void)reloadSelectedOverlayView; {
    if ([self.selectedOverlayView respondsToSelector:@selector(setAllowsMultipleSelection:)]) {
        [self.selectedOverlayView setAllowsMultipleSelection:self.model.assetCollectionModel.model.allowsMultipleSelection];
    }
    
    if ([self.selectedOverlayView respondsToSelector:@selector(setSelectedIndex:)]) {
        [self.selectedOverlayView setSelectedIndex:self.model.selectedIndex];
    }
}
- (void)reloadThumbnailImage; {
    kstWeakify(self);
    [self.model requestThumbnailImageOfSize:KDICGSizeAdjustedForMainScreenScale(self.frame.size) completion:^(UIImage *thumbnailImage) {
        kstStrongify(self);
        [self.thumbnailImageView setImage:thumbnailImage];
    }];
}

- (void)setModel:(KSOMediaPickerAssetModel *)model {
    _model = model;
    
    [self.typeImageView setImage:[_model.typeImage KLO_imageByRenderingWithColor:[UIColor whiteColor]]];
    [self.durationLabel setText:_model.formattedDuration];
    [self.gradientView setHidden:self.typeImageView.image == nil && self.durationLabel.text.length == 0];
    
    if ([self.selectedOverlayView respondsToSelector:@selector(setSelectedIndex:)]) {
        [self.selectedOverlayView setSelectedIndex:_model.selectedIndex];
    }
    
    [self reloadThumbnailImage];
}

@end
