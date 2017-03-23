//
//  KSOMediaPickerViewController.m
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

#import "KSOMediaPickerViewController.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetModel.h"
#import "KSOMediaPickerTheme.h"
#import "KSOMediaPickerBackgroundView.h"
#import "KSOMediaPickerAssetCollectionViewController.h"
#import "KSOMediaPickerAssetCollectionTableViewController.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerViewController () <KSOMediaPickerModelDelegate>
@property (strong,nonatomic) KSOMediaPickerModel *model;
@property (strong,nonatomic) KSOMediaPickerBackgroundView *backgroundView;
@property (strong,nonatomic) KSOMediaPickerAssetCollectionTableViewController *tableViewController;

@end

@implementation KSOMediaPickerViewController

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackgroundView:[[KSOMediaPickerBackgroundView alloc] initWithModel:self.model]];
    [self.backgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.backgroundView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": self.backgroundView}]];
    
    if (self.allowsMultipleSelection) {
        if (self.presentingViewController != nil) {
            [self.navigationItem setLeftBarButtonItems:@[self.model.cancelBarButtonItem]];
        }
        [self.navigationItem setRightBarButtonItems:@[self.model.doneBarButtonItem]];
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
    }
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,title)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self setTitle:value];
        });
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:0 block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.view setBackgroundColor:value.assetBackgroundColor];
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

@end
