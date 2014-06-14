//
//  NoteObject.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-12.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "NoteObject.h"

@implementation NoteObject
@synthesize title,content;
@synthesize date;
@synthesize thumbImage,backImage;
@synthesize fontSize;
@synthesize fontColor;
@synthesize aligment;
@synthesize contentSize;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self.title= [aDecoder decodeObjectForKey:@"title"];
    self.content=[aDecoder decodeObjectForKey:@"content"];
    self.date=[aDecoder decodeObjectForKey:@"date"];
    self.thumbImage=[aDecoder decodeObjectForKey:@"thumbImage"];
    self.backImage=[aDecoder decodeObjectForKey:@"backImage"];
    self.fontSize=[aDecoder decodeIntegerForKey:@"fontSize"];
    self.fontColor=[aDecoder decodeObjectForKey:@"fontColor"];
    self.aligment=[aDecoder decodeIntegerForKey:@"aligment"];
    self.contentSize=[aDecoder decodeCGSizeForKey:@"contentSize"];

    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.thumbImage forKey:@"thumbImage"];
    [aCoder encodeObject:self.backImage forKey:@"backImage"];
    [aCoder encodeInteger:self.fontSize forKey:@"fontSize"];
    [aCoder encodeObject:self.fontColor forKey:@"fontColor"];
    [aCoder encodeInteger:self.aligment forKey:@"aligment"];
    [aCoder encodeCGSize:self.contentSize forKey:@"contentSize"];
}
-(void)dealloc
{
    [backImage release];
    [fontColor release];
    [thumbImage release];
    [title release];
    [content release];
    [date release];
    [super dealloc];
}
@end
