//
//  KSOMediaPickerBackgroundView.m
//  KSOMediaPicker
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

#import "KSOMediaPickerBackgroundView.h"
#import "KSOMediaPickerTheme.h"
#import "KSOMediaPickerModel.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"
#import "KSOMediaPickerDefinesPrivate.h"

#import <Agamotto/Agamotto.h>
#import <Stanley/Stanley.h>
#import <Ditko/Ditko.h>
#import <KSOFontAwesomeExtensions/KSOFontAwesomeExtensions.h>

@interface KSOMediaPickerBackgroundView ()
@property (strong,nonatomic) UIStackView *containerView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *button;

@property (strong,nonatomic) KSOMediaPickerModel *model;
@end

@implementation KSOMediaPickerBackgroundView

- (instancetype)initWithModel:(KSOMediaPickerModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    _model = model;
    
    _containerView = [[UIStackView alloc] initWithFrame:CGRectZero];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_containerView setAxis:UILayoutConstraintAxisVertical];
    [_containerView setSpacing:KSOMediaPickerSubviewMargin];
    [_containerView setAlignment:UIStackViewAlignmentLeading];
    [self addSubview:_containerView];
    
    _imageView = [[UIImageView alloc] initWithImage:[[UIImage KSO_fontAwesomeImageWithString:@"\uf03e" size:CGSizeMake(144, 144)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_imageView setContentMode:UIViewContentModeCenter];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_containerView addArrangedSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label setNumberOfLines:0];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [_containerView addArrangedSubview:_label];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_button setTitle:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_PRIVACY_SETTINGS_BUTTON", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Privacy Settings", @"media picker background view privacy settings button") forState:UIControlStateNormal];
    [_button KDI_addBlock:^(__kindof UIControl * _Nonnull control, UIControlEvents controlEvents) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey: [NSBundle mainBundle].KST_bundleIdentifier} completionHandler:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [_containerView addArrangedSubview:_button];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _containerView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]-|" options:9 metrics:nil views:@{@"view": _label}]];
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]]];
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self setBackgroundColor:value.backgroundColor];
        
        [self.imageView setTintColor:[value.backgroundColor KDI_contrastingColor]];
        
        [self.label setFont:value.titleFont];
        [self.label setTextColor:value.titleColor];
        
        [self.button.titleLabel setFont:value.titleFont];
        [self.button setTintColor:value.tintColor];
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,authorizationStatus)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            switch ((KSOMediaPickerAuthorizationStatus)[value integerValue]) {
                case KSOMediaPickerAuthorizationStatusNotDetermined:
                    [self.label setHidden:YES];
                    [self.button setHidden:YES];
                    break;
                case KSOMediaPickerAuthorizationStatusRestricted:
                    [self.label setHidden:NO];
                    [self.label setText:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_AUTH_RESTRICTED_LABEL", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Access to Photos has been restricted. You may be able to adjust this setting within Privacy Settings.", @"media picker background view auth restricted label")];
                    
                    [self.button setHidden:NO];
                    break;
                case KSOMediaPickerAuthorizationStatusDenied:
                    [self.label setHidden:NO];
                    [self.label setText:NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_AUTH_DENIED_LABEL", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Access to Photos has been denied. Please approve access within Privacy Settings.", @"media picker background view auth denied label")];
                    
                    [self.button setHidden:NO];
                    break;
                case KSOMediaPickerAuthorizationStatusAuthorized:
                    [self.label setHidden:YES];
                    [self.button setHidden:YES];
                    break;
                default:
                    break;
            }
        });
    }];
    
    return self;
}

@end
