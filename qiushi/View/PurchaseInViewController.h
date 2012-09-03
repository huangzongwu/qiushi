//
//  PurchaseInViewController.h
//  qiushi
//
//  Created by xyxd mac on 12-8-31.
//  Copyright (c) 2012年 XYXD. All rights reserved.
//

#import "ViewController.h"

#import <StoreKit/StoreKit.h>
enum{
    IAP0p99=10,
    IAP1p99,
    IAP4p99,
    IAP9p99,
    IAP24p99,
}buyCoinsTag;

@interface PurchaseInViewController : ViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    int buyType;
}

@end
