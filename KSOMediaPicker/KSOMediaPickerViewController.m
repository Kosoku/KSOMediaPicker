//
//  KSOMediaPickerViewController.m
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

#import "KSOMediaPickerViewController.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetModel.h"
#import "KSOMediaPickerTheme.h"
#import "KSOMediaPickerBackgroundView.h"
#import "KSOMediaPickerAssetCollectionViewController.h"
#import "KSOMediaPickerAssetCollectionTableViewController.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"
#import "KSOMediaPickerAssetCollectionModel.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>
#import <Quicksilver/Quicksilver.h>

@interface KSOMediaPickerViewController () <KSOMediaPickerModelDelegate>
@property (strong,nonatomic) KSOMediaPickerModel *model;
@property (strong,nonatomic) KSOMediaPickerBackgroundView *backgroundView;
@property (strong,nonatomic) KSOMediaPickerAssetCollectionTableViewController *tableViewController;
@end

@implementation KSOMediaPickerViewController

- (NSString *)title {
    return NSLocalizedStringWithDefaultValue(@"media.picker.title", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Photos", @"Photos");
}

- (void)dealloc {
    KSTLogObject(self.class);
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _model = [[KSOMediaPickerModel alloc] init];
    [_model setDelegate:self];
    
    kstWeakify(self);
    [_model setDoneBarButtonItemBlock:^{
        kstStrongify(self);
        [self.delegate mediaPickerViewController:self didFinishPickingMedia:self.model.selectedAssetModels];
    }];
    [_model setCancelBarButtonItemBlock:^{
        kstStrongify(self);
        [self.delegate mediaPickerViewControllerDidCancel:self];
    }];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundView:[[KSOMediaPickerBackgroundView alloc] initWithModel:self.model]];
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.backgroundView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    
    if (self.allowsMultipleSelection) {
        if (self.presentingViewController != nil) {
            [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
        }
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
    }
    
    if (self.initiallySelectedAssetCollectionSubtype != KSOMediaPickerAssetCollectionSubtypeNone &&
        [self.model.assetCollectionModels KQS_any:^BOOL(KSOMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
        return self.initiallySelectedAssetCollectionSubtype == object.subtype;
    }]) {
        
        [self.model setSelectedAssetCollectionModel:[self.model.assetCollectionModels KQS_find:^BOOL(KSOMediaPickerAssetCollectionModel * _Nonnull object, NSInteger index) {
            return self.initiallySelectedAssetCollectionSubtype == object.subtype;
        }]];
        
        [self.navigationController pushViewController:[[KSOMediaPickerAssetCollectionViewController alloc] initWithModel:self.model] animated:NO];
    }
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if (self.presentingViewController != nil) {
                if (value.barTintColor != nil) {
                    [self.navigationController.navigationBar setBarTintColor:value.barTintColor];
                }
                if (value.tintColor != nil) {
                    [self.navigationController.navigationBar setTintColor:value.tintColor];
                }
                
                if (value.navigationBarTitleTextColor != nil) {
                    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: value.navigationBarTitleTextColor}];
                }
            }
            
            [self.view setBackgroundColor:value.backgroundColor];
        });
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,authorizationStatus)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([value integerValue] == KSOMediaPickerAuthorizationStatusAuthorized) {
                [self setTableViewController:[[KSOMediaPickerAssetCollectionTableViewController alloc] initWithModel:self.model]];
                [self.tableViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addChildViewController:self.tableViewController];
                [self.view addSubview:self.tableViewController.view];
                [self.tableViewController didMoveToParentViewController:self];
                
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableViewController.view}]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][view]|" options:0 metrics:nil views:@{@"view": self.tableViewController.view, @"top": self.topLayoutGuide}]];
            }
        });
    }];
}

- (void)mediaPickerModelDidError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didError:)]) {
        [self.delegate mediaPickerViewController:self didError:error];
    }
}
- (BOOL)mediaPickerModelShouldSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:shouldSelectMedia:)]) {
        return [self.delegate mediaPickerViewController:self shouldSelectMedia:assetModel];
    }
    return YES;
}
- (BOOL)mediaPickerModelShouldDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:shouldDeselectMedia:)]) {
        return [self.delegate mediaPickerViewController:self shouldDeselectMedia:assetModel];
    }
    return YES;
}
- (void)mediaPickerModelDidSelectAssetModel:(KSOMediaPickerAssetModel *)assetModel {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didSelectMedia:)]) {
        [self.delegate mediaPickerViewController:self didSelectMedia:assetModel];
    }
}
- (void)mediaPickerModelDidDeselectAssetModel:(KSOMediaPickerAssetModel *)assetModel {
    if ([self.delegate respondsToSelector:@selector(mediaPickerViewController:didDeselectMedia:)]) {
        [self.delegate mediaPickerViewController:self didDeselectMedia:assetModel];
    }
}

@dynamic theme;
- (KSOMediaPickerTheme *)theme {
    return self.model.theme;
}
- (void)setTheme:(KSOMediaPickerTheme *)theme {
    [self.model setTheme:theme];
}

@dynamic allowsMultipleSelection;
- (BOOL)allowsMultipleSelection {
    return self.model.allowsMultipleSelection;
}
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    [self.model setAllowsMultipleSelection:allowsMultipleSelection];
}
@dynamic allowsMixedMediaSelection;
- (BOOL)allowsMixedMediaSelection {
    return self.model.allowsMixedMediaSelection;
}
- (void)setAllowsMixedMediaSelection:(BOOL)allowsMixedMediaSelection {
    [self.model setAllowsMixedMediaSelection:allowsMixedMediaSelection];
}
@dynamic maximumSelectedMedia;
- (NSUInteger)maximumSelectedMedia {
    return self.model.maximumSelectedMedia;
}
- (void)setMaximumSelectedMedia:(NSUInteger)maximumSelectedMedia {
    [self.model setMaximumSelectedMedia:maximumSelectedMedia];
}
@dynamic maximumSelectedImages;
- (NSUInteger)maximumSelectedImages {
    return self.model.maximumSelectedImages;
}
- (void)setMaximumSelectedImages:(NSUInteger)maximumSelectedImages {
    [self.model setMaximumSelectedImages:maximumSelectedImages];
}
@dynamic maximumSelectedVideos;
- (NSUInteger)maximumSelectedVideos {
    return self.model.maximumSelectedVideos;
}
- (void)setMaximumSelectedVideos:(NSUInteger)maximumSelectedVideos {
    [self.model setMaximumSelectedVideos:maximumSelectedVideos];
}
@dynamic hidesEmptyAssetCollections;
- (BOOL)hidesEmptyAssetCollections {
    return self.model.hidesEmptyAssetCollections;
}
- (void)setHidesEmptyAssetCollections:(BOOL)hidesEmptyAssetCollections {
    [self.model setHidesEmptyAssetCollections:hidesEmptyAssetCollections];
}

@dynamic mediaTypes;
- (KSOMediaPickerMediaTypes)mediaTypes {
    return self.model.mediaTypes;
}
- (void)setMediaTypes:(KSOMediaPickerMediaTypes)mediaTypes {
    [self.model setMediaTypes:mediaTypes];
}

@dynamic initiallySelectedAssetCollectionSubtype;
- (KSOMediaPickerAssetCollectionSubtype)initiallySelectedAssetCollectionSubtype {
    return self.model.initiallySelectedAssetCollectionSubtype;
}
- (void)setInitiallySelectedAssetCollectionSubtype:(KSOMediaPickerAssetCollectionSubtype)initiallySelectedAssetCollectionSubtype {
    [self.model setInitiallySelectedAssetCollectionSubtype:initiallySelectedAssetCollectionSubtype];
}

@dynamic allowedAssetCollectionSubtypes;
- (NSSet<NSNumber *> *)allowedAssetCollectionSubtypes {
    return self.model.allowedAssetCollectionSubtypes;
}
- (void)setAllowedAssetCollectionSubtypes:(NSSet<NSNumber *> *)allowedAssetCollectionSubtypes {
    [self.model setAllowedAssetCollectionSubtypes:allowedAssetCollectionSubtypes];
}

@end
