//
//  ViewController.m
//  NDAdViewExample
//
//  Created by Nathan Doe on 3/10/13.
//  Copyright (c) 2013 Nathaniel Doe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - NDADView Delegate

- (void)adViewDidFailToLoad:(NDAdView *)adView {
	[adView removeFromSuperview];
}

- (void)adViewDidLoadAfterFail:(NDAdView *)adView {
	[self.view addSubview:adView];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];

	if ([ADMOB_PUBLISHER_ID isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No AdMob ID" message:@"You have not entered your AdMob Publisher ID yet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
	}
	
	NDAdView *adView = [[NDAdView alloc] initWithPoint:CGPointMake(0.0, 0.0) defaultType:NDBannerTypeIAd rootView:self delegate:self];
	[self.view addSubview:adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
