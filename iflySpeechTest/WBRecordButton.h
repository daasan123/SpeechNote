//
//  DrawView.h
//  drawInPath
//
//  Created by 伍 兵 on 14-1-9.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define  VOLUME_MAX 30
#define  VOLUME_MIN 0


@interface WBRecordButton : UIButton
{
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat value;
}
@property(nonatomic,assign) CGFloat maxValue;
@property(nonatomic,assign) CGFloat minValue;
@property(nonatomic,assign) CGFloat value;

@end
