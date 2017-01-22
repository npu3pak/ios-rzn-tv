//
// Created by Евгений Сафронов on 24.02.15.
// Copyright (c) 2015 rzn.tv. All rights reserved.
//

#import "ItemWebDetailsController.h"
#import "AppSectionItem.h"
#import "DataSource.h"
#import "NSDate+RznTv.h"


@implementation ItemWebDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self showBarItems];
    [self loadContent:YES];
}

- (void)showBarItems {
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RefreshImage"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(onRefreshButtonClick:)];

    UIBarButtonItem *openInBrowserButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"OpenInBrowserImage"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(openInSafari)];
    self.navigationItem.rightBarButtonItems = @[openInBrowserButton, refreshButton];
}

- (void)loadContent:(BOOL)useCache {
    self.loadingIndicatorView.hidden = NO;
    self.webView.hidden = YES;

    void (^errorCallback)(NSString *) = ^(NSString *message) {
        [self showErrorMessage:message];
    };

    void (^successCallback)(NSString *) = ^(NSString *page) {
        NSURL *baseUrl = [NSURL URLWithString:self.sectionItem.contentUrl];
        NSString *content = [self getContentWithHeaderAndFooter:page];
        [self.webView loadHTMLString:content baseURL:baseUrl];
        [self showContentView];
    };

    [self showLoadingView];
    [[DataSource sharedDataSource] loadItemWebContentForItem:self.sectionItem useCache:useCache successCallback:successCallback errorCallback:errorCallback];
}

- (NSString *)getContentWithHeaderAndFooter:(NSString *)contentString {
    NSString *formatDate = self.sectionItem.timeStamp.stringValue;
    NSString *textHeader = [NSString stringWithFormat:@"<h1>%@</h1>", self.sectionItem.title];
    NSString *previewHeader = [NSString stringWithFormat:@"<p><i>%@</i></p>", self.sectionItem.note];
    NSString *dateFooter = [NSString stringWithFormat:@"<p><i>%@</i></p>", formatDate];
    NSString *imageHeader = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%@\"/>", self.sectionItem.imageUrl, @"100%"];
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", imageHeader, textHeader, previewHeader, contentString, dateFooter];
}

- (void)showLoadingView {
    self.loadingIndicatorView.hidden = NO;
    self.webView.hidden = YES;
    self.errorLabel.hidden = YES;
}

- (void)showContentView {
    self.loadingIndicatorView.hidden = YES;
    self.webView.hidden = NO;
    self.errorLabel.hidden = YES;
}

- (void)showErrorMessage:(NSString *)errorMessage {
    self.loadingIndicatorView.hidden = YES;
    self.webView.hidden = YES;
    self.errorLabel.hidden = NO;
    self.errorLabel.text = errorMessage;
}

- (void)onRefreshButtonClick:(id)onRefreshButtonClick {
    [self loadContent:NO];
}

- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.sectionItem.siteUrl]];
}

#pragma mark Обработка событий WebView

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end