//
//  KSOMediaPickerDefines.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/18/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __KSO_MEDIA_PICKER_DEFINES__
#define __KSO_MEDIA_PICKER_DEFINES__

#import <Photos/PhotosTypes.h>
#import <Photos/PHPhotoLibrary.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible values for the media picker authorization status. See PHAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSOMediaPickerAuthorizationStatus) {
    /**
     See PHAuthorizationStatusNotDetermined for more information.
     */
    KSOMediaPickerAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     See PHAuthorizationStatusRestricted for more information.
     */
    KSOMediaPickerAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     See PHAuthorizationStatusDenied for more information.
     */
    KSOMediaPickerAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     See PHAuthorizationStatusAuthorized for more information.
     */
    KSOMediaPickerAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};

/**
 Enum describing the possible values for media type. See PHAssetMediaType for more information.
 */
typedef NS_ENUM(NSInteger, KSOMediaPickerMediaType) {
    /**
     See PHAssetMediaTypeUnknown for more information.
     */
    KSOMediaPickerMediaTypeUnknown = PHAssetMediaTypeUnknown,
    /**
     See PHAssetMediaTypeImage for more information.
     */
    KSOMediaPickerMediaTypeImage = PHAssetMediaTypeImage,
    /**
     See PHAssetMediaTypeVideo for more information.
     */
    KSOMediaPickerMediaTypeVideo = PHAssetMediaTypeVideo,
    /**
     See PHAssetMediaTypeAudio for more information.
     */
    KSOMediaPickerMediaTypeAudio = PHAssetMediaTypeAudio
};

/**
 Mask describing the types of media that should be displayed when using the library.
 */
typedef NS_OPTIONS(NSUInteger, KSOMediaPickerMediaTypes) {
    /**
     Unknown media should be displayed.
     */
    KSOMediaPickerMediaTypesUnknown = 1 << 0,
    /**
     Image media should be displayed.
     */
    KSOMediaPickerMediaTypesImage = 1 << 1,
    /**
     Video media should be displayed.
     */
    KSOMediaPickerMediaTypesVideo = 1 << 2,
    /**
     Audio media should be displayed.
     */
    KSOMediaPickerMediaTypesAudio = 1 << 3,
    /**
     All media should be displayed.
     */
    KSOMediaPickerMediaTypesAll = KSOMediaPickerMediaTypesUnknown | KSOMediaPickerMediaTypesImage | KSOMediaPickerMediaTypesVideo | KSOMediaPickerMediaTypesAudio
};

typedef NS_ENUM(NSInteger, KSOMediaPickerAssetCollectionSubtype) {
    KSOMediaPickerAssetCollectionSubtypeNone = 0,
    /**
     An album created in the photos app.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumRegular = PHAssetCollectionSubtypeAlbumRegular,
    /**
     An event synced to the device from iPhoto.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumSyncedEvent = PHAssetCollectionSubtypeAlbumSyncedEvent,
    /**
     A faces group synced to the device from iPhoto.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumSyncedFaces = PHAssetCollectionSubtypeAlbumSyncedFaces,
    
    /**
     An album synced to the device from iPhoto.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumSyncedAlbum = PHAssetCollectionSubtypeAlbumSyncedAlbum,
    /**
     An album imported from a camera or external storage.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumImported = PHAssetCollectionSubtypeAlbumImported,
    
    /**
     The user's personal iCloud Photo Stream.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumMyPhotoStream = PHAssetCollectionSubtypeAlbumMyPhotoStream,
    /**
     An iCloud Shared Photo Stream.
     */
    KSOMediaPickerAssetCollectionSubtypeAlbumCloudShared = PHAssetCollectionSubtypeAlbumCloudShared,
    
    /**
     A smart album of no more specific subtype. This subtype applies to smart albums synced to the device from iPhoto.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumGeneric = PHAssetCollectionSubtypeSmartAlbumGeneric,
    /**
     A smart album that groups all panorama photos in the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumPanorama = PHAssetCollectionSubtypeSmartAlbumPanoramas,
    /**
     A smart album that groups all video assets in the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumVideos = PHAssetCollectionSubtypeSmartAlbumVideos,
    /**
     A smart album that groups all assets the user has marked as favorites.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumFavorites = PHAssetCollectionSubtypeSmartAlbumFavorites,
    /**
     A smart album that groups all time lapse videos in the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumTimelapses = PHAssetCollectionSubtypeSmartAlbumTimelapses,
    /**
     A smart album that groups all assets hidden from the Moments view in the Photos app.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumAllHidden = PHAssetCollectionSubtypeSmartAlbumAllHidden,
    /**
     A smart album that groups assets that were recently added to the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumRecentlyAdded = PHAssetCollectionSubtypeSmartAlbumRecentlyAdded,
    /**
     A smart album that groups all burst photo sequences in the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumBursts = PHAssetCollectionSubtypeSmartAlbumBursts,
    /**
     A smart album that groups all slomo video assets in the photo library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumSlomoVideos = PHAssetCollectionSubtypeSmartAlbumSlomoVideos,
    /**
     A smart album that groups all assets that originate in the user's own library.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary = PHAssetCollectionSubtypeSmartAlbumUserLibrary,
    /**
     A smart album that groups all photos and videos captured using the device's front facing camera.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumSelfPortraits = PHAssetCollectionSubtypeSmartAlbumSelfPortraits,
    /**
     A smart album that groups all images captured using the device's screenshot function.
     */
    KSOMediaPickerAssetCollectionSubtypeSmartAlbumScreenshots = PHAssetCollectionSubtypeSmartAlbumScreenshots
};

/**
 Typedef for possible error codes generated by the framework.
 */
typedef NS_ENUM(NSInteger, KSOMediaPickerErrorCode) {
    /**
     Error code returned for when the user attempts to select mixed media (images and videos) when the allowsMixedMediaSelection is NO.
     */
    KSOMediaPickerErrorCodeMixedMediaSelection = 1,
    /**
     Error code returned for when the user attempts to select media that would exceed the maximumSelectedMedia property.
     */
    KSOMediaPickerErrorCodeMaximumSelectedMedia,
    /**
     Error code returned for when the user attempts to select images that would exceed the maximumSelectedImages property.
     */
    KSOMediaPickerErrorCodeMaximumSelectedImages,
    /**
     Error code returned for when the user attempts to select images that would exceed the maximumSelectedVideos property.
     */
    KSOMediaPickerErrorCodeMaximumSelectedVideos
};
/**
 Error domain for errors produced by the media picker.
 */
FOUNDATION_EXPORT NSString *const KSOMediaPickerErrorDomain;

NS_ASSUME_NONNULL_END

#endif
