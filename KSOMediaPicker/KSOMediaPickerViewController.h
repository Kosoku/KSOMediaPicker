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

@property (weak,nonatomic) id<KSOMediaPickerViewControllerDelegate> delegate;

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

@end

@protocol KSOMediaPickerViewControllerDelegate <NSObject>
@required
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didFinishPickingMedia:(NSArray<id<KSOMediaPickerMedia> > *)media;
- (void)mediaPickerViewControllerDidCancel:(KSOMediaPickerViewController *)mediaPickerViewController;
@optional
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didError:(NSError *)error;

- (BOOL)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController shouldSelectMedia:(id<KSOMediaPickerMedia>)media;
- (BOOL)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController shouldDeselectMedia:(id<KSOMediaPickerMedia>)media;

- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didSelectMedia:(id<KSOMediaPickerMedia>)media;
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didDeselectMedia:(id<KSOMediaPickerMedia>)media;
@end

NS_ASSUME_NONNULL_END
