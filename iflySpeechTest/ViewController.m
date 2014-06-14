//
//  ViewController.m
//  SpeechNote
//
//  Created by 伍 兵 on 13-11-27.
//  Copyright (c) 2013年 伍 兵. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IFlySpeechRecognizer* recognizer;//语音识别speech to text
    
    
    IBOutlet TopToolView * topToolView;
    ClothView* clothView;
    IBOutlet RightToolView * rightToolView;
    IBOutlet LeftToolView * leftToolView;
    
    UIView* containerView;
    NoteView * noteView;
    UITableView* tableView;
    NSMutableArray* noteArray;
    
    UIPopoverController * pop;
}
@end




@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
   // NSLog(@"will appear");
    
    
}
-(void)setLocalUserInfo
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    [user setObject:@"1" forKey:AUTO_FIT_PUNCTUATION];
    [user setObject:@"3" forKey:SPEEK_TIMEOUT];
    [user setObject:@"左对齐" forKey:TEXT_ALIGNMENT];
    [user setValue:[NSNumber numberWithInt:0] forKeyPath:TEXT_ALIGNMENT_INDEX];
    [user setObject:@"30" forKey:TEXT_SIZE];
    [user setValue:[NSNumber numberWithInt:10] forKeyPath:TEXT_SIZE_INDEX];
    [user setObject:@"0,0,0,1" forKey:TEXT_COLOR];
    [user setValue:[NSNumber numberWithInt:4] forKeyPath:TEXT_COLOR_INDEX];
    [user synchronize];
}
-(void)firstConfig
{
    //初始设置
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    if(![user objectForKey:AUTO_FIT_PUNCTUATION])
    {
        [self setLocalUserInfo];
    }
}
-(void)saveNotesToSandBox
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"exportNote"])
        return;
    [[NSUserDefaults standardUserDefaults] setObject:@"exported" forKey:@"exportNote"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray* notes=@[@"心情",@"梦想启航",@"行路难",@"青春漫语"];
    for(NSString* each in notes)
    {
        NSString* tmpPath=[[NSBundle mainBundle] pathForResource:each ofType:@""];
        NSData* noteData=[[NSData alloc] initWithContentsOfFile:tmpPath];
        [noteData writeToFile:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.yjb",each] atomically:YES];
        [noteData release];
        
    }
}
-(void)awakeFromNib
{
     NSLog(@"homePath:%@",NSHomeDirectory());
    [self saveNotesToSandBox];
     [self noteArrayInit];
    [self firstConfig];
}
//识别器的默认设置
-(void)defautConfigRecognizer
{
    //设置生效
    [recognizer setParameter:@"3000" forKey:SPEECH_TIMEOUT];//语音超时
     [recognizer setParameter:@"3000" forKey:SPEECH_TIMEOUT_2];//语音超时
    [recognizer setParameter:@"1" forKey:@"asr_ptt"];//是否有标点
    
    [topToolView resumeDefault];
    [noteView setAlignment:NSTextAlignmentLeft];
    [noteView setFontColor:[UIColor blackColor]];
    [noteView setFontSize:30];
    
    [self setLocalUserInfo];
    
}
-(void)configRecognizer
{
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    [user synchronize];
    NSString* tmpTimeout=[user objectForKey:SPEEK_TIMEOUT];
    NSString* tmpAutoFitPunctuation=[user objectForKey:AUTO_FIT_PUNCTUATION];
    NSString* alignment=[user objectForKey:TEXT_ALIGNMENT];
    NSString* textSize=[user objectForKey:TEXT_SIZE];
    NSString* textColor=[user objectForKey:TEXT_COLOR];
    NSLog(@"timeout:%@,isAutoFit:%@,alignment:%@,size:%@,color:%@",tmpTimeout,tmpAutoFitPunctuation,alignment,textSize,textColor);
    
    
    [recognizer setParameter:[tmpTimeout stringByAppendingString:@"000"] forKey:SPEECH_TIMEOUT];//语音超时
    [recognizer setParameter:[tmpTimeout stringByAppendingString:@"000"] forKey:SPEECH_TIMEOUT_2];//语音超时
    [recognizer setParameter:tmpAutoFitPunctuation forKey:@"asr_ptt"];//是否有标点
    if([alignment isEqualToString:@"左对齐"])
        noteView.alignment=NSTextAlignmentLeft;
    else if([alignment isEqualToString:@"居中"])
        noteView.alignment=NSTextAlignmentCenter;
    else
        noteView.alignment=NSTextAlignmentRight;
    //NSLog(@"textSize:%d",[textSize intValue]);
    noteView.fontSize=[textSize intValue];
    noteView.fontColor=[textColor stringColor];
    [noteView applyChange];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    //识别器
	NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APP_ID,TIMEOUT];
    [IFlySpeechUtility createUtility:initString];
    
    recognizer = [IFlySpeechRecognizer sharedInstance];
    recognizer.delegate = self;//请不要删除这句,createRecognizer是单例方法，需要重新设置代理
    [recognizer setParameter:MY_DOMAIN forKey:[IFlySpeechConstant  IFLY_DOMAIN]];//域设置
    [recognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];//采样率
    [recognizer setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //[recognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];//语言设置
    [recognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];//返回值类型
    
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    NSString* tmpTimeout=[user objectForKey:SPEEK_TIMEOUT];
    NSString* tmpAutoFitPunctuation=[user objectForKey:AUTO_FIT_PUNCTUATION];
    [recognizer setParameter:[tmpTimeout stringByAppendingString:@"000"] forKey:SPEECH_TIMEOUT];//语音超时
    [recognizer setParameter:[tmpTimeout stringByAppendingString:@"000"] forKey:SPEECH_TIMEOUT_2];//语音超时
    [recognizer setParameter:tmpAutoFitPunctuation forKey:@"asr_ptt"];//是否有标点
    
    [initString release];
    
    //如果没有草稿，则创建空草稿文件
    NSString* tmpNotePath=[NSHomeDirectory() stringByAppendingPathComponent:@"tmp/tmpNote.yjb"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:tmpNotePath])
    {
        NoteObject * note=[[NoteObject alloc] init];
        note.title=@"";
        note.content= @"";
        note.date=[NSDate date];
        //note.thumbImage=[UIImage imageNamed:@"paper3.jpg"];
        note.backImage=[UIImage imageNamed:@"Paper1.jpg"];
        note.fontSize=30;
        note.fontColor=[UIColor blackColor];
        note.aligment=NSTextAlignmentLeft;
        note.contentSize=CGSizeMake(924, 0);
        [NSKeyedArchiver archiveRootObject:note toFile:tmpNotePath];
        [note release];
    }
     NoteObject * note=[NSKeyedUnarchiver unarchiveObjectWithFile:tmpNotePath];
     [noteView readNoteObj:note];
}
-(void)noteArrayInit
{
    NSError* error=nil;
    NSString* notePath=[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    noteArray=[[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:notePath error:&error]];
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF like '*.yjb'"];
    //NSLog(@"noteArray:%@",noteArray);
    [noteArray filterUsingPredicate:predicate];
    
//    if([noteArray containsObject:@".DS_Store"])
//        [noteArray removeObject:@".DS_Store"];
//    if([noteArray containsObject:@"events.dat"])
//        [noteArray removeObject:@"events.dat"];
//    if([noteArray containsObject:@"msc_p.log"])
//        [noteArray removeObject:@"msc_p.log"];
    
    [noteArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NoteObject*  o1=[NSKeyedUnarchiver unarchiveObjectWithFile:[notePath stringByAppendingFormat:@"/%@",obj1]];
        NoteObject*  o2=[NSKeyedUnarchiver unarchiveObjectWithFile:[notePath stringByAppendingFormat:@"/%@",obj2]];
        return  -1*[o1.date compare:o2.date];
    }];
     //NSLog(@"noteArray:%@",noteArray);
}
- (void)viewDidLoad
{
   
    
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"deskBg.jpg"]];
    //self.view.backgroundColor=[UIColor darkGrayColor];
    CGSize size=[[UIScreen mainScreen] bounds].size;
    screenWidth=MAX(size.width, size.height);
    screenHeight=MIN(size.width, size.height);
    //NSLog(@"width:%d,height:%d",screenWidth,screenHeight);
    
    CGRect rect=CGRectMake(50,0, 924, 768);
    containerView=[[UIView alloc] initWithFrame:rect];
    containerView.layer.shadowColor=[UIColor blackColor].CGColor;
    containerView.layer.shadowOpacity=1;
    containerView.layer.shadowRadius=10;
    containerView.layer.shadowOffset=CGSizeMake(0, 0);
    
    [self.view addSubview:containerView];
    
    
    
    
    //文本视图
    noteView=[[NoteView alloc] initWithFrame:containerView.bounds];
    //noteView.fontSize=30;
    noteView.delegate=self;
    //[noteView setBackImage:[UIImage imageNamed:@"paper4.jpg"]];
    noteView.backgroundColor=[UIColor whiteColor];
    [containerView addSubview:noteView];
    
    //左工具条
    //leftToolView=[[LeftToolView alloc] initWithFrame:CGRectMake(0, 0, 50, 768)];
    leftToolView.delegate=self;
    //[self.view addSubview:leftToolView];
    
    //右工具条
    //rightToolView=[[RightToolView alloc] initWithFrame:CGRectMake(screenWidth-50, 20, 50, screenHeight)];
    rightToolView.delagete=self;
    //[self.view addSubview:rightToolView];
    
    
    //上面的设置视图
    //topToolView=[[TopToolView alloc] initWithFrame:CGRectMake(50, -150, rect.size.width, 150)];
    topToolView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //[self.view addSubview:topToolView];
    
    
    //下面的paper视图
    clothView=[[ClothView alloc] initWithFrame:CGRectMake(50, screenHeight, screenWidth-100, 186)];
    clothView.delegate=self;
    [self.view addSubview:clothView];
    [self.view  sendSubviewToBack:clothView];
    
    //头渐变条
    CAGradientLayer* headerLayer=[CAGradientLayer layer];
    headerLayer.backgroundColor=[UIColor clearColor].CGColor;
    headerLayer.frame=CGRectMake(0, 0, 924, 16);
    headerLayer.colors=@[(id)[UIColor whiteColor].CGColor,(id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    headerLayer.locations=@[[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1]];
    headerLayer.startPoint=CGPointMake(0.5, 0);
    headerLayer.endPoint=CGPointMake(0.5, 1);
    [containerView.layer addSublayer:headerLayer];
    
    //底渐变条
    CAGradientLayer* footerLayer=[CAGradientLayer layer];
    footerLayer.backgroundColor=[UIColor clearColor].CGColor;
    footerLayer.frame=CGRectMake(0,rect.size.height-16, 924, 16);
    footerLayer.colors=@[(id)[UIColor whiteColor].CGColor,(id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    footerLayer.locations=@[[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1]];
    footerLayer.startPoint=CGPointMake(0.5, 1);
    footerLayer.endPoint=CGPointMake(0.5, 0);
    [containerView.layer addSublayer:footerLayer];
    
    UIImageView* noteListBack=[[UIImageView alloc] initWithFrame:containerView.bounds];
    noteListBack.image=[UIImage imageNamed:@"NoteListBg.png"];
    noteListBack.backgroundColor=[UIColor whiteColor];
    //笔记列表
    tableView=[[UITableView alloc] initWithFrame:containerView.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor lightGrayColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.hidden=YES;
    tableView.backgroundView=noteListBack;
    [containerView addSubview:tableView];
    
    UISwipeGestureRecognizer*  rightSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(editNote:)];
    rightSwipe.direction=UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:rightSwipe];
    [rightSwipe release];
    
    UISwipeGestureRecognizer*  leftSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEditNote:)];
    leftSwipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [tableView addGestureRecognizer:leftSwipe];
    [leftSwipe release];
    
    [self.view bringSubviewToFront:containerView];
    //更新笔记列表通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNoteList) name:UPDATE_NOTE_LIST_NOTIFY object:nil];
    //保存草稿的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTempNote) name:SAVE_TEMP_NOTE_NOTIFY object:nil];
    
    //note导航
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"naviNote"])
    {
        [self showNavigationWithImage:@"nav_note.png"];
        [[NSUserDefaults standardUserDefaults] setObject:@"showed" forKey:@"naviNote"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
#pragma  mark - 手势
-(void)editNote:(UISwipeGestureRecognizer*)swipeGuesture
{
    if(swipeGuesture.state==UIGestureRecognizerStateEnded)
    {
        [tableView setEditing:YES animated:YES];
    }
}
-(void)cancelEditNote:(UISwipeGestureRecognizer*)swipeGuesture
{
    if(swipeGuesture.state==UIGestureRecognizerStateEnded)
    {
        [tableView setEditing:NO animated:YES];
    }
}

#pragma mark - tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return noteArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return THUMB_IMAGE_RECT.size.height+20;
}
-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[aTableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell==nil)
    {
        cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"]autorelease];
    }
    NSString* noteTitle=[noteArray objectAtIndex:indexPath.row];
    NSString* notePath= [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",noteTitle];
    NoteObject* noteObj=[NSKeyedUnarchiver unarchiveObjectWithFile:notePath];
    cell.textLabel.text=noteTitle;
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString* dateString=[formatter stringFromDate:noteObj.date];
    [formatter release];
    cell.detailTextLabel.text=dateString;
    cell.imageView.image=noteObj.thumbImage;
    //cell.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    //cell.imageView.layer.borderWidth=2;
    //cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    cell.backgroundColor=[UIColor colorWithWhite:0.93 alpha:0.75];
    return cell;
}
-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* noteTitle=[noteArray objectAtIndex:indexPath.row];
    NSString* notePath= [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",noteTitle];
    NoteObject* noteObj=[NSKeyedUnarchiver unarchiveObjectWithFile:notePath];
    [noteView readNoteObj:noteObj];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [leftToolView changeButtonImage:[UIImage imageNamed:@"list_white.png"] forButtonTag:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
    noteView.hidden=NO;
    aTableView.hidden=YES;
    [UIView commitAnimations];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma  mark - edit
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",[noteArray objectAtIndex:indexPath.row]] error:nil];
        [noteArray removeObjectAtIndex:indexPath.row];
        [aTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView* aView=[[UIView alloc] initWithFrame:noteView.frame];
    [self.view addSubview:aView];
    aView.backgroundColor=[UIColor yellowColor];
}
#pragma mark - toolBar delegate
-(void)topToolViewButtonClicked:(UIButton *)aBtn
{
    if(aBtn.tag==1)
    {
        [self defautConfigRecognizer];//恢复默认设置
    }
    else
    {
        [self configRecognizer];//设置识别器
    }
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
     [pop release];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    noteView.backImage=image;
    [clothView addImage:noteView.backImage];
    [pop dismissPopoverAnimated:YES];
    [pop release];
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"dismissed");
//    }];
}
-(void)addCustomBackImage
{
    UIImagePickerController* picker= [[UIImagePickerController alloc] init];
    //picker.preferredContentSize=CGSizeMake(400, 500);
    picker.view.backgroundColor=[UIColor whiteColor];
    picker.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    //iphone
#if 0
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
#else
    //ipad
    pop = [[UIPopoverController alloc] initWithContentViewController:picker];
     //[pop setPopoverContentSize:CGSizeMake(400, 500)];
    [pop presentPopoverFromRect:CGRectMake(512, 580, 5, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];//rect 设置箭头的位置,
    //[pop presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    pop.delegate=self;
#endif
    [picker release];
}
-(void)clothViewClickedButton:(UIButton *)button
{
    noteView.backImage=button.imageView.image;
}
-(void)leftToolViewClickedButton:(UIButton *)button
{
    //NSLog(@"left.tag:%d",button.tag);
    if(button.tag==1)
    {
        UIImage* listImage=[UIImage imageNamed:@"list_white.png"];
        UIImage* readImage=[UIImage imageNamed:@"read_white.png"];
        
        [UIView animateWithDuration:1.0 animations:^{
            if([button.imageView.image isEqual:listImage])
            {
                [button setImage:readImage forState:UIControlStateNormal];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];
                noteView.hidden=YES;
                tableView.hidden=NO;
            }
            else
            {
                [button setImage:listImage forState:UIControlStateNormal];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];
                noteView.hidden=NO;
                tableView.hidden=YES;
                
            }
        } completion:^(BOOL finished) {
            //paper导航
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"naviList"])
            {
                [self showNavigationWithImage:@"nav_list.png"];
                [[NSUserDefaults standardUserDefaults] setObject:@"showed" forKey:@"naviList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
    }
    
    else if(button.tag==2)
    {
        NSInteger topToolHeight= topToolView.frame.origin.y==0?-150:0;
        NSInteger bottomToolHeight=(clothView.frame.origin.y<(screenHeight))?screenHeight:screenHeight-186;
        NSInteger containerHeight;
        if(containerView.center.y<screenHeight/2)
        {
            topToolHeight=0;
            containerHeight=screenHeight/2+150-(screenHeight-containerView.bounds.size.height)/2;
            bottomToolHeight=screenHeight;
        }
        else if(containerView.center.y==screenHeight/2)
        {
            topToolHeight=0;
            containerHeight=screenHeight/2+150-(screenHeight-containerView.bounds.size.height)/2;
            bottomToolHeight=screenHeight;
        }
        else
        {
            topToolHeight=-150;
            containerHeight=screenHeight/2.0;
            bottomToolHeight=screenHeight;
        }
        [UIView animateWithDuration:0.3 animations:^{
            containerView.center=CGPointMake(screenWidth/2,containerHeight);
            topToolView.frame= CGRectMake(50,topToolHeight , screenWidth-100, 150);
            clothView.frame=CGRectMake(50, bottomToolHeight, screenWidth-100, 186);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(button.tag==3)
    {
       
        
        NSInteger topToolHeight= topToolView.frame.origin.y==0?-150:0;
        NSInteger bottomToolHeight=(clothView.frame.origin.y<(screenHeight))?screenHeight:screenHeight-186;
        NSInteger containerHeight;
        if(containerView.center.y<screenHeight/2)
        {
            topToolHeight=-150;
            containerHeight=screenHeight/2;
            bottomToolHeight=screenHeight;
        }
        else if(containerView.center.y==screenHeight/2)
        {
            topToolHeight=-150;
            containerHeight=screenHeight/2-186+(screenHeight-containerView.bounds.size.height)/2;
            bottomToolHeight=screenHeight-186;
        }
        else
        {
            topToolHeight=-150;
            containerHeight=screenHeight/2-186+(screenHeight-containerView.bounds.size.height)/2;
            bottomToolHeight=screenHeight-186;
        }
        [UIView animateWithDuration:0.3 animations:^{
            containerView.center=CGPointMake(screenWidth/2,containerHeight);
            clothView.frame= CGRectMake(50,bottomToolHeight , screenWidth-100, 186);
            topToolView.frame=CGRectMake(50, topToolHeight, screenWidth-100, 150);
        } completion:^(BOOL finished) {
            //list导航
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"naviPaper"])
            {
                [self showNavigationWithImage:@"nav_paper.png"];
                [[NSUserDefaults standardUserDefaults] setObject:@"showed" forKey:@"naviPaper"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
       
        
    }
}
-(UIImage*)getThumbImage
{
    UIImage* image;
    UIGraphicsBeginImageContext(containerView.bounds.size);
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext( THUMB_IMAGE_RECT.size);
    [image drawInRect:THUMB_IMAGE_RECT];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)rightToolViewClickedButton:(UIButton *)button
{
   // NSLog(@"right.tag:%d",button.tag);
    if(button.tag==1)
    {
        [recognizer startListening];//开始录音
    }
    else if(button.tag==2)
    {
        [noteView saveNoteWithThumbImage:[self getThumbImage] isTempNote:NO];
    }
    else if(button.tag==3)
    {
        [noteView clearNote];
    }
}
-(void)saveTempNote
{
    [noteView saveNoteWithThumbImage:[self getThumbImage] isTempNote:YES];
}

#pragma mark - 识别 delegate
- (void) onVolumeChanged: (int)volume
{
    //NSLog(@"volume:%d",volume);
    [rightToolView setRecordButtonValue:volume];
    
}
- (void) onBeginOfSpeech
{
    NSLog(@"begin");
}
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSLog(@"result:%@",results);
    NSString* result= [[[results objectAtIndex:0] allKeys] objectAtIndex:0];
    if(result)
        [noteView insertText:result];
}
- (void) onEndOfSpeech
{
    NSLog(@"end of speech");
    [rightToolView enableRecordButton];
}
- (void) onCancel
{
    //NSLog(@"cancle");
}
- (void) onError:(IFlySpeechError *) errorCode
{
    //NSLog(@"error:%@",[errorCode errorDesc]);
    [rightToolView enableRecordButton];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation==UIInterfaceOrientationLandscapeRight;
}

#pragma mark - notificaton
-(void)updateNoteList
{
    [self noteArrayInit];
    [tableView reloadData];
}
-(void)showNavigationWithImage:(NSString*)imgName
{
    NavigationView* navigation=[[NavigationView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    navigation.image=[UIImage imageNamed:imgName];
    [self.view addSubview:navigation];
    [self.view bringSubviewToFront:navigation];
    [navigation release];
}
-(void)dealloc
{
    [noteArray release];
    [containerView release];
    [topToolView release];
    [clothView release];
    [leftToolView release];
    [rightToolView release];
    [noteView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
