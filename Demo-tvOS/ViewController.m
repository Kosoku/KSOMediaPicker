//
//  ViewController.m
//  Demo-tvOS
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

#import "ViewController.h"

#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <KSOMediaPicker/KSOMediaPicker.h>

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

@interface ViewController () <KSOMediaPickerViewControllerDelegate>
@property (strong,nonatomic) UIButton *modalButton;
@property (strong,nonatomic) UIButton *pushButton;
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
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-[view]" options:0 metrics:nil views:@{@"view": self.modalButton, @"top": self.topLayoutGuide}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.modalButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[subview]-[view]" options:0 metrics:nil views:@{@"view": self.pushButton, @"subview": self.modalButton}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pushButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
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
    
    if (sender == self.modalButton) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
