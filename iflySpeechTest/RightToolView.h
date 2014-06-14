//
//  RightToolView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-1.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RIGHT_TOOL_VIEW_BUTTON_WIDTH 45
#define RIGHT_TOOL_VIEW_BUTTON_HEIGHT 45

@protocol RightToolViewDelegate <NSObject>
-(void)rightToolViewClickedButton:(UIButton*)button;
@end



@interface RightToolView : UIView
{
    id<RightToolViewDelegate>delegate;
}
-(void)setRecordButtonValue:(NSInteger)aValue;
-(void)enableRecordButton;
@property(nonatomic,assign) id<RightToolViewDelegate>delagete;
@end
