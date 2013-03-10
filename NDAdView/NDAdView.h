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

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "GADBannerView.h"

#define kAdHeight		50
#define kAdWidth		320
#define kTabBarOffset	114

// Put your AdMob Publisher ID here
#define ADMOB_PUBLISHER_ID	@""

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) /* */
#endif
#define ALog(...) NSLog(__VA_ARGS__)

@protocol NDAdViewDelegate;

typedef enum {
	NDBannerTypeIAd,
	NDBannerTypeAdMob
} BannerType;

@interface NDAdView : UIView <ADBannerViewDelegate, GADBannerViewDelegate> {
	GADBannerView *adMob;
	ADBannerView *iAd;
	
	BannerType type;
	
	BOOL iAdLoaded, adMobLoaded, alreadyLoaded;
}

- (id)initWithPoint:(CGPoint)point defaultType:(BannerType)defualtType rootView:(UIViewController *)root delegate:(id<NDAdViewDelegate>)d;

@property (nonatomic, assign) id <NDAdViewDelegate> delegate;

@end


@protocol NDAdViewDelegate <NSObject>

@optional
//	Both iAd & AdMob Ad's failed
- (void)adViewDidFailToLoad:(NDAdView *)adView;
//	One of the two Ad services recieved an Ad after both failed
- (void)adViewDidLoadAfterFail:(NDAdView *)adView;

@end