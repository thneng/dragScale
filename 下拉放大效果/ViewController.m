//
//  ViewController.m
//  下拉放大效果
//
//  Created by kairu on 17/2/7.
//  Copyright © 2017年 凯如科技. All rights reserved.
//

#import "ViewController.h"
#import "MyViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO]; // 右滑返回时,导航栏过早显示,没有动画
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)pushMyVC:(id)sender {
    
    MyViewController *vc = [[MyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
