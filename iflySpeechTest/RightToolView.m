//
//  RightToolView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-1.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "RightToolView.h"
#import "WBRecordButton.h"
@interface RightToolView()
{
    NSInteger width;
    NSInteger height;
    IBOutlet WBRecordButton* recordButton;
    
    IBOutlet UIButton* clearButton;
    IBOutlet UIButton* saveButton;
}
@end

@implementation RightToolView
@synthesize delagete;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.8];
        // Initialization code
        
        width=frame.size.width;
        height=frame.size.height;
        
        
        recordButton=[[WBRecordButton alloc] initWithFrame:CGRectMake((width-RIGHT_TOOL_VIEW_BUTTON_WIDTH)/2, height-384-RIGHT_TOOL_VIEW_BUTTON_HEIGHT/2, RIGHT_TOOL_VIEW_BUTTON_WIDTH, RIGHT_TOOL_VIEW_BUTTON_HEIGHT)];
        recordButton.backgroundColor=[UIColor clearColor];
        //NSLog(@"buttonFrame:%@",NSStringFromCGRect(recordButton.frame));
       // [button setTitle:@"start" forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
        [recordButton setBackgroundImage:[UIImage imageNamed:@"recorder.png"] forState:UIControlStateNormal];
        recordButton.tag=1;
        recordButton.value=0;
        [recordButton addTarget:self action:@selector(rightToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordButton];
        
        //保存
        UIButton* button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 400, 30, 40);
        button.tag=2;
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        //删除
        button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 480, 30, 40);
        button.tag=3;
        [button setTitle:@"清空" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
       // self.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.8];
         self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"rightBack.jpg"]];
        // Initialization code
        
        width=self.frame.size.width;
        height=self.frame.size.height;
        
        
        //recordButton=[[WBRecordButton alloc] initWithFrame:CGRectMake((width-RIGHT_TOOL_VIEW_BUTTON_WIDTH)/2, height-384-RIGHT_TOOL_VIEW_BUTTON_HEIGHT/2, RIGHT_TOOL_VIEW_BUTTON_WIDTH, RIGHT_TOOL_VIEW_BUTTON_HEIGHT)];
        //recordButton.backgroundColor=[UIColor clearColor];
        // [button setTitle:@"start" forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:@"recording.png"] forState:UIControlStateNormal];
        //[recordButton setBackgroundImage:[UIImage imageNamed:@"recorder.png"] forState:UIControlStateNormal];
        //recordButton.tag=1;
        recordButton.value=0;
        //[recordButton addTarget:self action:@selector(rightToolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:recordButton];
    }
    return self;
}
-(void)setRecordButtonValue:(NSInteger)aValue
{
    recordButton.value=aValue;
}
-(void)enableRecordButton
{
    recordButton.value=0;
    //recordButton.enabled=YES;
    recordButton.userInteractionEnabled=YES;
    [recordButton setImage:[UIImage imageNamed:@"record_white.png"] forState:UIControlStateNormal];
}
-(IBAction)rightToolButtonClicked:(WBRecordButton*)button
{
   // NSLog(@"tag:%d",button.tag);
    if(button.tag==1)
    {
        button.userInteractionEnabled=NO;
        [button setImage:[UIImage imageNamed:@"record_blue.png"] forState:UIControlStateNormal];
    }
    [delagete rightToolViewClickedButton:button];
}
-(void)dealloc
{
    [recordButton release];
    [super dealloc];
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
