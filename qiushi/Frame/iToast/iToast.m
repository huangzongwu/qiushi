//
//  iToast.m
//  OBD
//
//  Created by xuanyuan xidong on 12-5-26.
//  Copyright (c) 2012年 Carsmart. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;
static iToastSettings *shortSettings = nil;
static iToastSettings *normalSettings = nil;
static iToastSettings *longSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast


- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

UIButton *v,*vv;
- (void) showWithDuration:(ToastDuration)duration
{
   
    
    iToastSettings *theSettings = [iToastSettings getSharedSettingsWithType:duration];
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIFont *font = [UIFont systemFontOfSize:15.5];
    //	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
    //	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 110 )];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
    label.textAlignment=UITextAlignmentCenter;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
    //	label.shadowOffset = CGSizeMake(1, 1);
	
	v = [UIButton buttonWithType:UIButtonTypeCustom];
    //	v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
    v.frame = CGRectMake(0, 0, 198, 122);
	label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	[v addSubview:label];
	[label release];
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	v.layer.cornerRadius = 10;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point;
	
	if (theSettings.gravity == iToastGravityTop) {
		point = CGPointMake(window.frame.size.width / 2, 45);
	}else if (theSettings.gravity == iToastGravityBottom) {
		point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
	}else if (theSettings.gravity == iToastGravityCenter) {
		point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	}else{
		point = theSettings.postition;
	}
	
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
	v.center = point;
	
	NSTimer *timer1 = [NSTimer 
					   timerWithTimeInterval:((float)theSettings.duration)/1000 
					   target:self 
					   selector:@selector(hideToast:) 
					   userInfo:nil 
					   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:v];
	
	view = [v retain];
    [v release];
}
- (void) show{
	
	iToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [iToastSettings getSharedSettings];
	}
	
	UIFont *font = [UIFont systemFontOfSize:15.5];
//	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
//	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 5, textSize.height + 5)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 110 )];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
    label.textAlignment=UITextAlignmentCenter;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
//	label.shadowOffset = CGSizeMake(1, 1);
	
	vv = [UIButton buttonWithType:UIButtonTypeCustom];
//	v.frame = CGRectMake(0, 0, textSize.width + 10, textSize.height + 10);
    vv.frame = CGRectMake(0, 0, 198, 122);
	label.center = CGPointMake(vv.frame.size.width / 2, vv.frame.size.height / 2);
	[vv addSubview:label];
    [label release];
	vv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	vv.layer.cornerRadius = 10;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point;
	
	if (theSettings.gravity == iToastGravityTop) {
		point = CGPointMake(window.frame.size.width / 2, 45);
	}else if (theSettings.gravity == iToastGravityBottom) {
		point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
	}else if (theSettings.gravity == iToastGravityCenter) {
		point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
	}else{
		point = theSettings.postition;
	}
	
	point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
	vv.center = point;
	
	NSTimer *timer1 = [NSTimer 
					   timerWithTimeInterval:((float)theSettings.duration)/1000 
					   target:self 
					   selector:@selector(hideToast:) 
					   userInfo:nil 
					   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	[window addSubview:vv];
	
	view = [vv retain];
	[vv release];
//	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer2 = [NSTimer 
					   timerWithTimeInterval:500 
					   target:self 
					   selector:@selector(hideToast:) 
					   userInfo:nil 
					   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[[iToast alloc] initWithText:_text] autorelease];
	
	return toast;
}


- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}


+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationNormal;
	}
	
	return sharedSettings;
	
}

+(iToastSettings *) getSharedSettingsWithType:(ToastDuration)duration{
    if (duration == iToastDurationLong) {
        if (!longSettings) {
            longSettings = [iToastSettings new];
            longSettings.gravity = iToastGravityCenter;
            longSettings.duration = iToastDurationLong;
        }
        
        return longSettings;
    }else if(duration==iToastDurationNormal){
        if (!normalSettings) {
            normalSettings = [iToastSettings new];
            normalSettings.gravity = iToastGravityCenter;
            normalSettings.duration = iToastDurationNormal;
        }
        return normalSettings;
    }else if (duration == iToastDurationShort) {
        if (!shortSettings) {
            shortSettings = [iToastSettings new];
            shortSettings.gravity = iToastGravityCenter;
            shortSettings.duration = iToastDurationShort;
        }
        return shortSettings;
    }else {
        if (!normalSettings) {
            normalSettings = [iToastSettings new];
            normalSettings.gravity = iToastGravityCenter;
            normalSettings.duration = iToastDurationNormal;
        }
        return normalSettings;
    }
    
	
}


- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

-(void)dealloc
{
    [v release];
    v=nil;
    [vv release];
    vv=nil;
    [super dealloc];
}
@end
