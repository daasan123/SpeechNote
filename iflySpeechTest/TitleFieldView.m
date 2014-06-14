//
//  TitleFieldView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-13.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "TitleFieldView.h"
@interface TitleFieldView()
{
    CGFloat width;
    CGFloat height;
    CGSize titleSize;
}
@end
@implementation TitleFieldView
@synthesize fontSize;

-(NSInteger)fontSize
{
    return fontSize;
}
-(void)setFontSize:(NSInteger)aFontSize
{
    fontSize=aFontSize;
    self.font=[UIFont systemFontOfSize:fontSize];
}
-(void)refresh
{
    titleSize=[self.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    CGFloat tmpTitleWidth=[@"标题" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}].width;
    if(titleSize.width<tmpTitleWidth)
        titleSize.width=tmpTitleWidth;
    width=self.frame.size.width;
    height=self.frame.size.height;
    [self setNeedsDisplay];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        width=frame.size.width;
        height=frame.size.height;
        self.backgroundColor=[UIColor clearColor];
        self.textAlignment=NSTextAlignmentCenter;
        self.placeholder=@"标题";
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGFloat dash[]={4,6,4};
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineDash(context, 0, dash, 3);
    CGContextMoveToPoint(context, (width-titleSize.width)/2,height-1);
    CGContextAddLineToPoint(context, width-(width-titleSize.width)/2,height-1);
    CGContextStrokePath(context);
}


@end
