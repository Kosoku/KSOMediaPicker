//
//  ViewController.m
//  Demo
//
//  Created by William Towe on 3/17/17.
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

@interface NavigationController : UINavigationController

@end

@implementation NavigationController
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFormSheet;
}
@end

@interface SelectedOverlayView : UIView <KSOMediaPickerAssetCollectionCellSelectedOverlayView>
@end

@implementation SelectedOverlayView
- (BOOL)isOpaque {
    return NO;
}
- (void)drawRect:(CGRect)rect {
    if (self.theme == nil)
        return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSArray *colors = @[(__bridge id)UIColor.clearColor.CGColor,
                        (__bridge id)self.theme.assetCollectionCellSelectedOverlayViewTintColor.CGColor];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    
    CGGradientRelease(gradient);
}

@synthesize theme=_theme;
- (void)setTheme:(KSOMediaPickerTheme *)theme {
    _theme = theme;
    
    [self setNeedsDisplay];
}
@end

@interface ViewController () <KSOMediaPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) UIButton *modalButton, *modalCustomButton;
@property (strong,nonatomic) UIButton *pushButton;
@property (strong,nonatomic) UIButton *systemButton;
@end

@implementation ViewController

- (NSString *)title {
    return [NSBundle mainBundle].KST_bundleExecutable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kstWeakify(self);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setModalButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.modalButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.modalButton setTitle:@"Present Modally" forState:UIControlStateNormal];
    [self.modalButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        KSOMediaPickerViewController *viewController = [[KSOMediaPickerViewController alloc] init];
        
        [viewController setDelegate:self];
        [viewController setAllowsMultipleSelection:YES];
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modalButton];
    
    [self setModalCustomButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.modalCustomButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.modalCustomButton setTitle:@"Present Custom Modally" forState:UIControlStateNormal];
    [self.modalCustomButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        KSOMediaPickerViewController *viewController = [[KSOMediaPickerViewController alloc] init];
        
        [viewController setDelegate:self];
        [viewController setAllowsMultipleSelection:YES];
        [viewController setAllowsMixedMediaSelection:NO];
        [viewController setMaximumSelectedImages:3];
        [viewController setMaximumSelectedVideos:1];
        
        KSOMediaPickerTheme *theme = [KSOMediaPickerTheme.defaultTheme copy];
        
        [theme setBarTintColor:KDIColorHexadecimal(@"067ab4")];
        [theme setTintColor:KDIColorHexadecimal(@"ff7200")];
        [theme setNavigationBarTitleTextColor:[UIColor whiteColor]];
        [theme setBackgroundColor:KDIColorHexadecimal(@"cdcfd0")];
        [theme setCellBackgroundColor:[UIColor whiteColor]];
        [theme setTitleColor:[UIColor blackColor]];
        [theme setHighlightedTitleColor:[UIColor blackColor]];
        [theme setAssetCollectionTableViewCellSelectedBackgroundViewClass:[SelectedBackgroundView class]];
        [theme setAssetSelectedOverlayStyle:KSOMediaPickerThemeAssetSelectedOverlayStyleFacebook];
        [theme setAssetSelectedOverlayViewClass:SelectedOverlayView.class];
        [theme setAssetCollectionCellSelectedOverlayViewTintColor:KDIColorHexadecimal(@"ff7200")];
        [theme setAssetCollectionCellSelectedOverlayViewTextColor:UIColor.whiteColor];
        
        [viewController setTheme:theme];
        
        [self presentViewController:[[NavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.modalCustomButton];
    
    [self setPushButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.pushButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [self.pushButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        KSOMediaPickerViewController *viewController = [[KSOMediaPickerViewController alloc] init];
        
        [viewController setDelegate:self];
        [viewController setAllowsMultipleSelection:YES];
        
        [self.navigationController pushViewController:viewController animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pushButton];
    
    [self setSystemButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.systemButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.systemButton setTitle:@"UIImagePickerController" forState:UIControlStateNormal];
    [self.systemButton KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        kstStrongify(self);
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        [imagePickerController setDelegate:self];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePickerController setMediaTypes:@[(__bridge id)kUTTypeImage,(__bridge id)kUTTypeMovie]];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.systemButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": self.modalButton, @"top": self.topLayoutGuide}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modalButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.modalCustomButton, @"subview": self.modalButton}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modalCustomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.pushButton, @"subview": self.modalCustomButton}]];
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

@end
