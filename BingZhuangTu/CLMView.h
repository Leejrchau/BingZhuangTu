//
//  CLMView.h
//  BingZhuangTu
//
//  Created by fuliang123 on 15/1/14.
//  Copyright (c) 2015年 lizhichao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CLMView : UIView
{
    float spaceHeight;//height
    float scaleY;
    NSArray *titleArray;//title
    NSArray *valueArray;//value
    NSArray *colorArray;// color
    NSMutableArray *pathsArray;
}

@property(nonatomic,strong)NSArray *valueArray ;
@property(nonatomic,strong)NSArray *titleArray ;
@property(nonatomic,strong)NSArray *colorArray ;
@property(nonatomic,assign)float spaceHeight;
@property(nonatomic,assign)float scaleY;

@end
