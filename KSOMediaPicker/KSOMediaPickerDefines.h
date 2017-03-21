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

typedef NS_ENUM(NSInteger, KSOMediaPickerMediaType) {
    KSOMediaPickerMediaTypeUnknown = PHAssetMediaTypeUnknown,
    KSOMediaPickerMediaTypeImage = PHAssetMediaTypeImage,
    KSOMediaPickerMediaTypeVideo = PHAssetMediaTypeVideo,
    KSOMediaPickerMediaTypeAudio = PHAssetMediaTypeAudio
};

typedef NS_ENUM(NSInteger, KSOMediaPickerAssetCollectionSubtype) {
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

#endif
