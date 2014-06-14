//
//  LeftToolView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-13.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftToolViewDelegate <NSObject>
-(void)leftToolViewClickedButton:(UIButton*)button;
@end

@interface LeftToolView : UIView
{
    id<LeftToolViewDelegate> delegate;
}
@property(nonatomic,assign) id<LeftToolViewDelegate>delegate;
-(void)changeButtonImage:(UIImage*)aImage forButtonTag:(NSInteger)aTag;
@end
