//
//  KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView.m
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

#import "KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView.h"
#import "KSOMediaPickerTheme.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@implementation KSOMediaPickerDefaultAssetCollectionCellSelectedOverlayView

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
    if (self.selectedIndex == NSNotFound) {
        return;
    }
    
    [self.theme.assetCollectionCellSelectedOverlayViewTintColor ?: self.tintColor setFill];
    
    CGFloat widthAndHeight = 3.0;
    
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
