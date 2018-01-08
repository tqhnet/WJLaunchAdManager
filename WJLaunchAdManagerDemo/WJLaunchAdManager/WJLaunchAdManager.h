//
//  WJLaunchAdManager.h
//  WJLaunchAdManagerDemo
//
//  Created by tqh on 2018/1/8.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJLaunchAdModel.h"

@interface WJLaunchAdManager : NSObject

+ (instancetype)launchAd;
- (void)loadAdDic:(NSDictionary *)dic;
- (void)loadWithModel:(WJLaunchAdModel *)model;
@end
