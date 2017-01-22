//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>
#import "StartController.h"
#import "MenuController.h"
#import "ItemsListController.h"

@implementation StartController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    ItemsListController *previewListController = [storyboard instantiateViewControllerWithIdentifier:@"itemsListController"];
    UINavigationController *previewListNavigationController = [[UINavigationController alloc] initWithRootViewController:previewListController];

    MenuController *menuController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    menuController.contentView = previewListController;

    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:previewListNavigationController leftDrawerViewController:menuController];
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView | MMOpenDrawerGestureModePanningNavigationBar;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModePanningCenterView | MMCloseDrawerGestureModeTapCenterView;

    [UIApplication.sharedApplication.delegate.window setRootViewController:drawerController];
}

@end