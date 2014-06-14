//
//  TopToolView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(stringColor)

@end
@implementation NSString(stringColor)
-(UIColor*)stringColor
{
    NSArray* tmp=[self componentsSeparatedByString:@","];
    CGFloat r=[[tmp objectAtIndex:0] floatValue];
    CGFloat g=[[tmp objectAtIndex:1] floatValue];
    CGFloat b=[[tmp objectAtIndex:2] floatValue];
    CGFloat a=[[tmp objectAtIndex:3] floatValue];
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
@interface UIColor(colorString)
@end
@implementation UIColor(colorString)
-(NSString*)colorString
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"%f,%f,%f,%f",r,g,b,a];
}

@end


@protocol TopToolViewDelegate <NSObject>
-(void)topToolViewButtonClicked:(UIButton*)aBtn;

@end


@interface TopToolView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet id<TopToolViewDelegate> delegate;
    IBOutlet UISwitch* puncSwitch;
    IBOutlet UIStepper* stepper;
}
@property(nonatomic,assign) IBOutlet id<TopToolViewDelegate> delegate;
-(void)resumeDefault;
@end
