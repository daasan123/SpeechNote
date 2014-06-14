//
//  NoteListView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-6-10.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "NoteListView.h"
@interface NoteListView()
{
    NSMutableArray* noteArray;
}
@end
@implementation NoteListView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        //self.dataSource=self;
        //self.delegate=self;
    }
    return self;
}
-(void)noteArrayInit
{
    NSError* error=nil;
    noteArray=[[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"] error:&error]];
    //NSLog(@"noteArray:%@",noteArray);
    if([noteArray containsObject:@".DS_Store"])
        [noteArray removeObject:@".DS_Store"];
    if([noteArray containsObject:@"events.dat"])
        [noteArray removeObject:@"events.dat"];
    if([noteArray containsObject:@"msc_p.log"])
        [noteArray removeObject:@"msc_p.log"];
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
