//
//  ClothView.m
//  ZPO
//
//  Created by 伍 兵 on 13-6-20.
//
//
/*
 *文件说明:聊天视图的换肤视图
 *文件作者:薛拥飞
 *创建时间:2013年6月20日
 *创建地点:办公室
 *关联概述:Chat.h
 *修改记录:
 */
#import "ClothView.h"

@interface ClothView()
{
    NSInteger gap;
    NSMutableArray * imageArray;
    NSMutableDictionary * altDict;
    NSInteger width;
    NSInteger height;
}
@end

const int kCountPerLine =4;
@implementation ClothView
@synthesize delegate;
/***************************** 类相关 **********************************/
#pragma mark- 类相关
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor=[UIColor colorWithWhite:1 alpha:0.8];
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
        self.pagingEnabled=YES;
         width=frame.size.width;
         height=frame.size.height;
         gap=20;
       
        [self dataInit];
        [self layoutViews];
        
        
    }
    return self;
}
-(void)dataInit
{
    imageArray=[[NSMutableArray alloc] initWithCapacity:8];
    altDict=[[NSMutableDictionary alloc] init];
    for(int i=1;i<=8;i++)
    {
        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Paper%d.jpg",i]]];
    }
    //读取本地保存的
    NSMutableArray* savedBgArray=[[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] error:nil]];
    //过滤非图片文件
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"SELF like '*.png'"];
    [savedBgArray filterUsingPredicate:predicate];
    //NSLog(@"savedFiltedArray:%@",savedBgArray);
    //排序数组
    [savedBgArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([[[obj1 componentsSeparatedByString:@"."] objectAtIndex:0] integerValue] > [[[obj2 componentsSeparatedByString:@"."] objectAtIndex:0] integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[[obj1 componentsSeparatedByString:@"."] objectAtIndex:0] integerValue] <[[[obj2 componentsSeparatedByString:@"."] objectAtIndex:0] integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    //NSLog(@"savedSortedArray:%@",savedBgArray);
    //添加到数组
    for(NSString* each in savedBgArray)
    {
        UIImage * image=[[UIImage alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingFormat:@"/Library/%@",each]];
        [imageArray insertObject:image atIndex:imageArray.count-1];
        [altDict setObject:image forKey:each];//添加到自定义的数组里
    }
    
    [savedBgArray release];
    
}
-(void)addImage:(UIImage*)aImg
{
    NSInteger index=0;
    NSString* countString=[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBgCount"];
    if(countString)
    {
        index=[countString integerValue];
        index++;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",index] forKey:@"savedBgCount"];
    
    NSString* bgPath=[NSHomeDirectory() stringByAppendingFormat:@"/Library/%d.png",index];
    [imageArray insertObject:aImg atIndex:imageArray.count-1];
    [altDict setObject:aImg forKey:[NSString stringWithFormat:@"%d.png",index]];
    [UIImagePNGRepresentation(aImg) writeToFile:bgPath atomically:YES];
    
    [self layoutViews];
    
}
-(void)layoutViews
{
    for(UIView* btn in self.subviews)
    {
        if([btn isKindOfClass:[UIButton class]])
            [btn  removeFromSuperview];
    }
    
    NSInteger c= imageArray.count/kCountPerLine+ ((imageArray.count%kCountPerLine)?1:0);
    self.contentSize=CGSizeMake(924*c, 186);
    NSInteger eachWidth=(width-gap*(kCountPerLine+1))/kCountPerLine;
    NSInteger eachHeight=eachWidth*0.75;
    for(int i=0;i<imageArray.count;i++)
    {
        UIButton  * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(gap+i*(eachWidth+gap)+gap*(i/kCountPerLine), (height-eachHeight)/2.0, eachWidth, eachHeight);
        [button setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor groupTableViewBackgroundColor];
        button.tag=i+1;
        
        button.layer.shadowColor=[UIColor blackColor].CGColor;
        button.layer.shadowOpacity=1;
        button.layer.shadowRadius=5;
        button.layer.shadowOffset=CGSizeMake(0, 3);
        [self addSubview:button];
        
        if(i>=7&&i!=imageArray.count-1)
        {
            UIButton* delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.frame=CGRectMake(0, 0, 30, 30);
            [delBtn setImage:[UIImage imageNamed:@"delBg.png"] forState:UIControlStateNormal];
            [delBtn setTitle:@"D" forState:UIControlStateNormal];
            [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:delBtn];
        }
        
        
    }
}
-(void)delBtnClicked:(UIButton*)aDelBtn
{
    UIButton * b=(UIButton*)[aDelBtn superview];
    [imageArray removeObject:b.imageView.image];
    [self layoutViews];
    
    
    NSString* willDelImg=[[altDict allKeysForObject:b.imageView.image] objectAtIndex:0];
    
    [altDict removeObjectForKey:willDelImg];
    
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Library/%@",willDelImg] error:nil];
    
}
-(void)dealloc
{
    [altDict release];
    [imageArray release];
    [super dealloc];
}
/***************************** 事件函数 **********************************/
#pragma mark- 事件函数
/* 选择某个图片 */
-(void)imageButtonClicked:(UIButton*)button
{
    if(button.tag==imageArray.count)
    {
        [delegate addCustomBackImage];
    }
    else
        [delegate clothViewClickedButton:button];
}
@end
