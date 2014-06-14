//
//  NoteObject.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-12.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteObject : NSObject<NSCoding>
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* content;
@property(nonatomic,retain) NSDate* date;
@property(nonatomic,copy) UIImage * thumbImage;
@property(nonatomic,copy) UIImage * backImage;
@property(nonatomic,assign) NSInteger fontSize;
@property(nonatomic,copy) UIColor * fontColor;
@property(nonatomic,assign) NSTextAlignment aligment;
@property(nonatomic,assign) CGSize contentSize;
@end
