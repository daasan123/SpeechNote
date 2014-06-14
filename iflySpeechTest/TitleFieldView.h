//
//  TitleFieldView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-13.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleFieldView : UITextField
//@property(nonatomic,assign) CGSize titleSize;
@property(nonatomic,assign) NSInteger fontSize;
-(void)refresh;
@end
