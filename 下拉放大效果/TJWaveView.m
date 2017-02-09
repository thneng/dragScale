//
//  TJWaveView.m
//  下拉放大效果
//
//  Created by kairu on 17/2/9.
//  Copyright © 2017年 凯如科技. All rights reserved.
//

#import "TJWaveView.h"

@interface TJWaveView ()
@property (nonatomic, assign) CGFloat waveW; // 波浪的宽
@property (nonatomic, assign) CGFloat waveH; // 波浪的高
@property (nonatomic, assign) CGFloat waveAmplitude; // 振幅
@property (nonatomic, assign) CGFloat offsetX; // x方向偏移量
@property (nonatomic, strong) CADisplayLink *displayLink; //定时器
@property (nonatomic, strong) CAShapeLayer *firstShapeLayer; // 显示第一条波浪
@property (nonatomic, strong) CAShapeLayer *secondShapeLayer;// 显示第二条波浪
@end

@implementation TJWaveView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIColor *)fistWaveFillColor {

    if (!_fistWaveFillColor) {
        return  [UIColor yellowColor];
    }
        
    return _fistWaveFillColor;
}

- (UIColor *)secondWaveFillColor {
    
    if (!_secondWaveFillColor) {
        return  [UIColor redColor];
    }
    
    return _secondWaveFillColor;
}

- (void)setSpeed:(CGFloat)speed {
    _speed = speed;
}

- (void)setDuration:(CGFloat)duration {
    _duration = duration;
}

- (void)stopWave{
    [self.displayLink invalidate];
    [self.firstShapeLayer removeFromSuperlayer];
    [self.secondShapeLayer removeFromSuperlayer];
}


- (void)starWave{

    // 给定初始值(波宽,振幅).
    self.waveW = self.frame.size.width;
    self.waveH = self.frame.size.height;
    self.waveAmplitude = 0.5 * self.waveH;
    // 创建第一条波浪图层.
    self.firstShapeLayer = [self creatShapeLayerWithFillColor:self.fistWaveFillColor borderWidth:1];
    [self.layer addSublayer:self.firstShapeLayer];
    // 创建第二条波浪图层.
    self.secondShapeLayer = [self creatShapeLayerWithFillColor:self.secondWaveFillColor borderWidth:1];
    [self.layer addSublayer:self.secondShapeLayer];
    
    // 创建定时器.
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setshaplayerPaht)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 创建图层.
- (CAShapeLayer *)creatShapeLayerWithFillColor:(UIColor *)fillColor borderWidth:(CGFloat)borderWidth{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = fillColor.CGColor;
    layer.borderWidth = borderWidth;
    return layer;
}


// 设置波浪函数.
- (void)setshaplayerPaht{
    
    if (!self.speed) {
        self.speed = 1.0;
    }
    
    if (!self.duration) {
        self.duration = 2.0;
    }
    // 波的X方向变化速度不断加快
    self.offsetX += (self.waveW / 60 * self.speed);
    // 波的振幅不断减小，形成水波更为逼真
    self.waveAmplitude -= (0.5 * self.waveH / 60.0 / self.duration);
    
    if (self.waveAmplitude < 0.1) {
        [self stopWave];
    }
    self.firstShapeLayer.path = [self sinBezierPath].CGPath;
    self.secondShapeLayer.path = [self cosBezierPath].CGPath;
}

/**
 *  画正玄线
 *
 *  @return UIBezierPath 对象
 */
- (UIBezierPath *)sinBezierPath {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.waveH)];
    
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <= self.waveW; x++) {
        y = self.waveAmplitude * sin((4 * M_PI / self.waveW) * (x + self.offsetX)) + self.waveH - self.waveAmplitude;
        
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(self.waveW, self.waveH)];
    [path closePath];
    return path;
}

/**
 *  画余弦线
 *
 *  @return UIBezierPath 对象
 */
- (UIBezierPath *)cosBezierPath {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.waveH)];
    
    CGFloat y = 0.0f;
    for (float x = 0.0f; x <= self.waveW; x++) {
//        y = self.waveAmplitude * cos((4 * M_PI / self.waveW) * (x + self.offsetX)) + self.waveH - self.waveAmplitude;
        // 需向左偏移四分之一周期,使得余弦波浪的波峰对着正玄函数的波谷
        CGFloat forward = 2*M_PI / (4 * M_PI / self.waveW) / 4;
        y = self.waveAmplitude * cos((4 * M_PI / self.waveW) * (x + self.offsetX + forward)) + self.waveH - self.waveAmplitude;
        
        [path addLineToPoint:CGPointMake(x, y)];
    }
    [path addLineToPoint:CGPointMake(self.waveW, self.waveH)];
    [path closePath];
    return path;
}

@end
