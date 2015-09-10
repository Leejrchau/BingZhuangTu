//
//  CLMView.m
//  BingZhuangTu
//
//  Created by fuliang123 on 15/1/14.
//  Copyright (c) 2015年 lizhichao. All rights reserved.
//

#import "CLMView.h"

@implementation CLMView
@synthesize valueArray;
@synthesize colorArray;
@synthesize titleArray;
@synthesize spaceHeight;
@synthesize scaleY;

#define K_PI 3.1415
#define KDGREED(x)  ((x) * K_PI * 2)
#define ORIGINX self.bounds.size.width/2.0f

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:1 blue:1 alpha:1.0];
        spaceHeight = 100;//设置图形立体空间的高度（本图中用来设定 饼状图的 饼的高度）
        scaleY = 0.4;// 这个值是用来设定，图形的高度与宽度的比， 高／宽＝0.4
        pathsArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //图形上下文对象，每个图形上下文都维护着一个堆栈，这个堆栈保存图形的状态和设置信息。刚开始创建图形上下文的时候，这个堆栈是空的
    //UIBezierPath
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //设置图形是否抗锯齿
    CGContextSetAllowsAntialiasing(currentContext, YES);
    
    float sum = 0;
    
    for(int i = 0;i < [self.valueArray count];i++){
        
        sum += [[self.valueArray objectAtIndex:i]floatValue];
        
    }
    
    // 开始绘画一个一个子路径，以你指定的坐标点为起始坐标点开始绘画。
    //CGContextMoveToPoint(currentContext,self.bounds.size.width/2.0f, 230);
    float currentangel = 0;
    //将当前的图形状态对象拷贝一份，然后将这个拷贝压入图形上下文堆栈中，之后您对图像所作的操作会影响随后的描画操作，但不影响在堆栈中的这个图像对象的备份。
    CGContextSaveGState(currentContext);
    //这个一个矩阵变化函数，矩阵变化一共有5个函数，这个是缩放变化，作用是，将当前正常的坐标系，缩放成另一个坐标系。缩放的比例有函数的参数指定，第一个参数是这个变化后的坐标系应用在哪个图像上下文对象上，第二个参数指定了x轴的缩放比例，第三个参数指定了y轴的缩放比例。经过如下的变化后，缩放后的坐标系y轴与原来正常的坐标系y轴的比例是scaleY
    CGContextScaleCTM(currentContext, 1.0, scaleY);
    currentangel = 0;
    for(int i = 0;i<[valueArray count];i++){
        float startAngle = KDGREED(currentangel);//开始角度值
        currentangel += [[self.valueArray objectAtIndex:i]floatValue] /sum;//第一个值占总数的百分比来计算 这一段弧长占整个圆的百分比
        float endAngle = KDGREED(currentangel);//结束角度值
        //绘制上面的扇形
        CGContextMoveToPoint(currentContext,ORIGINX, 230);//注意这里，调用这个函数以后，画笔的起始点已经移动到圆心，画圆的时候 是从这里开始的
        // 从颜色数组中取出这个扇形对应的颜色 ，然后在当前的图像上下文中将，以刚才设置的开始点开始绘画，将取出的颜色做为填充色。开始绘画
        [[colorArray objectAtIndex:i%[valueArray count]]setFill];//设置填充色
        //设置 描边颜色（边框颜色）(也就是画笔的颜色)
        [[UIColor blackColor] setStroke];
        //下面是 画圆弧的的函数，参数：currentContext是图形上下文对象，ORIGINX是起始点的x坐标，230是起始点的y坐标，150是半径，startAngle是起始的弧度角，endAngle是结尾的弧度角，最后一个参数表示是逆时针还是顺时针画。0是逆时针，1是顺时针
        CGContextAddArc(currentContext, ORIGINX, 230, 150, startAngle, endAngle, 0);// 这个函数指定要画的弧的信息。这个函数执行后，绘画的路径就定了（这个函数就是画弧，但是画笔的起始点在圆心，这个函数其实只是画了一段弧，不过画笔会从起始点连一条段到弧的起始点）。
        CGContextClosePath(currentContext);//调用这个函数是将上面画好的路径封闭，上面画好后，路径不是封闭的路径，调用这个函数后，在当前路径的结尾点，与路径的开始点之间连一条直线，形成一个封闭的路径
        
        //这个函数是关闭当前路径的子路径，在当前点与起始点之间添加一条线
        //通过上面调用的画弧函数 画完以后就形成了一个路径，然后根据提供的绘画模式 给当前的路径着色，第二个参数指定如何着色，kCGPathFill 是将上面指定的填充色，填充到当前的路径中，kCGPathStroke是将上面指定的边框颜色绘制到当前的路径上，kCGPathFillStroke是将上面指定的填充色，边框颜色，绘制到当前的路径上。
        CGContextDrawPath(currentContext, kCGPathFill);
        
        if(i < 5 ){
            UIBezierPath *bPath = [UIBezierPath bezierPath];
            
            [bPath moveToPoint:CGPointMake(ORIGINX, 230)];
            [bPath addArcWithCenter:CGPointMake(ORIGINX, 230) radius:150 startAngle:startAngle endAngle:endAngle clockwise:1];
    
            [bPath closePath];
            [pathsArray addObject:bPath];
            NSLog(@"stasss %f   end  %f",startAngle,endAngle);
        }
        
        //CGContextDrawPath(currentContext, kCGPathStroke);

        //绘制侧面
        float starx = cos(startAngle) * 150 + ORIGINX;
        
        float stary = sin(startAngle) * 150 + 230;
        //float endx = cos(endAngle) * 150 + ORIGINX;
//        float endy = sin(endAngle) * 150 + 230;
        
        //float endy1 = endy + spaceHeight;
      if(startAngle < K_PI){
        // 只有弧度 《 3.14 的才会绘画前面的厚度
        endAngle =  endAngle > K_PI ? K_PI :endAngle;
        float endx = cos(endAngle) * 150 + ORIGINX;;
        float endy1 = 230 + spaceHeight;
          
          // 绘制厚度
          CGMutablePathRef path = CGPathCreateMutable();
          CGPathMoveToPoint(path, nil, starx, stary);
          CGPathAddArc(path, nil, ORIGINX, 230, 150, startAngle, endAngle, 0);
          CGPathAddLineToPoint(path, nil, endx, endy1);
          
          CGPathAddArc(path, nil, ORIGINX, 230 + spaceHeight, 150, endAngle, startAngle, 1);
          
          [[colorArray objectAtIndex:i%[valueArray count]]setFill];
          
          [[UIColor colorWithWhite:0.9 alpha:1.0]setStroke];
          CGContextAddPath(currentContext, path);
          CGContextDrawPath(currentContext, kCGPathFill);

          [[UIColor colorWithWhite:0.1 alpha:0.4]setFill];
          CGContextAddPath(currentContext, path);
          CGContextDrawPath(currentContext, kCGPathFill);
          CGPathRelease(path);
          
        }else{
            continue;
        }
    }
    
    // 整体渐变(这个componets数组存储的rgb颜色值，这里面有两个元素，每个元素都是有r，g，b，alpha透明度，组成)。要创建几种颜色的渐变色，就往这个数组中添加，每种颜色的颜色值。
    CGFloat componets[] = {0.0,0.0,0.0,0.5,
                                              0.0,0.0,0.0,0.1};
    
    
//    CGFloat locataion[] = {
//        0.9f,
//        0.2f,
//    };
    //创建一个设备相关的颜色空间（这个颜色空间与硬件设备相关，同样的颜色，不同的设备可能出来的颜色效果不一样）
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //不透明梯度 根据提供的颜色空间，创建一个颜色梯度对象 用来创建出渐变色（颜色梯度对象的作用是，将给定的颜色空间，根据制定好的每种颜色的颜色值，透明度，分布的范围，将颜色绘制出来。梯度 顾名思义就是一个渐变的连续数值）
    /*
     
     创建两种渐变色用如下的代码
     // 创建起点颜色
     CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.01f, 0.99f, 0.01f, 1.0f});
     
     // 创建终点颜色
     CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.99f, 0.99f, 0.01f, 1.0f});
     
     // 创建颜色数组
     CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
     
     // 创建渐变对象
     CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
     0.0f,       // 对应起点颜色位置
     1.0f        // 对应终点颜色位置
     });
     
     */

    //创建三种以上的渐变色 用下面的方法（下面的函数，第一个参数是颜色空间对象，第二个参数是需要渐变的颜色数组，第三个参数是每种颜色的位置，每一种颜色都对应一个位置，每个位置都是一个0到1之间的数值,这里的位置是一个相对位置，当下面的画的函数定了以后，会给出开始画的绝对位置，然后用这些相对位置乘上绝对位置得出每种颜色在图形上的位置）
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, componets, nil, 2);
    //下面这个函数是开始绘制渐变色 （第一个参数是图形上下文，第二个参数是颜色梯度对象，第三个参数是绘制颜色的开始位置，这里是一个圆，所以第三个参数是起始圆的圆心，）第四个参数是起始圆的半径，第五个参数是结束圆的圆心，第六个参数是结束圆的半径
    CGContextDrawRadialGradient(currentContext, gradient, CGPointMake(ORIGINX, 230), 0, CGPointMake(ORIGINX, 230), 150,kCGGradientDrawsBeforeStartLocation);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGContextRestoreGState(currentContext);
    
    // 绘制文字
    for(int i = 0;i< [valueArray count];i++){
        
        float origionx = 50;
        float origiony = i*30 + 200;
        
        [[colorArray objectAtIndex:i%[valueArray count]]setFill];
        //绘制小矩形
        CGContextFillRect(currentContext, CGRectMake(origionx, origiony, 20, 20));
        CGContextDrawPath(currentContext, kCGPathFill);
        
        if(i<[titleArray count]){
            
            NSString *title = [titleArray objectAtIndex:i];
            //将字符串 绘制到当前的图形上下文中
            [title drawAtPoint:CGPointMake(origionx + 50, origiony) withAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName]];
        }
        
    }
    
}

-(void)dealloc
{
    titleArray = nil;
    valueArray = nil;
    colorArray = nil;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 因为这里绘图的时候x坐标轴没有变换，但是y坐标轴做了一系矩阵变化，y轴缩小成了正常轴的0.4.所以得到的坐标点 要转换成正确的y值

    point.y = point.y/scaleY;
    
    for(int i = 0;i<pathsArray.count;i++){

        UIBezierPath *pathj = [pathsArray objectAtIndex:i];
        if([pathj containsPoint:point]){
            NSLog(@"index is  %d",i);
        }

    }
    
    
}






@end
