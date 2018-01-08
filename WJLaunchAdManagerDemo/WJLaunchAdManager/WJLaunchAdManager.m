//
//  WJLaunchAdManager.m
//  WJLaunchAdManagerDemo
//
//  Created by tqh on 2018/1/8.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "WJLaunchAdManager.h"
#import "WJLaunchAdView.h"
#import "AppDelegate.h"
#import "WJLaunchAdModel.h"
#import <MJExtension.h>

@interface WJLaunchAdManager ()

@property (nonatomic,strong) WJLaunchAdView *launch;//广告


@end

@implementation WJLaunchAdManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self common];
    }
    return self;
}

+ (instancetype)launchAd {
    WJLaunchAdManager *manager = [[WJLaunchAdManager alloc]init];
    return manager;
}

- (void)common {
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [window addSubview:self.launch];
}

- (void)loadAdDic:(NSDictionary *)dic {
    if (dic) {
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"WJLaunchAdManager"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"WJLaunchAdManager"];
        
    }
    WJLaunchAdModel *model = [WJLaunchAdModel mj_objectWithKeyValues:dic];
    self.launch.model = model;
}

- (void)loadWithModel:(WJLaunchAdModel *)model {
    
    if (model) {
         NSDictionary *dic = [model mj_keyValues];
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"WJLaunchAdManager"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.launch.model = model;
    }else {
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"WJLaunchAdManager"];
       WJLaunchAdModel *oldModel = [WJLaunchAdModel mj_objectWithKeyValues:dic];
        self.launch.model = oldModel;
    }
}

- (WJLaunchAdView *)launch {
    if (!_launch) {
        _launch = [[WJLaunchAdView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _launch;
}

@end
