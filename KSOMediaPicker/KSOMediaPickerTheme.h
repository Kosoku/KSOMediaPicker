//
//  KSOMediaPickerTheme.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/21/17.
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

#import <UIKit/UIKit.h>
#import <KSOMediaPicker/KSOMediaPickerAssetCollectionCellSelectedOverlayView.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum for possible asset selected overlay style values.
 */
typedef NS_ENUM(NSInteger, KSOMediaPickerThemeAssetSelectedOverlayStyle) {
    /**
     Apple style with a transparent overlay and a circled checkbox in the top right corner to show single selection and numbered to show multiple selection.
     */
    KSOMediaPickerThemeAssetSelectedOverlayStyleApple,
    /**
     Facebook style with a solid color outline with a numbered index in the top right corner to show multiple selection.
     */
    KSOMediaPickerThemeAssetSelectedOverlayStyleFacebook
};

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
 Set and get the bar tint color used for the barTintColor of the containing navigation bar if the media picker is presented modally.
 */
@property (strong,nonatomic,nullable) UIColor *barTintColor;
/**
 Set and get the tint color used for the tintColor of the containing navigation bar if the media picker is presented modally.
 */
@property (strong,nonatomic,nullable) UIColor *tintColor;
/**
 Set and get the text color used for the navigation bar title if the picker is presented modally.
 */
@property (strong,nonatomic,nullable) UIColor *navigationBarTitleTextColor;

/**
 Set and get the background color, which is used as the background color of the asset collection table view, asset collection view.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *backgroundColor;
/**
 Set and get the background color, which is used for the background color of the asset collection and asset cells.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *cellBackgroundColor;

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
 Set and get the highlighted title color.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *highlightedTitleColor;
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
/**
 Set and get the highlighted subtitle color.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *highlightedSubtitleColor;

/**
 Set and get the class used for the asset collection table view selected background view. Use this to use a custom class to draw the selected background if desired.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class assetCollectionTableViewCellSelectedBackgroundViewClass;

/**
 Set and get the asset selected overlay style. This affects the display of the selected asset overlay view.
 
 The default is KSOMediaPickerThemeAssetSelectedOverlayStyleApple.
 */
@property (assign,nonatomic) KSOMediaPickerThemeAssetSelectedOverlayStyle assetSelectedOverlayStyle;
/**
 Set and get the asset selected overlay view class. This class should conform to the KSOMediaPickerAssetCollectionCellSelectedOverlayView protocol. If non-nil, an instance of this class will be created and serve used in place of the default class. The assetSelectedOverlayStyle property will be ignored if this property is non-nil.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class<KSOMediaPickerAssetCollectionCellSelectedOverlayView> assetSelectedOverlayViewClass;
/**
 Set and get the asset collection cell selected overlay view tint color. This is used to draw the selection chrome.
 
 The default is the tintColor of the view.
 */
@property (strong,nonatomic,nullable) UIColor *assetCollectionCellSelectedOverlayViewTintColor;
/**
 Set and get the asset collection view cell selected overlay font that is used to draw the selected index.
 
 The default is [UIFont boldSystemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellSelectedOverlayViewFont;
/**
 Set and get the asset collection view cell selected overlay text color.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellSelectedOverlayViewTextColor;

/**
 Create and return a new theme with the provided *identifier*.
 
 @param identifier The theme identifier
 @return The initialized instance
 */
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
