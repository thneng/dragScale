//
//  TJWaveView.h
//  下拉放大效果
//
//  Created by kairu on 17/2/9.
//  Copyright © 2017年 凯如科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJWaveView : UIView

/**
 *  波浪的颜色
 */
@property (nonatomic, strong) UIColor *fistWaveFillColor;

/**
 *  波浪的颜色
 */
@property (nonatomic, strong) UIColor *secondWaveFillColor;

/**
 *  波浪的速度
 */
@property (nonatomic, assign) CGFloat speed;

/**
 *  波浪持续时间
 */
@property (nonatomic, assign) CGFloat duration;

- (void)starWave;

- (void)stopWave;

@end
