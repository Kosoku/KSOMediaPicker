//
//  ViewController.m
//  Demo-tvOS
//
//  Created by William Towe on 3/22/17.
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
#import <KSOMediaPicker/KSOMediaPicker.h>

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

- (void)mediaPickerViewControllerDidCancel:(KSOMediaPickerViewController *)mediaPickerViewController {
    if (mediaPickerViewController.presentingViewController == nil) {
        [mediaPickerViewController.navigationController popViewControllerAnimated:YES];
    }
    else {
        [mediaPickerViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)mediaPickerViewController:(KSOMediaPickerViewController *)mediaPickerViewController didFinishPickingMedia:(NSArray<id<KSOMediaPickerMedia>> *)media {
    if (mediaPickerViewController.presentingViewController == nil) {
        [mediaPickerViewController.navigationController popViewControllerAnimated:YES];
    }
    else {
        [mediaPickerViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)_buttonAction:(UIButton *)sender {
    KSOMediaPickerViewController *viewController = [[KSOMediaPickerViewController alloc] init];
    
    [viewController setDelegate:self];
    
    if (sender == self.modalButton) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end