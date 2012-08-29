//
//  QiuShi.m
//  NetDemo
//
//  Created by Michael  on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QiuShi.h"

@implementation QiuShi
@synthesize imageMidURL;
@synthesize imageURL;
@synthesize published_at;
@synthesize tag;
@synthesize qiushiID;
@synthesize content;
@synthesize commentsCount;
@synthesize downCount,upCount;
@synthesize anchor;
@synthesize fbTime;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.tag = [dictionary objectForKey:@"tag"];
        self.qiushiID = [dictionary objectForKey:@"id"];
        self.content = [dictionary objectForKey:@"content"];
        self.published_at = [[dictionary objectForKey:@"published_at"] doubleValue];
        self.commentsCount = [[dictionary objectForKey:@"comments_count"] intValue];
        
        id image = [dictionary objectForKey:@"image"];
        if ((NSNull *)image != [NSNull null]) 
        {
            self.imageURL = [dictionary objectForKey:@"image"];

            NSString *newImageURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/small/%@",qiushiID,imageURL];
            NSString *newImageMidURL = [NSString stringWithFormat:@"http://img.qiushibaike.com/system/pictures/%@/medium/%@",qiushiID,imageURL];
            self.imageURL = newImageURL;
            self.imageMidURL = newImageMidURL;
        }
        
        NSDictionary *vote = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"votes"]];
        self.downCount = [[vote objectForKey:@"down"]intValue];
        self.upCount = [[vote objectForKey:@"up"]intValue];
        
        id user = [dictionary objectForKey:@"user"];
        if ((NSNull *)user != [NSNull null]) 
        {
            NSDictionary *user = [NSDictionary dictionaryWithDictionary:[dictionary objectForKey:@"user"]];
            self.anchor = [user objectForKey:@"login"];
        }
    }
    return self;
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif




@end
