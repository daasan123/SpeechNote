//
//  DrawView.m
//  drawInPath
//
//  Created by 伍 兵 on 14-1-9.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "WBRecordButton.h"

@interface GaugeLayer : CALayer
{
}
@property(nonatomic,assign) CGFloat value;

@end
@implementation GaugeLayer
@synthesize value;

-(id)init
{
    self=[super init];
    if(self)
    {
    }
    return self;
}
- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[GaugeLayer class]])
        {
            self.value = [(GaugeLayer *)layer value];
        }
    }
    return self;
}
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"value"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}


-(void)drawInContext:(CGContextRef)ctx
{
#if 0
    CGRect rect=CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height*value);
    CGContextFillRect(ctx, rect);
#else
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 12);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.98 alpha:0.98].CGColor);
    CGContextMoveToPoint(ctx, self.bounds.size.width/2.0, 24);
    CGContextAddLineToPoint(ctx, self.bounds.size.width/2.0, MAX(6 ,24*(1-value)));
    CGContextStrokePath(ctx);
    
#endif
}
-(void)dealloc
{
    [super dealloc];
}
@end



@interface WBRecordButton()
{
    CGFloat width;
    CGFloat height;
    GaugeLayer* gaugeLayer;
}
@end
@implementation WBRecordButton
@synthesize maxValue,minValue;
-(void)setValue:(CGFloat)aValue
{
    if (aValue>maxValue)
    {
        aValue =maxValue;
    }
    if (aValue<=minValue)
    {
        aValue=minValue;
    }
    
    value=(aValue-minValue)/(maxValue-minValue);
    /*
     //不使用动画
     [aLayer setProgress:progress];
     [aLayer setNeedsDisplay];
     */
    
    //使用动画
    CFTimeInterval duration = fabs(value-aValue)*0.01;
    CABasicAnimation *animtion = [CABasicAnimation animationWithKeyPath:@"value"];
    [animtion setRemovedOnCompletion:YES];
    [animtion setFillMode:kCAFillModeForwards];
    animtion.duration = duration;
    animtion.toValue = [NSNumber numberWithDouble:value];
    [animtion setDelegate:self];
    [gaugeLayer addAnimation:animtion forKey:nil];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    gaugeLayer.value=value;
}
-(CGFloat)value
{
    return value;
}
-(void)dataInit
{
    width=self.frame.size.width;
    height=self.frame.size.height;
    //self.backgroundColor=[UIColor yellowColor];
    //self.layer.cornerRadius=width/2;
    //self.layer.borderWidth=2;
    //self.layer.borderColor=[UIColor blueColor].CGColor;
    //[self.layer setMasksToBounds:YES];

    maxValue=VOLUME_MAX;
    minValue=VOLUME_MIN;
    value=0;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self dataInit];
        /*
        UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width/2-40, height/2-40)];
        imageView.layer.borderColor=[UIColor redColor].CGColor;
        imageView.layer.borderWidth=1;
        
        imageView.center=CGPointMake(width/2, height/2);
        
        imageView.image=[UIImage imageNamed:@"record.png"];
        //[self addSubview:imageView];
        [imageView release];*/
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self dataInit];
        gaugeLayer=[[GaugeLayer alloc] init];
        gaugeLayer.frame=CGRectMake(0, 0, width, height);
        gaugeLayer.needsDisplayOnBoundsChange=YES;
        gaugeLayer.backgroundColor=[UIColor clearColor].CGColor;
        gaugeLayer.value=0.0;
        [gaugeLayer setNeedsDisplay];
        [self.layer addSublayer:gaugeLayer];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGFloat a=value/(maxValue-minValue);
    
    //CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:30 blue:213 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0,height*(1-a), width,height*a));
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextAddArc(context, width/2, height/2, width/2-10, 0, 2*M_PI, YES);
    CGContextFillPath(context);
}*/
@end
