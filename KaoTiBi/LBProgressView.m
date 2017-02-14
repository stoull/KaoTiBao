//
//  LBProgressView.m
//  LinkPortal
//
//  Created by Stoull Hut on 8/31/16.
//  Copyright © 2016 linkapp. All rights reserved.
//

#import "LBProgressView.h"

@implementation LBProgressView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat radius;
    radius = width > height ? height : width;
    radius = radius / 2  - radius * 1/6;
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath moveToPoint:CGPointMake(width/2, height/2)];
    [arcPath addArcWithCenter:CGPointMake(width/2, height/2) radius:radius startAngle:0 endAngle:2 * M_PI * _progress clockwise:YES];
    [arcPath closePath];
    CGContextAddPath(ctx, arcPath.CGPath);
    [[UIColor grayColor] set];
    CGContextFillPath(ctx);
}

@end
