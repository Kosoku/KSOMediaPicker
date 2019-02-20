//
//  KSOMediaPickerAssetCollectionViewLayout.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/22/17.
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

#import "KSOMediaPickerAssetCollectionViewLayout.h"

@implementation KSOMediaPickerAssetCollectionViewLayout

#pragma mark *** Subclass Overrides ***
- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomTV:
            _numberOfColumns = 8;
            break;
        case UIUserInterfaceIdiomPad:
            _numberOfColumns = 5;
            break;
        case UIUserInterfaceIdiomPhone:
            _numberOfColumns = 4;
            break;
        default:
            break;
    };
    
    [self setSectionInset:UIEdgeInsetsZero];
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat availableWidth = CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.left - self.sectionInset.right - (self.minimumInteritemSpacing * (self.numberOfColumns - 1));
    CGFloat itemWidth = floor(availableWidth / (CGFloat)self.numberOfColumns);
    CGSize itemSize = CGSizeMake(itemWidth, itemWidth);
    
    [self setItemSize:itemSize];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setNumberOfColumns:(NSInteger)numberOfColumns {
    if (_numberOfColumns == numberOfColumns) {
        return;
    }
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}

@end
