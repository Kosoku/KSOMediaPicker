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
#import "KSOMediaPickerTitleView.h"
#import "KSOMediaPickerBackgroundView.h"
#import "KSOMediaPickerAssetCollectionViewController.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerViewController ()
@property (strong,nonatomic) KSOMediaPickerModel *model;
@property (strong,nonatomic) UIView<KSOMediaPickerTitleView> *titleView;
@property (strong,nonatomic) KSOMediaPickerBackgroundView *backgroundView;
@property (strong,nonatomic) KSOMediaPickerAssetCollectionViewController *collectionViewController;

- (void)_updateTitleViewProperties;
- (void)_updateTitleViewTitleAndSubtitle;
@end

@implementation KSOMediaPickerViewController

- (void)dealloc {
    KSTLogObject(self.class);
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _model = [[KSOMediaPickerModel alloc] init];
    
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
    
    [self setTitleView:[[self.model.theme.titleViewClass alloc] initWithFrame:CGRectZero]];
    
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
    [self KAG_addObserverForKeyPaths:@[@kstKeypath(self,titleView)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if (self.titleView != nil) {
            [self _updateTitleViewProperties];
            
            [self.navigationItem setTitleView:_titleView];
        }
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,title),@kstKeypath(self.model,subtitle)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self _updateTitleViewTitleAndSubtitle];
        });
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        if ([self.titleView respondsToSelector:@selector(setTheme:)]) {
            [self.titleView setTheme:value];
        }
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,authorizationStatus)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            if ([value integerValue] == KSOMediaPickerAuthorizationStatusAuthorized) {
                [self setCollectionViewController:[[KSOMediaPickerAssetCollectionViewController alloc] initWithModel:self.model]];
                [self.collectionViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
                [self addChildViewController:self.collectionViewController];
                [self.view addSubview:self.collectionViewController.view];
                [self.collectionViewController didMoveToParentViewController:self];
                
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.collectionViewController.view}]];
                [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][view]|" options:0 metrics:nil views:@{@"view": self.collectionViewController.view, @"top": self.topLayoutGuide}]];
            }
        });
    }];
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

- (void)_updateTitleViewProperties; {
    for (UIGestureRecognizer *gr in self.titleView.gestureRecognizers) {
        [self.titleView removeGestureRecognizer:gr];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
    
    [tapGestureRecognizer setNumberOfTapsRequired:1];
#if (TARGET_OS_IOS)
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
#endif
    
    [self.titleView addGestureRecognizer:tapGestureRecognizer];
    
    if ([self.titleView respondsToSelector:@selector(setTheme:)]) {
        [self.titleView setTheme:self.model.theme];
    }
    
    [self _updateTitleViewTitleAndSubtitle];
}
- (void)_updateTitleViewTitleAndSubtitle; {
    [self.titleView setTitle:self.model.title];
    
    if ([self.titleView respondsToSelector:@selector(setSubtitle:)]) {
        [self.titleView setSubtitle:self.model.subtitle];
    }
    
    [self.titleView sizeToFit];
}

- (IBAction)_tapGestureRecognizerAction:(id)sender {
    
}

@end
