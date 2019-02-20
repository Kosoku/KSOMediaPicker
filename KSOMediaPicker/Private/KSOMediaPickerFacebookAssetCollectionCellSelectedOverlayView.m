//
//  KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
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

#import "KSOMediaPickerFacebookAssetCollectionCellSelectedOverlayView.h"
#import "KSOMediaPickerTheme.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@implementation KSOMediaPickerFacebookAssetCollectionCellSelectedOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,theme)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self setNeedsDisplay];
    }];
    
    return self;
}

- (BOOL)isOpaque {
    return NO;
}

- (void)drawRect:(CGRect)rect {
    if (self.isFocused) {
        [[self.theme.assetCollectionCellSelectedOverlayViewTintColor ?: self.tintColor colorWithAlphaComponent:0.5] setFill];
        UIRectFill(self.bounds);
    }
    
    if (self.selectedIndex == NSNotFound) {
        return;
    }
    
    [self.theme.assetCollectionCellSelectedOverlayViewTintColor ?: self.tintColor setFill];
    
    CGFloat widthAndHeight = 5.0;
    
    UIRectFill(CGRectMake(0, 0, CGRectGetWidth(self.bounds), widthAndHeight));
    UIRectFill(CGRectMake(CGRectGetWidth(self.bounds) - widthAndHeight, 0, widthAndHeight, CGRectGetHeight(self.bounds)));
    UIRectFill(CGRectMake(0, CGRectGetHeight(self.bounds) - widthAndHeight, CGRectGetWidth(self.bounds), widthAndHeight));
    UIRectFill(CGRectMake(0, 0, widthAndHeight, CGRectGetHeight(self.bounds)));
    
    if (!self.allowsMultipleSelection) {
        return;
    }
    
    NSAttributedString *badge = [[NSAttributedString alloc] initWithString:[NSNumberFormatter localizedStringFromNumber:@(self.selectedIndex + 1) numberStyle:NSNumberFormatterDecimalStyle] attributes:@{NSFontAttributeName: self.theme.assetCollectionCellSelectedOverlayViewFont, NSForegroundColorAttributeName: self.theme.assetCollectionCellSelectedOverlayViewTextColor}];
    CGSize badgeLabelSize = [badge size];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetWidth(self.bounds) - badgeLabelSize.width - widthAndHeight - widthAndHeight, 0, badgeLabelSize.width + widthAndHeight + widthAndHeight, badgeLabelSize.height + widthAndHeight + widthAndHeight) cornerRadius:widthAndHeight];
    
    [path fill];
    
    [badge drawAtPoint:CGPointMake(CGRectGetWidth(self.bounds) - badgeLabelSize.width - widthAndHeight, widthAndHeight)];
}

@synthesize allowsMultipleSelection=_allowsMultipleSelection;
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if (_allowsMultipleSelection == allowsMultipleSelection) {
        return;
    }
    
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self setNeedsDisplay];
}
@synthesize selectedIndex=_selectedIndex;
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    else if (!self.allowsMultipleSelection) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    [self setNeedsDisplay];
}
@synthesize theme=_theme;

@end
