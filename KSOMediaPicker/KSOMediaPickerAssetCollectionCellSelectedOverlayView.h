//
//  KSOMediaPickerAssetCollectionCellSelectedOverlayView.h
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KSOMediaPickerTheme;

/**
 KSOMediaPickerAssetSelectedOverlayView is a protocol describing an instance of the class used to draw selection chrome for selected asset collection view cells.
 */
@protocol KSOMediaPickerAssetCollectionCellSelectedOverlayView <NSObject>
@optional
/**
 Set and get whether the receiver allows multiple selection.
 */
@property (assign,nonatomic) BOOL allowsMultipleSelection;
/**
 Set and get the index of the selected asset within the array of selected assets.
 */
@property (assign,nonatomic) NSUInteger selectedIndex;
/**
 Set and get the theme of the selected overlay view.
 */
@property (strong,nonatomic,nullable) KSOMediaPickerTheme *theme;
@end

NS_ASSUME_NONNULL_END
