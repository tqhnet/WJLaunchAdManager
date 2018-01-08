//
//  WJLaunchAdModel.h
//  WJLaunchAdManagerDemo
//
//  Created by tqh on 2018/1/8.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJLaunchAdModel : NSObject

@property (nonatomic,copy) NSString *imageUrl;   //广告地址
@property (nonatomic,assign) NSInteger type;    //类型
@property (nonatomic,copy) NSString *url;       //跳转地址

@end
