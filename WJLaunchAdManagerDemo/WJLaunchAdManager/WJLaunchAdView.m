//
//  WJLaunchAdView.m
//  WJLaunchAdManagerDemo
//
//  Created by tqh on 2018/1/8.
//  Copyright © 2018年 tqh. All rights reserved.
//

#import "WJLaunchAdView.h"
#import <UIImageView+YYWebImage.h>

#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kHeightRatio CGRectGetHeight([UIScreen mainScreen].bounds)/667
// 广告显示的时间
static int const showtime = 3;

@interface WJLaunchAdView () {
    dispatch_source_t _timer;
}

@property (nonatomic, strong) UIImageView *launchImage;  //获取启动图
@property (nonatomic, strong) UIImageView *adView;      //广告视图
@property (nonatomic, strong) UIButton *countBtn;       //跳转按钮
@property (nonatomic, strong) NSTimer *countTimer;      //定时器
@property (nonatomic, assign) int count;                //剩余时间 's


@end


@implementation WJLaunchAdView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.launchImage];
        [self addSubview:self.adView];
        [self addSubview:self.countBtn];
        
    }
    return self;
}

#pragma mark - setter

- (void)setModel:(WJLaunchAdModel *)model {
    _model = model;
    [self.adView yy_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholder:nil];
    [self startCoundown];
}

// GCD倒计时
- (void)startCoundown {
    
    __weak __typeof(self) weakSelf = self;
    __block int timeout = showtime ; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf removeAdvertView];
                
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",timeout] forState:UIControlStateNormal];
                timeout--;
            });
            
        }
    });
    
    dispatch_resume(_timer);
}
#pragma mark - 事件监听

- (void)pushToAd {
    
    [self removeAdvertView];
   
    NSLog(@"广告->发送通知跳转到相应界面");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLPushToAdvert" object:nil userInfo:nil];
}

// 移除广告页面
- (void)removeAdvertView {
    
    // 停掉定时器
    dispatch_source_cancel(_timer);
    _timer = nil;
    [UIView animateWithDuration:0.3f animations:^{
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark - 懒加载

- (UIImageView *)launchImage {
    if (!_launchImage) {
        _launchImage = [UIImageView new];
        _launchImage.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight);
        _launchImage.image = [WJLaunchAdView getLaunchImage];
    }
    return _launchImage;
}

- (UIImageView *)adView {
    if (!_adView) {
        _adView = [[UIImageView alloc]init];

        _adView.userInteractionEnabled = YES;
        _adView.backgroundColor = [UIColor whiteColor];
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        _adView.frame = CGRectMake(0, 0, kscreenWidth, kscreenHeight - 181/2*kHeightRatio);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
    }
    return _adView;
}

- (UIButton *)countBtn {
    if (!_countBtn) {
        // 2.跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kscreenWidth - btnW - 24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(removeAdvertView) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
    }
    return _countBtn;
}

#pragma mark - others

+ (UIImage *)getLaunchImage {
    // 获取Assets.xcassets中launchImage
    CGSize viewSize = [[UIApplication sharedApplication] keyWindow].frame.size;
    NSString *viewOrientation = @"Portrait"; //横屏请设置成 @”Landscape”
    NSString *launchImage = nil;
    // build后app包里面有一个info.plist，其中有个UIlaunchImages的array
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

@end

