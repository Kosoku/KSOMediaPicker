//
//  KSOMediaPickerViewController.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/17/17.
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
