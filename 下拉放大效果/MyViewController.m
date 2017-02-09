//
//  MyViewController.m
//  下拉放大效果
//
//  Created by kairu on 17/2/7.
//  Copyright © 2017年 凯如科技. All rights reserved.
//

#import "MyViewController.h"
#import "HMObjcSugar.h"
#import "TJWaveView.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define headHeight 200
NSString *const cellId = @"cellId";
@implementation MyViewController{

    UITableView *_tableView;
    UIView *headview;
    UIImageView *headImgView;
    UIStatusBarStyle statusStyle;
    TJWaveView *waveView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    statusStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return statusStyle;
}


- (void)setupSubViews{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    // tableView
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        // 注册.
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
        [self.view addSubview:_tableView];
        _tableView.contentInset = UIEdgeInsetsMake(headHeight, 0, 0, 0);
//        _tableView.backgroundColor = [UIColor whiteColor];
    }
    // headView
    
    {
        headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, headHeight)];
        headview.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1.0];
        [self.view addSubview:headview];
        
        // 加入图片.
        headImgView = [[UIImageView alloc] initWithFrame:headview.bounds];
        //    http://www.who.int/campaigns/immunization-week/2015/large-web-banner.jpg?ua=1
        headImgView.image = [UIImage imageNamed:@"car"];
        [headview addSubview:headImgView];
        headImgView.contentMode = UIViewContentModeScaleAspectFill;
        headImgView.clipsToBounds = YES;
        // 返回按钮.
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(14.5, 32, 40, 21);
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithRed:27.0/255 green:127.0/255 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self.view addSubview:backBtn];
        [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        // titleLel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screenW-100)*0.5, 32, 100, 21)];
        label.text=@"下拉放大";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:27.0/255 green:127.0/255 blue:1.0 alpha:1.0];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:label];
        
        // 波浪
        waveView = [[TJWaveView alloc] initWithFrame:CGRectMake(0, headHeight-20, screenW, 20)];
        [headview addSubview:waveView];
    }

}

-(void)pop{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = @(indexPath.row+1).stringValue;
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offset = scrollView.contentOffset.y+headHeight;
//    NSLog(@"%lf",offset);
    if (offset<=0) { // 下拉放大
        // 调整headView 和headImgView.
        headview.hm_y = 0;
        headview.hm_height = headHeight - offset;
        headImgView.hm_height = headview.hm_height;
        headImgView.alpha = 1.0;
        
    }else{ // 上拉移动
        // 整体移动.
        headview.hm_y = -MIN(offset, headHeight-64);
        // 透明度.
//        NSLog(@"%lf",offset/(headHeight-64));
        headImgView.alpha = 1 - offset/(headHeight-64);
        // 状态栏
        statusStyle = (headImgView.alpha<0.3) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate]; // 必须手动更新状态栏样式.
    }
}

// 开始拖拽调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [waveView stopWave];
}

// 手指放开瞬间调用.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    CGFloat offset = scrollView.contentOffset.y+headHeight;
    NSLog(@"%lf",offset);
    // 改变波浪振幅
    if (fabs(offset)<headHeight) {
        
        waveView.hm_height =  MAX(-offset/2, 10);
        waveView.hm_y = headHeight - waveView.hm_height;
    }
    // 手动更新子控件frame.
    [self.view layoutIfNeeded];
}

// 减速完成调用.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [waveView starWave];
}



@end
