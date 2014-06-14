//
//  NoteView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-1-1.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "NoteView.h"

@interface NoteView()
{
    NSInteger lineHeight;
    CGFloat width;
    CGFloat height;
    CGFloat deltHeight;
     NoteTextView * textView;
    TitleFieldView* titleField;
     CGSize titleSize;
    
    BOOL isTitleResponse;
    BOOL isEditing;
    
    CGSize  textContentSize;
    
    CGRect visibleRect;
}
@end
@implementation NoteView
@synthesize title,content;
@synthesize fontSize,fontColor,alignment;
//背景
-(void)setBackImage:(UIImage *)aImage
{
    if(backImage!=aImage)
    {
        [backImage release];
        backImage=[aImage retain];
        [self setNeedsDisplay];
    }
}
-(UIImage*)backImage
{
    return backImage;
}

-(void)applyChange
{
    //textView.text=self.content;
    textView.textAlignment=self.alignment;
    textView.fontSize=self.fontSize;
    textView.textColor=self.fontColor;
    
    titleField.text=self.title;
    titleField.fontSize=self.fontSize;
    titleField.textColor=self.fontColor;

    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.00];
}
-(void)refreshTextView
{
//    if(CGSizeEqualToSize(textContentSize, textView.contentSize))
//        return;
    textContentSize=[textView contentSize];
    //NSLog(@"textContentSize1:%@",NSStringFromCGSize(textContentSize));
    textView.frame=CGRectMake(OUT_BORDER_WIDTH, OUT_BORDER_WIDTH+TITLE_OFFSET_Y+titleField.bounds.size.height, textView.bounds.size.width, MAX(textContentSize.height, height-2*OUT_BORDER_WIDTH-TITLE_OFFSET_Y-titleField.bounds.size.height));
    textView.contentHeight=MAX(textContentSize.height, height-2*OUT_BORDER_WIDTH-titleField.bounds.size.height-TITLE_OFFSET_Y);
    [textView setNeedsDisplay];
    self.contentSize=CGSizeMake(self.contentSize.width,2*OUT_BORDER_WIDTH+TITLE_OFFSET_Y+titleField.bounds.size.height+ textContentSize.height);
    
    [self fitPosition];
    
}
-(BOOL)cursorPositionOver
{
    NSString* s=[textView.text substringWithRange:NSMakeRange(0, textView.selectedRange.location)];
    //NSLog(@"range:%@",NSStringFromRange(textView.selectedRange));
    //NSLog(@"s:%@",s);
    NSDictionary* dict=@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size=[s  boundingRectWithSize:CGSizeMake(906, 1000000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    //NSLog(@"size:%@",NSStringFromCGSize(size));
    
    //NSLog(@"offset:%f",self.contentOffset.y);
    //NSLog(@"delt:%f",size.height-self.contentOffset.y);
    if(size.height-self.contentOffset.y+titleField.bounds.size.height+TITLE_OFFSET_Y+OUT_BORDER_WIDTH>768-deltHeight+fontSize*1.193/2.0)
        return YES;
    
    return NO;
    
}
-(void)fitPosition
{
    //NSLog(@"range:%@",NSStringFromRange(textView.selectedRange));
    //NSLog(@"range1:%@",textView.selectedTextRange);

    if((textContentSize.height>=768-deltHeight-fontSize)&&isEditing&&[self cursorPositionOver])
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.center=CGPointMake(512, 384-deltHeight);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.center=CGPointMake(512, 384);
        }];
    }
}
-(void)refreshTitleView
{
    titleField.frame=CGRectMake(OUT_BORDER_WIDTH, TITLE_OFFSET_Y+OUT_BORDER_WIDTH, width-2*OUT_BORDER_WIDTH, [@"请输入标题!" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize+FONT_SIZE_DELT]}].height);
    [titleField refresh];
}
-(void)refresh
{
    //[titleField refresh];
    [self refreshTitleView];
    [self refreshTextView];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        width=frame.size.width;
        height=frame.size.height;
        //self.contentSize=frame.size;
        self.bounces=NO;
        
        //标题
        titleField=[[TitleFieldView alloc] initWithFrame:CGRectMake(OUT_BORDER_WIDTH, OUT_BORDER_WIDTH+TITLE_OFFSET_Y, width-2*OUT_BORDER_WIDTH, 0)];
        //titleField.font=[UIFont systemFontOfSize:INIT_FONT_SIZE+2];
        //titleField.backgroundColor=[UIColor yellowColor];
        titleField.delegate=self;
        [self addSubview:titleField];
        
        //正文
        textView=[[NoteTextView alloc] initWithFrame:CGRectMake(OUT_BORDER_WIDTH, OUT_BORDER_WIDTH+TITLE_OFFSET_Y, width-2*OUT_BORDER_WIDTH, 0)];
        textView.delegate=self;
        textView.backgroundColor=[UIColor clearColor];
        //textView.layer.borderColor=[UIColor redColor].CGColor;
        //textView.layer.borderWidth=4;
        textView.clipsToBounds=YES;
        [self addSubview:textView];
        
        //标题的下划线的自适应通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:nil];
        //键盘出现通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        //键盘更改通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        //键盘消失通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)keybardWillShow:(NSNotification*)notify
{
   
}
-(void)keybardDidShow:(NSNotification*)notify
{
    CGRect rect2= [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
   // NSLog(@"rect2:%@",NSStringFromCGRect(rect2));
    deltHeight=rect2.size.width;
   //NSLog(@"deltHeight:%f",deltHeight);
    [self fitPosition];
}
-(void)keybardWillHide:(NSNotification*)notify
{
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.center=CGPointMake(512, 384);
    }];
    
}
#pragma mark - titleField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"did begin");
    isTitleResponse=YES;
}
#pragma mark - titleField delegate
-(void)titleFieldTextDidChange
{
    self.title=titleField.text;
    [titleField refresh];
}
#pragma mark - noteText delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isTitleResponse=NO;
    isEditing=YES;
    //[self fitPosition];
}

-(void)textViewDidChange:(UITextView *)aTextView
{
    [self refreshTextView];
}
-(void)textViewDidEndEditing:(UITextView *)aTextView
{
    isEditing=NO;
    [self refreshTextView];
}
-(void)insertText:(NSString*)aString
{
    if(isTitleResponse)
    {
        [titleField insertText:aString];
        [titleField refresh];
    }
    else
        [textView insertText:aString];
}
//保存笔记到本地
-(void)saveNoteWithThumbImage:(UIImage*)img isTempNote:(BOOL)isTmp
{
    if(!isTmp)
    if(titleField.text.length<1)
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入标题!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    self.title=titleField.text;
    
    NoteObject * note=[[NoteObject alloc] init];
    note.title=self.title;
    note.content= textView.text;
    note.date=[NSDate date];
    note.thumbImage=img;
    note.backImage=self.backImage;
    note.fontSize=fontSize;
    note.fontColor=textView.textColor;
    note.aligment=textView.textAlignment;
    note.contentSize=textView.contentSize;
    
    NSString* path= [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.yjb",self.title];
    if(isTmp)
        path=[NSHomeDirectory() stringByAppendingPathComponent:@"tmp/tmpNote.yjb"];
    //NSLog(@"path:%@",path);
    [NSKeyedArchiver archiveRootObject:note toFile:path];
    
    [note release];
    
    if(!isTmp)
    {
        [self clearNote];
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_NOTE_LIST_NOTIFY object:nil];
    }
    
}
-(void)readNoteObj:(NoteObject*)aNoteObj
{
    
    self.title=aNoteObj.title;
    //self.content=aNoteObj.content;
    textView.text=aNoteObj.content;
    self.fontSize=aNoteObj.fontSize;
    self.fontColor=aNoteObj.fontColor;
    self.alignment=aNoteObj.aligment;
    self.backImage=aNoteObj.backImage;
    
    
    
    
    textView.textAlignment=self.alignment;
    textView.fontSize=self.fontSize;
    textView.textColor=self.fontColor;
    
    titleField.text=self.title;
    titleField.fontSize=self.fontSize;
    titleField.textColor=self.fontColor;
    
     [self refreshTitleView];
    
    textContentSize=aNoteObj.contentSize;
    //NSLog(@"textContentSize1:%@",NSStringFromCGSize(textContentSize));
    textView.frame=CGRectMake(OUT_BORDER_WIDTH, OUT_BORDER_WIDTH+TITLE_OFFSET_Y+titleField.bounds.size.height,textView.bounds.size.width, MAX(textContentSize.height, height-2*OUT_BORDER_WIDTH-TITLE_OFFSET_Y-titleField.bounds.size.height));
    textView.contentHeight=MAX(textContentSize.height, height-2*OUT_BORDER_WIDTH-titleField.bounds.size.height-TITLE_OFFSET_Y);
    [textView setNeedsDisplay];
    self.contentSize=CGSizeMake(self.contentSize.width,2*OUT_BORDER_WIDTH+TITLE_OFFSET_Y+titleField.bounds.size.height+ textContentSize.height);
    
   
    //[self applyChange];
}


//清空笔记
-(void)clearNote
{
    titleField.text=@"";
    textView.text=@"";
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.02];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [titleField release];
    [textView release];
    [super dealloc];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)drawRect:(CGRect)rect
{
    [backImage drawInRect:CGRectInset(rect, OUT_BORDER_WIDTH, OUT_BORDER_WIDTH)];
}
@end
