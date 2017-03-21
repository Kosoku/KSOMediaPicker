//
//  KSOMediaPickerTheme.m
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

#import "KSOMediaPickerTheme.h"
#import "KSOMediaPickerDefaultTitleView.h"

@interface KSOMediaPickerTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleColor;
+ (UIFont *)_defaultSubtitleFont;
+ (UIColor *)_defaultSubtitleColor;
+ (Class)_defaultTitleViewClass;
@end

@implementation KSOMediaPickerTheme

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    _titleFont = [self.class _defaultTitleFont];
    _titleColor = [self.class _defaultTitleColor];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _subtitleColor = [self.class _defaultSubtitleColor];
    _titleViewClass = [self.class _defaultTitleViewClass];
    
    return self;
}

+ (KSOMediaPickerTheme *)defaultTheme {
    static KSOMediaPickerTheme *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSOMediaPickerTheme alloc] initWithIdentifier:@"com.kosoku.ksomediapicker.theme.default"];
    });
    return kRetval;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor ?: [self.class _defaultTitleColor];
}
- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subtitleFont = subtitleFont ?: [self.class _defaultSubtitleFont];
}
- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor ?: [self.class _defaultSubtitleColor];
}
- (void)setTitleViewClass:(Class)titleViewClass {
    _titleViewClass = titleViewClass ?: [self.class _defaultTitleViewClass];
}

+ (UIFont *)_defaultTitleFont; {
    return [UIFont boldSystemFontOfSize:17.0];
}
+ (UIColor *)_defaultTitleColor; {
    return [UIColor blackColor];
}
+ (UIFont *)_defaultSubtitleFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultSubtitleColor; {
    return [UIColor darkGrayColor];
}
+ (Class)_defaultTitleViewClass; {
    return [KSOMediaPickerDefaultTitleView class];
}

@end
