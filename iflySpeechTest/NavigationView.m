//
//  NavigationView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-6-11.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
