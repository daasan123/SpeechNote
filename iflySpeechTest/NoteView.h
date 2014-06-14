//
//  NoteView.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-1.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleFieldView.h"
#import "NoteTextView.h"
#import "NoteObject.h"
#import <QuartzCore/QuartzCore.h>




@interface NoteView : UIScrollView<UITextFieldDelegate,UITextViewDelegate>
{
    NSString* title;
    NSString* content;
    NSInteger fontSize;
    UIColor * fontColor;
    NSTextAlignment alignment;
    UIImage* backImage;
   
}
@property(nonatomic,assign) NSInteger fontSize;
@property(nonatomic,retain) UIColor * fontColor;
@property(nonatomic,assign) NSTextAlignment alignment;
@property(nonatomic,retain) UIImage* backImage;
@property(nonatomic,retain) NSString* title,*content;
-(void)insertText:(NSString*)aString;
-(void)saveNoteWithThumbImage:(UIImage*)img isTempNote:(BOOL)isTmp;
-(void)clearNote;
-(void)readNoteObj:(NoteObject*)aNoteObj;
-(void)applyChange;
@end
