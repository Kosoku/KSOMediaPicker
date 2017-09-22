//
//  KSOMediaPickerThumbnailView.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/24/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSOMediaPickerThumbnailView.h"

@interface KSOMediaPickerThumbnailView ()
@property (readwrite,strong,nonatomic) UIImageView *thumbnailImageView;

- (void)_KSOMediaPickerThumbnailViewInit;
@end

@implementation KSOMediaPickerThumbnailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _KSOMediaPickerThumbnailViewInit];
    
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _KSOMediaPickerThumbnailViewInit];
    
    return self;
}

- (void)_KSOMediaPickerThumbnailViewInit; {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBorderWidth:1.0];
    [self setBorderOptions:KDIBorderOptionsTop];
    
    _thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_thumbnailImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_thumbnailImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_thumbnailImageView setClipsToBounds:YES];
    [self addSubview:_thumbnailImageView];
    
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _thumbnailImageView}]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]|" options:0 metrics:@{@"margin": @(self.borderWidth)} views:@{@"view": _thumbnailImageView}]];
}

@end
