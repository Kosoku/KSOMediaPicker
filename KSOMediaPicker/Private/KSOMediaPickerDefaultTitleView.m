//
//  KSOMediaPickerDefaultTitleView.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/21/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerDefaultTitleView.h"
#import "KSOMediaPickerTheme.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>

@interface KSOMediaPickerDefaultTitleView ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *subtitleLabel;
@end

@implementation KSOMediaPickerDefaultTitleView

@dynamic title;
- (NSString *)title {
    return self.titleLabel.text;
}
- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}
@dynamic subtitle;
- (NSString *)subtitle {
    return self.subtitleLabel.text;
}
- (void)setSubtitle:(NSString *)subtitle {
    [self.subtitleLabel setText:subtitle];
}
@synthesize theme=_theme;

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    _theme = KSOMediaPickerTheme.defaultTheme;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:_theme.titleFont];
    [_titleLabel setTextColor:_theme.titleColor];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_subtitleLabel setFont:_theme.subtitleFont];
    [_subtitleLabel setTextColor:_theme.subtitleColor];
    [_subtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_subtitleLabel];
    
    kstWeakify(self);
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,theme)] options:0 block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if (value != nil) {
            [self.titleLabel setFont:value.titleFont];
            [self.titleLabel setTextColor:value.titleColor];
            
            [self.subtitleLabel setFont:value.subtitleFont];
            [self.subtitleLabel setTextColor:value.subtitleColor];
        }
    }];
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeZero;
    
    retval.width = MAX([self.titleLabel sizeThatFits:CGSizeZero].width, [self.subtitleLabel sizeThatFits:CGSizeZero].width);
    retval.height += [self.titleLabel sizeThatFits:CGSizeZero].height;
    retval.height += [self.subtitleLabel sizeThatFits:CGSizeZero].height;
    
    return retval;
}

- (void)layoutSubviews {
    [self.titleLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self.titleLabel sizeThatFits:CGSizeZero].height)];
    [self.subtitleLabel setFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.titleLabel.frame))];
}

@end
