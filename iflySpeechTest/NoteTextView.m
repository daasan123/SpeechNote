//
//  NoteTextView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-8.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "NoteTextView.h"

@interface NoteTextView()
{
    NSInteger width;
    NSInteger height;
}
@end


@implementation NoteTextView
@synthesize contentHeight;
-(NSInteger)fontSize
{
    return fontSize;
}
-(void)setFontSize:(NSInteger)aFontSize
{
    fontSize=aFontSize;
    self.font=[UIFont systemFontOfSize:fontSize];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        width=frame.size.width;
        height=frame.size.height;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    width=frame.size.width;
    height=frame.size.height;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        width=self.frame.size.width;
        height=self.frame.size.height;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGFloat deltH= (fontSize-20)/5+(fontSize%5==0?0:1)+20;
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGFloat dash[]={4,6,4};
    CGContextSetLineDash(context, 0, dash, 3);
    CGFloat lineHeight=fontSize*1.193;
    NSInteger lineCount=self.contentHeight/lineHeight;
    //NSLog(@"lineCount:%d",lineCount);
    for(int i=0;i<lineCount;i++)
    {
        CGContextMoveToPoint(context, 0, lineHeight*(i+1)+deltH/2.0-2);
        CGContextAddLineToPoint(context, width, lineHeight*(i+1)+deltH/2.0-2);
    }
    //CGContextMoveToPoint(context, 0, self.contentHeight- deltH/2.0-2);
    //CGContextAddLineToPoint(context, width, self.contentHeight-deltH/2.0-2);
    CGContextStrokePath(context);
}

@end
