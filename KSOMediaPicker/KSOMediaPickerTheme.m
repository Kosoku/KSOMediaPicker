//
//  KSOMediaPickerTheme.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/21/17.
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

#import "KSOMediaPickerTheme.h"

@interface KSOMediaPickerTheme ()
@property (readwrite,copy,nonatomic) NSString *identifier;

+ (UIColor *)_defaultBackgroundColor;
+ (UIColor *)_defaultCellBackgroundColor;

+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleColor;
+ (UIColor *)_defaultHighlightedTitleColor;
+ (UIFont *)_defaultSubtitleFont;
+ (UIColor *)_defaultSubtitleColor;
+ (UIColor *)_defaultHighlightedSubtitleColor;

+ (UIFont *)_defaultAssetCollectionCellSelectedOverlayViewFont;
+ (UIColor *)_defaultAssetCollectionCellSelectedOverlayViewTextColor;
@end

@implementation KSOMediaPickerTheme

- (id)copyWithZone:(NSZone *)zone {
    KSOMediaPickerTheme *retval = [[[self class] alloc] initWithIdentifier:[NSString stringWithFormat:@"%@.copy",self.identifier]];
    
    retval->_barTintColor = _barTintColor;
    retval->_tintColor = _tintColor;
    retval->_navigationBarTitleTextColor = _navigationBarTitleTextColor;
    
    retval->_backgroundColor = _backgroundColor;
    retval->_cellBackgroundColor = _cellBackgroundColor;
    
    retval->_titleFont = _titleFont;
    retval->_titleColor = _titleColor;
    retval->_highlightedTitleColor = _highlightedTitleColor;
    retval->_subtitleFont = _subtitleFont;
    retval->_subtitleColor = _subtitleColor;
    retval->_highlightedSubtitleColor = _highlightedSubtitleColor;
    
    retval->_assetCollectionTableViewCellSelectedBackgroundViewClass = _assetCollectionTableViewCellSelectedBackgroundViewClass;
    
    retval->_assetSelectedOverlayStyle = _assetSelectedOverlayStyle;
    retval->_assetSelectedOverlayViewClass = _assetSelectedOverlayViewClass;
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
    _cellBackgroundColor = [self.class _defaultCellBackgroundColor];
    
    _titleFont = [self.class _defaultTitleFont];
    _titleColor = [self.class _defaultTitleColor];
    _highlightedTitleColor = [self.class _defaultHighlightedTitleColor];
    _subtitleFont = [self.class _defaultSubtitleFont];
    _subtitleColor = [self.class _defaultSubtitleColor];
    _highlightedSubtitleColor = [self.class _defaultHighlightedSubtitleColor];
    
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
- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor {
    _cellBackgroundColor = cellBackgroundColor ?: [self.class _defaultCellBackgroundColor];
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
- (void)setHighlightedSubtitleColor:(UIColor *)highlightedSubtitleColor {
    _highlightedSubtitleColor = highlightedSubtitleColor ?: [self.class _defaultHighlightedSubtitleColor];
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
+ (UIColor *)_defaultCellBackgroundColor {
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
+ (UIColor *)_defaultHighlightedSubtitleColor; {
    return [UIColor blackColor];
}

+ (UIFont *)_defaultAssetCollectionCellSelectedOverlayViewFont {
    return [UIFont boldSystemFontOfSize:12.0];
}
+ (UIColor *)_defaultAssetCollectionCellSelectedOverlayViewTextColor; {
    return [UIColor whiteColor];
}

@end
