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

#define kActionString() NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_PRIVACY_SETTINGS_BUTTON", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Privacy Settings", @"media picker background view privacy settings button")

@interface KSOMediaPickerBackgroundView ()
@property (strong,nonatomic) KDIEmptyView *emptyView;

@property (strong,nonatomic) KSOMediaPickerModel *model;
@end

@implementation KSOMediaPickerBackgroundView

- (instancetype)initWithModel:(KSOMediaPickerModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    _model = model;
    
    _emptyView = [[KDIEmptyView alloc] initWithFrame:CGRectZero];
    _emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    _emptyView.image = [UIImage KSO_fontAwesomeImageWithString:@"\uf03e" size:CGSizeMake(144, 144)].KDI_templateImage;
    _emptyView.actionBlock = ^(__kindof KDIEmptyView * _Nonnull emptyView) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionsSourceApplicationKey: [NSBundle mainBundle].KST_bundleIdentifier} completionHandler:nil];
    };
    [self addSubview:_emptyView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _emptyView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:9 metrics:nil views:@{@"view": _emptyView}]];
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        [self setBackgroundColor:value.backgroundColor];
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,authorizationStatus),@kstKeypath(self.model,assetCollectionModels)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            self.emptyView.hidden = NO;
            
            switch (self.model.authorizationStatus) {
                case KSOMediaPickerAuthorizationStatusNotDetermined:
                    self.emptyView.body = nil;
                    self.emptyView.action = nil;
                    break;
                case KSOMediaPickerAuthorizationStatusRestricted:
                    self.emptyView.body = NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_AUTH_RESTRICTED_LABEL", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Access to Photos has been restricted. You may be able to adjust this setting within Privacy Settings.", @"media picker background view auth restricted label");
                    self.emptyView.action = kActionString();
                    break;
                case KSOMediaPickerAuthorizationStatusDenied:
                    self.emptyView.body = NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_AUTH_DENIED_LABEL", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"Access to Photos has been denied. Please approve access within Privacy Settings.", @"media picker background view auth denied label");
                    self.emptyView.action = kActionString();
                    break;
                case KSOMediaPickerAuthorizationStatusAuthorized:
                    if (self.model.assetCollectionModels.count > 0) {
                        self.emptyView.hidden = YES;
                    }
                    else {
                        self.emptyView.body = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV ? NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_NO_MEDIA_TV", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"It doesn't look like you have any media to display.", @"media picker background view no media tv") : NSLocalizedStringWithDefaultValue(@"MEDIA_PICKER_BACKGROUND_VIEW_NO_MEDIA", nil, [NSBundle KSO_mediaPickerFrameworkBundle], @"It doesn't look like you have any media to display. Add some media using the Camera or Photos app.", @"media picker background view no media");
                        self.emptyView.action = nil;
                    }
                    break;
                default:
                    break;
            }
        });
    }];
    
    return self;
}

@end
