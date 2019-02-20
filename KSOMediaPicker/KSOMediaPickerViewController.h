//
//  KSOMediaPickerViewController.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/17/17.
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

#import <UIKit/UIKit.h>

#import <KSOMediaPicker/KSOMediaPickerMedia.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOMediaPickerTheme;
@protocol KSOMediaPickerViewControllerDelegate;

@interface KSOMediaPickerViewController : UIViewController

/**
 Set and get the media picker delegate.
 
 @see KSOMediaPickerViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<KSOMediaPickerViewControllerDelegate> delegate;

/**
 Set and get the media picker theme.
 
 The default is KSOMediaPickerTheme.defaultTheme.
 
 @see KSOMediaPickerTheme
 */
@property (strong,nonatomic,null_resettable) KSOMediaPickerTheme *theme;

/**
 Set and get whether the media picker allows the user to select multiple assets.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL allowsMultipleSelection;
/**
 Set and get whether the media picker allows the user to select non-homogenous media types (e.g. images and videos).
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL allowsMixedMediaSelection;
/**
 Set and get the maximum number of selected media. A value of 0 means no limit.
 
 The default is 0.
 */
@property (assign,nonatomic) NSUInteger maximumSelectedMedia;
/**
 Set and get the maximum number of selected images. A value of 0 means no limit.
 
 The default is 0.
 */
@property (assign,nonatomic) NSUInteger maximumSelectedImages;
/**
 Set and get the maximum number of selected videos. A value of 0 means no limit.
 
 The default is 0.
 */
@property (assign,nonatomic) NSUInteger maximumSelectedVideos;
/**
 Set and get whether the media picker hides asset collections that are empty (i.e. they contain 0 assets).
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL hidesEmptyAssetCollections;

/**
 Set and get the media types displayed by the media picker.
 
 The default is KSOMediaPickerMediaTypesAll.
 */
@property (assign,nonatomic) KSOMediaPickerMediaTypes mediaTypes;
/**
 If set to something other than KSOMediaPickerAssetCollectionSubtypeNone, selects the asset collection and pushes the collection view controller onto the navigation stack in order to display it.
 
 The default is KSOMediaPickerAssetCollectionSubtypeNone.
 */
@property (assign,nonatomic) KSOMediaPickerAssetCollectionSubtype initiallySelectedAssetCollectionSubtype;
/**
 If set to a non-nil set of KSOMediaPickerAssetCollectionSubtype values, the media picker will only display those collections in the initial table view.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSSet<NSNumber *> *allowedAssetCollectionSubtypes;

@end

/**
 Protocol for the media picker delegate.
 */
@protocol KSOMediaPickerViewControllerDelegate <NSObject>
@required
/**
 Called when the user has selected media and taps the Done button. The provided array contains objects conforming to the KSOMediaPickerMedia protocol, which can be used to access the underlying PHAsset and inspect the media type. The delegate is responsible for dismissing the media picker if presented modally or popping the navigation stack if the media picker was pushed.
 
 @param mediaPickerViewController The object that sent the message
 @param media The media that were selected by the user
 */
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didFinishPickingMedia:(NSArray<id<KSOMediaPickerMedia> > *)media;
/**
 Called when the user taps the Cancel button when the media picker is presented modally. The delegate is responsible for dismissing the media picker if presented modally or popping the navigation stack if the media picker was pushed.
 
 @param mediaPickerViewController The object that sent the message
 */
- (void)mediaPickerViewControllerDidCancel:(KSOMediaPickerViewController *)mediaPickerViewController;

@optional
/**
 Called when the media picker produces an error. The client can choose to display the error to the user or ignore it.
 
 @param mediaPickerViewController The object that sent the message
 @param error The media picker error
 */
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didError:(NSError *)error;

/**
 Called when the user selects media, the client can decide whether to allow the selection.
 
 @param mediaPickerViewController The object that sent the message
 @param media The media that was selected
 @return Return YES to allow the selection, NO to deny it
 */
- (BOOL)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController shouldSelectMedia:(id<KSOMediaPickerMedia>)media;
/**
 Called when the user deselects media, the client can decide whether to allow it.
 
 @param mediaPickerViewController The object that sent the message
 @param media The media that was deselected
 @return Return YES to allow the deselection, NO to deny it
 */
- (BOOL)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController shouldDeselectMedia:(id<KSOMediaPickerMedia>)media;

/**
 Called when the user selects media, the client can use the method to track which media are selected before the user taps the Done button.
 
 @param mediaPickerViewController The object that sent the message
 @param media The media that was selected
 */
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didSelectMedia:(id<KSOMediaPickerMedia>)media;
/**
 Called when the user deselects media, the client use the method to track which media are selected before the user taps the Done button.
 
 @param mediaPickerViewController The object that sent the message
 @param media The media that was deselected
 */
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didDeselectMedia:(id<KSOMediaPickerMedia>)media;
@end

NS_ASSUME_NONNULL_END
