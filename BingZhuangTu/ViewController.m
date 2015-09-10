//
//  ViewController.m
//  BingZhuangTu
//
//  Created by fuliang123 on 15/1/13.
//  Copyright (c) 2015年 lizhichao. All rights reserved.
//

#import "ViewController.h"
#import "CLMView.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize onetableDatacostchat;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CLMView *cv = [[CLMView alloc] initWithFrame:self.view.bounds];//实例化
    
    //指定标题数组
    cv.titleArray = [NSArray  arrayWithObjects:@"iphone", @"sybian", @"windowbile", @"mego",@"android",nil];
    
    //指定数值比例数组
    cv.valueArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:20],
                   [NSNumber numberWithFloat:40],[NSNumber numberWithFloat:10],[NSNumber numberWithFloat:20],nil];
    //指定颜色数组
    cv.colorArray = [NSArray arrayWithObjects:[UIColor yellowColor], [UIColor blueColor], [UIColor brownColor], [UIColor purpleColor] , [UIColor orangeColor],nil];
    
    [self.view addSubview: cv];
    
      // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
