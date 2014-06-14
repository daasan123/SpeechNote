//
//  LeftToolView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-13.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "LeftToolView.h"
@interface LeftToolView()
{
    IBOutlet UIButton* button1;
     IBOutlet UIButton* button2;
     IBOutlet UIButton* button3;
    
}
@end
@implementation LeftToolView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.8];
        //
        UIButton* button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 400, 30, 40);
        button.tag=1;
        [button setTitle:@"笔记" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 480, 30, 40);
        button.tag=2;
        [button setTitle:@"背景" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        //
        button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 560, 30, 40);
        button.tag=3;
        [button setTitle:@"设置" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        //self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.8];
        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftBack.jpg"]];
    }
    return self;
}
-(IBAction)leftToolButtonClicked:(UIButton*)button
{
    [delegate leftToolViewClickedButton:button];
}
-(void)changeButtonImage:(UIImage*)aImage forButtonTag:(NSInteger)aTag
{
   UIButton* button= (UIButton*)[self viewWithTag:aTag];
    //[button setTitle:aTitle forState:UIControlStateNormal];
    [button setImage:aImage forState:UIControlStateNormal];
    
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
