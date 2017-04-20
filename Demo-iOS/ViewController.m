//
//  ViewController.m
//  Demo
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

#import "ViewController.h"

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <KSOMediaPicker/KSOMediaPicker.h>

#import <MobileCoreServices/MobileCoreServices.h>

@interface SelectedBackgroundView : UIView

@end

@implementation SelectedBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    return self;
}

@end

@interface ViewController () <KSOMediaPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) UIButton *modalButton;
@property (strong,nonatomic) UIButton *pushButton;
@property (strong,nonatomic) UIButton *systemButton;
@end

@implementation ViewController

- (NSString *)title {
    return [NSBundle mainBundle].KST_bundleExecutable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setModalButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.modalButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.modalButton setTitle:@"Present Modally" forState:UIControlStateNormal];
    [self.modalButton addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.modalButton];
    
    [self setPushButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.pushButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [self.pushButton addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:self.pushButton];
    
    [self setSystemButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.systemButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.systemButton setTitle:@"UIImagePickerController" forState:UIControlStateNormal];
    [self.systemButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setDelegate:self];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setMediaTypes:@[(__bridge id)kUTTypeImage,(__bridge id)kUTTypeMovie]];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.systemButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": self.modalButton, @"top": self.topLayoutGuide}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modalButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.pushButton, @"subview": self.modalButton}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.systemButton, @"subview": self.pushButton}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.systemButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didFinishPickingMedia:(NSArray<id<KSOMediaPickerMedia>> *)media {
    NSLog(@"media: %@",media);
    
    if (mediaPickerViewController.presentingViewController == nil) {
        [mediaPickerViewController.navigationController popToViewController:self animated:YES];
    }
    else {
        [mediaPickerViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)mediaPickerViewControllerDidCancel:(KSOMediaPickerViewController *)mediaPickerViewController {
    if (mediaPickerViewController.presentingViewController == nil) {
        [mediaPickerViewController.navigationController popToViewController:self animated:YES];
    }
    else {
        [mediaPickerViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didError:(NSError *)error {
    [UIAlertController KDI_presentAlertControllerWithError:error];
}

- (IBAction)_buttonAction:(UIButton *)sender {
    KSOMediaPickerViewController *viewController = [[KSOMediaPickerViewController alloc] init];
    
    [viewController setDelegate:self];
    [viewController setAllowsMultipleSelection:YES];
    [viewController setAllowsMixedMediaSelection:NO];
    [viewController setMaximumSelectedImages:3];
    [viewController setMaximumSelectedVideos:1];
//    [viewController setMediaTypes:KSOMediaPickerMediaTypesImage];
//    [viewController setInitiallySelectedAssetCollectionSubtype:KSOMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary];

    KSOMediaPickerTheme *theme = [[KSOMediaPickerTheme alloc] initWithIdentifier:[NSBundle mainBundle].KST_bundleIdentifier];
    
    [theme setBarTintColor:[UIColor darkGrayColor]];
    [theme setTintColor:[UIColor whiteColor]];
    [theme setBackgroundColor:[UIColor blackColor]];
    [theme setTitleColor:[UIColor whiteColor]];
    [theme setHighlightedTitleColor:[UIColor blackColor]];
    [theme setAssetCollectionCellSelectedOverlayViewTintColor:[UIColor whiteColor]];
    [theme setAssetCollectionCellSelectedOverlayViewTextColor:[UIColor blackColor]];
    [theme setAssetCollectionTableViewCellSelectedBackgroundViewClass:[SelectedBackgroundView class]];
    
    [viewController setTheme:theme];
    
    if (sender == self.modalButton) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
