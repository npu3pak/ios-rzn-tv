//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AppSectionItem;

@interface ItemWebDetailsController : UIViewController <UIWebViewDelegate>

@property IBOutlet UIWebView *webView;
@property IBOutlet UIView *loadingIndicatorView;
@property IBOutlet UILabel *errorLabel;

@property AppSectionItem *sectionItem;

@end