//
//  TopToolView.m
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-14.
//  Copyright (c) 2014年 伍 兵. All rights reserved.
//

#import "TopToolView.h"
@interface TopToolView()
{
    NSArray* textAlignmentArray;
    NSMutableArray* fontSizeArray;
    NSMutableArray* fontColorArray;
    IBOutlet UIPickerView* textAlignmentPicker;
    IBOutlet UIButton* defaultBtn;
    IBOutlet UIButton* saveBtn;
    IBOutlet UILabel* timeOutLabel;
}
@end
@implementation TopToolView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        textAlignmentArray=[[NSArray alloc] initWithObjects:@"左对齐",@"居中",@"右对齐", nil];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
       
        textAlignmentArray=[[NSArray alloc] initWithObjects:@"左对齐",@"居中",@"右对齐", nil];
        fontSizeArray=[[NSMutableArray alloc] initWithCapacity:0];
        fontColorArray=[[NSMutableArray alloc] initWithCapacity:0];
        for(int i=20;i<80;i++)
        {
            [fontSizeArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [fontColorArray addObject:[UIColor redColor]];
        [fontColorArray addObject:[UIColor blueColor]];
        [fontColorArray addObject:[UIColor yellowColor]];
        [fontColorArray addObject:[UIColor whiteColor]];
        [fontColorArray addObject:[UIColor blackColor]];
        [fontColorArray addObject:[UIColor cyanColor]];
        [fontColorArray addObject:[UIColor grayColor]];
        [fontColorArray addObject:[UIColor orangeColor]];
        [fontColorArray addObject:[UIColor greenColor]];
        [fontColorArray addObject:[UIColor purpleColor]];

        
        
    }
    return self;
}
-(void)awakeFromNib
{
     NSString* speekTimeout=[[NSUserDefaults standardUserDefaults] objectForKey:SPEEK_TIMEOUT];
    //NSLog(@"speekTimeOut:%@",speekTimeout);
    NSString* isAutoPunc=[[NSUserDefaults standardUserDefaults] objectForKey:AUTO_FIT_PUNCTUATION];
    puncSwitch.on=[isAutoPunc isEqualToString:@"1"];
    timeOutLabel.text=speekTimeout;
    NSUserDefaults * user=[NSUserDefaults standardUserDefaults];
    NSInteger alignIndex=[[user valueForKey:TEXT_ALIGNMENT_INDEX] intValue];
    NSInteger sizeIndex=[[user valueForKey:TEXT_SIZE_INDEX] intValue];
    NSInteger colorIndex=[[user valueForKey:TEXT_COLOR_INDEX] intValue];
    [textAlignmentPicker selectRow:alignIndex inComponent:0 animated:NO];
    [textAlignmentPicker selectRow:sizeIndex inComponent:1 animated:NO];
    [textAlignmentPicker selectRow:colorIndex inComponent:2 animated:NO];

    
}
-(void)resumeDefault
{
    puncSwitch.on=YES;
    stepper.value=3;timeOutLabel.text=@"3";
    [textAlignmentPicker selectRow:0 inComponent:0 animated:YES];
    [textAlignmentPicker selectRow:10 inComponent:1 animated:YES];
    [textAlignmentPicker selectRow:4 inComponent:2 animated:YES];
    
}
-(IBAction)stepper:(UIStepper*)sender
{
    timeOutLabel.text=[NSString stringWithFormat:@"%d",(int)sender.value];
    [[NSUserDefaults standardUserDefaults] setObject:timeOutLabel.text forKey:SPEEK_TIMEOUT];
}
-(IBAction)puncSwitch:(UISwitch*)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",sender.on] forKey:AUTO_FIT_PUNCTUATION];
    
}
-(IBAction)btnClicked:(UIButton*)sender
{
    if(sender.tag==2)
    {
        NSInteger alignIndex=[textAlignmentPicker selectedRowInComponent:0];
        NSInteger sizeIndex=[textAlignmentPicker selectedRowInComponent:1];
        NSInteger colorIndex=[textAlignmentPicker selectedRowInComponent:2];
        [[NSUserDefaults standardUserDefaults] setObject:[textAlignmentArray objectAtIndex:alignIndex] forKey:TEXT_ALIGNMENT];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:alignIndex] forKey:TEXT_ALIGNMENT_INDEX];
        
        [[NSUserDefaults standardUserDefaults] setObject:[fontSizeArray objectAtIndex:sizeIndex] forKey:TEXT_SIZE];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:sizeIndex] forKey:TEXT_SIZE_INDEX];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[fontColorArray objectAtIndex:colorIndex] colorString] forKey:TEXT_COLOR];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:colorIndex] forKey:TEXT_COLOR_INDEX];
        
        
    }
    if([delegate respondsToSelector:@selector(topToolViewButtonClicked:)])
        [delegate topToolViewButtonClicked:sender];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return textAlignmentArray.count;
    }
    else if(component==1)
    {
        return fontSizeArray.count;
    }
    else
    {
        return  fontColorArray.count;
    }
        
    return textAlignmentArray.count;
}
/*
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0)
    {
       return  [textAlignmentArray objectAtIndex:row];
    }
    else if(component==1)
    {
        return [fontSizeArray objectAtIndex:row];
    }
   return nil;
}
 */
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* aLabel;
    if(!view)
    {
        aLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)] autorelease];
    }
    else
        aLabel=(UILabel*)view;
    aLabel.backgroundColor=[UIColor clearColor];
    if(component==0)
    {
        aLabel.text=[textAlignmentArray objectAtIndex:row];
        
    }
    else if(component==1)
    {
        aLabel.text=[fontSizeArray objectAtIndex:row];
    }
    else
    {
        aLabel.backgroundColor=[fontColorArray objectAtIndex:row];
    }
    return aLabel;
}

-(void)dealloc
{
    [fontColorArray release];
    [fontSizeArray release];
    [textAlignmentArray release];
    [super dealloc];
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
