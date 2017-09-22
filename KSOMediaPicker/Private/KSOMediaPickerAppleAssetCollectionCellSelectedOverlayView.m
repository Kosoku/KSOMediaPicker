//
//  KSOMediaPickerAppleAssetCollectionCellSelectedOverlayView.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/22/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerAppleAssetCollectionCellSelectedOverlayView.h"
#import "KSOMediaPickerTheme.h"

#import <Ditko/Ditko.h>
#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerAppleAssetCollectionCellSelectedOverlayView ()
@property (strong,nonatomic) KDIBadgeView *badgeView;
@end

@implementation KSOMediaPickerAppleAssetCollectionCellSelectedOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _badgeView = [[KDIBadgeView alloc] initWithFrame:CGRectZero];
    [self addSubview:_badgeView];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,theme)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        UIColor *baseColor = self.theme.assetCollectionCellSelectedOverlayViewTintColor ?: self.tintColor;
        UIColor *overlayColor = [baseColor KDI_contrastingColor];
        
        [self setBackgroundColor:[overlayColor colorWithAlphaComponent:0.5]];
        [self.badgeView setBadgeFont:self.theme.assetCollectionCellSelectedOverlayViewFont];
        [self.badgeView setBadgeBackgroundColor:baseColor];
        [self.badgeView setBadgeHighlightedBackgroundColor:baseColor];
        [self.badgeView setBadgeForegroundColor:self.theme.assetCollectionCellSelectedOverlayViewTextColor];
        [self.badgeView setBadgeHighlightedForegroundColor:self.theme.assetCollectionCellSelectedOverlayViewTextColor];
        
        [self setNeedsLayout];
    }];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize badgeSize = [self.badgeView sizeThatFits:CGSizeZero];
    
    [self.badgeView setFrame:CGRectMake(CGRectGetWidth(self.bounds) - badgeSize.width - 8, CGRectGetHeight(self.bounds) - badgeSize.height - 8, badgeSize.width, badgeSize.height)];
}

@synthesize allowsMultipleSelection=_allowsMultipleSelection;
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if (_allowsMultipleSelection == allowsMultipleSelection) {
        return;
    }
    
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self.badgeView setBadge:_allowsMultipleSelection ? (_selectedIndex == NSNotFound ? nil : [NSNumberFormatter localizedStringFromNumber:@(_selectedIndex + 1) numberStyle:NSNumberFormatterDecimalStyle]) : @"✓"];
    
    [self setNeedsLayout];
}
@synthesize selectedIndex=_selectedIndex;
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    [self.badgeView setHidden:_selectedIndex == NSNotFound];
    [self.badgeView setBadge:_allowsMultipleSelection ? (_selectedIndex == NSNotFound ? nil : [NSNumberFormatter localizedStringFromNumber:@(_selectedIndex + 1) numberStyle:NSNumberFormatterDecimalStyle]) : @"✓"];
    
    [self setNeedsLayout];
}
@synthesize theme=_theme;

@end
