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

@interface KSOMediaPickerTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIColor *)_defaultBackgroundColor;

+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleColor;
+ (UIColor *)_defaultHighlightedTitleColor;
+ (UIFont *)_defaultSubtitleFont;
+ (UIColor *)_defaultSubtitleColor;

+ (UIFont *)_defaultAssetCollectionCellSelectedOverlayViewFont;
+ (UIColor *)_defaultAssetCollectionCellSelectedOverlayViewTextColor;
@end

@implementation KSOMediaPickerTheme

- (id)copyWithZone:(NSZone *)zone {
    KSOMediaPickerTheme *retval = [[[self class] alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_backgroundColor = _backgroundColor;
    
    retval->_titleFont = _titleFont;
    retval->_titleColor = _titleColor;
    retval->_highlightedTitleColor = _highlightedTitleColor;
    retval->_subtitleFont = _subtitleFont;
    retval->_subtitleColor = _subtitleColor;
    
    retval->_assetCollectionTableViewCellSelectedBackgroundViewClass = _assetCollectionTableViewCellSelectedBackgroundViewClass;
    
    retval->_assetCollectionCellSelectedOverlayViewTintColor = _assetCollectionCellSelectedOverlayViewTintColor;
    retval->_assetCollectionCellSelectedOverlayViewFont = _assetCollectionCellSelectedOverlayViewFont;
    retval->_assetCollectionCellSelectedOverlayViewTextColor = _assetCollectionCellSelectedOverlayViewTextColor;
    
    return retval;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (!(self = [super init]))
        return nil;
    
    _identifier = [identifier copy];
    
    _backgroundColor = [self.class _defaultBackgroundColor];
    
    _titleFont = [self.class _defaultTitleFont];
    _titleColor = [self.class _defaultTitleColor];
    _highlightedTitleColor = [self.class _defaultHighlightedTitleColor];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _subtitleColor = [self.class _defaultSubtitleColor];
    
    _assetCollectionCellSelectedOverlayViewFont = [self.class _defaultAssetCollectionCellSelectedOverlayViewFont];
    _assetCollectionCellSelectedOverlayViewTextColor = [self.class _defaultAssetCollectionCellSelectedOverlayViewTextColor];
    
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

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor ?: [self.class _defaultBackgroundColor];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor ?: [self.class _defaultTitleColor];
}
- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor {
    _highlightedTitleColor = highlightedTitleColor ?: [self.class _defaultHighlightedTitleColor];
}
- (void)setSubtitleFont:(UIFont *)subtitleFont {
    _subtitleFont = subtitleFont ?: [self.class _defaultSubtitleFont];
}
- (void)setSubtitleColor:(UIColor *)subtitleColor {
    _subtitleColor = subtitleColor ?: [self.class _defaultSubtitleColor];
}

- (void)setAssetCollectionCellSelectedOverlayViewFont:(UIFont *)assetCollectionCellSelectedOverlayViewFont {
    _assetCollectionCellSelectedOverlayViewFont = assetCollectionCellSelectedOverlayViewFont ?: [self.class _defaultAssetCollectionCellSelectedOverlayViewFont];
}
- (void)setAssetCollectionCellSelectedOverlayViewTextColor:(UIColor *)assetCollectionCellSelectedOverlayViewTextColor {
    _assetCollectionCellSelectedOverlayViewTextColor = assetCollectionCellSelectedOverlayViewTextColor ?: [self.class _defaultAssetCollectionCellSelectedOverlayViewTextColor];
}

+ (UIColor *)_defaultBackgroundColor; {
    return [UIColor whiteColor];
}

+ (UIFont *)_defaultTitleFont; {
    return [UIFont systemFontOfSize:17.0];
}
+ (UIColor *)_defaultTitleColor; {
    return [UIColor blackColor];
}
+ (UIColor *)_defaultHighlightedTitleColor; {
    return [UIColor blackColor];
}
+ (UIFont *)_defaultSubtitleFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultSubtitleColor; {
    return [UIColor darkGrayColor];
}

+ (UIFont *)_defaultAssetCollectionCellSelectedOverlayViewFont {
    return [UIFont boldSystemFontOfSize:12.0];
}
+ (UIColor *)_defaultAssetCollectionCellSelectedOverlayViewTextColor; {
    return [UIColor whiteColor];
}

@end
