//
//  KSOMediaPickerTheme.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSOMediaPickerTheme : NSObject <NSCopying>

/**
 Returns the default theme.
 */
@property (class,readonly,nonatomic) KSOMediaPickerTheme *defaultTheme;

/**
 Get the identifier of the theme.
 */
@property (readonly,copy,nonatomic) NSString *identifier;

/**
 Set and get the background color, which is used as the background color of the asset collection table view, asset collection view and the navigation bar when presenting modally.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *backgroundColor;

/**
 Set and get the title font, which is used to display the name of the selected asset collection in the navigation bar.
 
 The default is [UIFont boldSystemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *titleFont;
/**
 Set and get the title color.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *titleColor;
/**
 Set and get the subtitle font, which is used to display descriptive text telling the user to tap in order to change the selected asset collection.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *subtitleFont;
/**
 Set and get the subtitle color.
 
 The default is [UIColor darkGrayColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *subtitleColor;

@property (strong,nonatomic,nullable) Class assetCollectionTableViewCellSelectedBackgroundViewClass;

/**
 Set and get the asset collection cell selected overlay view tint color. This is used to draw the selection chrome.
 
 The default is the tintColor of the view.
 */
@property (strong,nonatomic,nullable) UIColor *assetCollectionCellSelectedOverlayViewTintColor;
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellSelectedOverlayViewFont;
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellSelectedOverlayViewTextColor;

/**
 Create and return a new theme with the provided *identifier*.
 
 @param identifier The theme identifier
 @return The initialized instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
