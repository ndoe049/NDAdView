//
//  NDAdView.h
//	Version 0.2
//
//  Created by Nathan Doe on 8/19/12.
//  Copyright (c) 2012 Nathaniel Doe.
//

// This code is distributed under the terms and conditions of the MIT license.

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NDAdView.h"

#define TESTING 0

@implementation NDAdView

@synthesize delegate;

- (id)initWithPoint:(CGPoint)point defaultType:(BannerType)defualtType rootView:(UIViewController *)root delegate:(id<NDAdViewDelegate>)d {
	CGRect frame = CGRectMake(point.x, point.y, kAdWidth, kAdHeight);
	self = [super initWithFrame:frame];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		
		if (!d) {
			DLog(@"Ad view doesn't have a delegate!!!");
		} else {
			[self setDelegate:d];
		}
		
		type = defualtType;
		
		iAdLoaded = NO;
		adMobLoaded = NO;
		alreadyLoaded = NO;
		
		//initialize the admob view
		adMob = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
		[adMob setAdUnitID:ADMOB_PUBLISHER_ID];
		[adMob setDelegate:self];
		[adMob setRootViewController:root];
		
		GADRequest *request = [GADRequest request];
		
		if (TESTING) {
			DLog(@"Don't submit app binary with Ad Testing On!!!");
			//https://developers.google.com/mobile-ads-sdk/docs/admob/best-practices#testmode
			request.testing = TESTING;
			request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
		}
		
		[adMob loadRequest:request];
		
		//initialize iad
		iAd = [[ADBannerView alloc] init];
		[iAd setDelegate:self];
		
		[self addSubview:adMob];
		[self addSubview:iAd];
		
		switch (type) {
			case NDBannerTypeIAd:
				[adMob setHidden:YES];
				break;
			case NDBannerTypeAdMob:
				[iAd setHidden:YES];
				break;
			default:
				break;
		}
	}
	return self;
}

#pragma mark - Helper Methods 

// Check to determine if both Ad's have failed 
- (void)checkForBothFail {
	if (alreadyLoaded && !iAdLoaded && !adMobLoaded) {
		if ([delegate respondsToSelector:@selector(adViewDidFailToLoad:)]) {
			[delegate adViewDidFailToLoad:self];
		}
	}
}

// Check to determine if both Ad's have failed previously before getting a Ad
- (void)checkForLoadFromFail {
	if (alreadyLoaded && !iAdLoaded && !adMobLoaded) {
		if ([delegate respondsToSelector:@selector(adViewDidLoadAfterFail:)]) {
			[delegate adViewDidLoadAfterFail:self];
		}
	}
}

#pragma mark - Animations 

- (void)animateViewOff:(UIView *)view withDuration:(NSTimeInterval)interval {
	[UIView beginAnimations:@"animateBannerOff" context:NULL];
	[UIView setAnimationDuration:interval];
	[view setHidden:YES];
	[UIView commitAnimations];
}

- (void)animateViewOn:(UIView *)view withDuration:(NSTimeInterval)interval {
	[UIView beginAnimations:@"animateBannerOn" context:NULL];
	[UIView setAnimationDuration:interval];
	[view setHidden:NO];
	[UIView commitAnimations];
}

#pragma mark - ADBannerView Delegate 

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	
	[self checkForLoadFromFail];
	
	iAdLoaded = YES;
	alreadyLoaded = YES;
	if (banner == iAd && (type == NDBannerTypeIAd || !adMobLoaded)) {
		if (banner.hidden) {
			[self sendSubviewToBack:iAd];
			[iAd setHidden:NO];
			[self animateViewOff:adMob withDuration:1.0f];
		}
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	iAdLoaded = NO;
	if (banner == iAd && type == NDBannerTypeIAd) {
		if (!banner.hidden) {
			[self sendSubviewToBack:adMob];
			[self animateViewOn:adMob withDuration:1.0f];
			[iAd setHidden:YES];
		}
	}
	[self checkForBothFail];
}

#pragma mark - GADBannerView Delegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
	
	[self checkForLoadFromFail];
	
	adMobLoaded = YES;
	alreadyLoaded = YES;
	if (bannerView == adMob && (type == NDBannerTypeAdMob || !iAdLoaded)) {
		if (bannerView.hidden) {
			[self sendSubviewToBack:adMob];
			[adMob setHidden:NO];
			[self animateViewOff:iAd withDuration:1.0f];
		}
	}
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
	adMobLoaded = NO;
	if (bannerView == adMob && type == NDBannerTypeAdMob) {
		if (!bannerView.hidden) {
			[self sendSubviewToBack:iAd];
			[self animateViewOn:iAd withDuration:1.0f];
			[adMob setHidden:YES];
		}
	}
	[self checkForBothFail];
}

@end
