//
//  NoteTextView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-8.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTextView : UITextView
{
    NSInteger fontSize;
    CGFloat contentHeight;
}
@property(nonatomic,assign) NSInteger fontSize;
@property(nonatomic,assign) CGFloat contentHeight;
@end
