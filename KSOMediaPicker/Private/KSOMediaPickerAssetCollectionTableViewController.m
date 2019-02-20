//
//  KSOMediaPickerAssetCollectionTableViewController.m
//  KSOMediaPicker
//
//  Created by William Towe on 3/23/17.
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

#import "KSOMediaPickerAssetCollectionTableViewController.h"
#import "KSOMediaPickerModel.h"
#import "KSOMediaPickerAssetCollectionModel.h"
#import "KSOMediaPickerAssetCollectionTableViewCell.h"
#import "KSOMediaPickerAssetCollectionViewController.h"
#import "KSOMediaPickerTheme.h"
#import "NSBundle+KSOMediaPickerPrivateExtensions.h"
#import "KSOMediaPickerBackgroundView.h"

#import <Stanley/Stanley.h>
#import <Agamotto/Agamotto.h>

@interface KSOMediaPickerAssetCollectionTableViewController ()
@property (strong,nonatomic) KSOMediaPickerModel *model;
@end

@implementation KSOMediaPickerAssetCollectionTableViewController

- (void)dealloc {
    KSTLogObject(self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEstimatedRowHeight:44.0];
#if (TARGET_OS_IOS)
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(KSOMediaPickerAssetCollectionTableViewCell.class) bundle:[NSBundle KSO_mediaPickerFrameworkBundle]] forCellReuseIdentifier:NSStringFromClass(KSOMediaPickerAssetCollectionTableViewCell.class)];
#else
    [self.tableView registerClass:KSOMediaPickerAssetCollectionTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KSOMediaPickerAssetCollectionTableViewCell.class)];
#endif
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView setBackgroundView:[[KSOMediaPickerBackgroundView alloc] initWithModel:self.model]];
    
    kstWeakify(self);
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,assetCollectionModels)] options:0 block:^(NSString * _Nonnull keyPath, id  _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.tableView reloadData];
        });
    }];
    
    [self.model KAG_addObserverForKeyPaths:@[@kstKeypath(self.model,theme)] options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull keyPath, KSOMediaPickerTheme * _Nullable value, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        kstStrongify(self);
        KSTDispatchMainAsync(^{
            [self.tableView setBackgroundColor:value.backgroundColor];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.assetCollectionModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSOMediaPickerAssetCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KSOMediaPickerAssetCollectionTableViewCell class]) forIndexPath:indexPath];
    
    [cell setModel:self.model.assetCollectionModels[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.model setSelectedAssetCollectionModel:self.model.assetCollectionModels[indexPath.row]];
    
    [self.navigationController pushViewController:[[KSOMediaPickerAssetCollectionViewController alloc] initWithModel:self.model] animated:YES];
}

- (instancetype)initWithModel:(KSOMediaPickerModel *)model; {
    if (!(self = [super initWithStyle:UITableViewStylePlain]))
        return nil;
    
    _model = model;
    
    return self;
}

@end
