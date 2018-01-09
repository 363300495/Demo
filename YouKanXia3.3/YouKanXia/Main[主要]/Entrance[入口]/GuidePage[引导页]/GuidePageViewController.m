//
//  GuidePageViewController.m
//  YouKanXia
//
//  Created by 汪立 on 2017/4/25.
//  Copyright © 2017年 youyou. All rights reserved.
//

#import "GuidePageViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView *guideScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:guideScrollView];
    
    for (int i = 0; i < 3; i++) {
        NSString *imageName = [NSString stringWithFormat:@"guidePage%d" ,i+1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        imageView.userInteractionEnabled = YES;
        [guideScrollView addSubview:imageView];
        
        if(i==2){
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMainTapAction:)];
            [imageView addGestureRecognizer:tapGesture];
  
        }
    }

    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT);
    guideScrollView.pagingEnabled = YES;
    guideScrollView.bounces = NO;
    guideScrollView.backgroundColor = [UIColor grayColor];
    
}

- (void)goToMainTapAction:(UITapGestureRecognizer *)tap{
    
    [self goToMain];
    
}


//进入主页面
- (void)goToMain
{
    [[UIApplication sharedApplication].keyWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    MainViewController *mainVC = [[MainViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mainVC = mainVC;
}


@end
