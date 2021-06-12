//
//  NSBundle+KSOMediaPickerPrivateExtensions.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/21/17.
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

#import "NSBundle+KSOMediaPickerPrivateExtensions.h"

@implementation NSBundle (KSOMediaPickerPrivateExtensions)

+ (NSBundle *)KSO_mediaPickerFrameworkBundle; {
    return [NSBundle bundleWithIdentifier:@"com.kosoku.ksomediapicker"] ?: [self bundleWithURL:[[[NSBundle mainBundle].privateFrameworksURL URLByAppendingPathComponent:@"KSOMediaPicker.framework" isDirectory:YES] URLByAppendingPathComponent:@"KSOMediaPicker.bundle" isDirectory:YES]] ?: [self bundleWithURL:[[NSBundle mainBundle] URLForResource:@"KSOMediaPicker" withExtension:@"bundle"]];
}

@end
