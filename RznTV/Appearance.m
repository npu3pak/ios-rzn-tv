//
// Created by Евгений Сафронов on 03.03.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "Appearance.h"
#import "UIKit/UIKit.h"
#import "UIColor+RznTv.h"
#import "Constants.h"


@implementation Appearance

-(void)applyAppStyle{
    UIColor *textColor = [UIColor whiteColor];
    UIColor *toolbarColor = [UIColor colorFromRgb:TOOLBAR_BACKGROUND_COLOR];
    UIImage *toolbarBackgroundImage = [toolbarColor coloredImage];

    [UIToolbar.appearance setTintColor:toolbarColor];
    [UIToolbar.appearance setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [UINavigationBar.appearance setTintColor:textColor];
    [UINavigationBar.appearance setBarStyle:UIBarStyleBlack];
    [UINavigationBar.appearance setBackgroundImage:toolbarBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

@end