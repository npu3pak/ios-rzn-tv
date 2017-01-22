//
// Created by Евгений Сафронов on 10.07.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <PINCache/PINCache.h>
#import <SDWebImage/SDImageCache.h>
#import "SettingsController.h"

@implementation SettingsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCacheSize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1 && indexPath.section == 0) {
        [self clearCache];
    }
}

- (void)clearCache {
    [[PINCache sharedCache] removeAllObjects];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self showCacheSize];
    }];
}

- (void)showCacheSize {
    double size = [PINCache sharedCache].diskByteCount + [SDImageCache sharedImageCache].getSize;
    size = size / 1024 / 1024;
    NSString *cacheSize = [NSString stringWithFormat:@"Размер кэша: %.2f МБ", size];
    self.cacheSizeLabel.text = cacheSize;
}

@end