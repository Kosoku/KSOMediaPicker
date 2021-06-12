//
//  KSOMediaPickerAppleAssetCollectionCellSelectedOverlayView.m
//  KSOMediaPicker
//
//  Created by William Towe on 9/22/17.
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
        
        [self setBackgroundColor:[overlayColor colorWithAlphaComponent:0.25]];
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
    CGFloat margin = 4.0;
    
    [self.badgeView setFrame:CGRectMake(CGRectGetWidth(self.bounds) - badgeSize.width - margin, CGRectGetHeight(self.bounds) - badgeSize.height - margin, badgeSize.width, badgeSize.height)];
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
