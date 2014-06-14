//
//  ViewController.h
//  SpeechNote
//
//  Created by 伍 兵 on 14-5-19.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"

#import "NavigationView.h"
#import "NoteView.h"
#import "LeftToolView.h"
#import "RightToolView.h"
#import "ClothView.h"
#import "TopToolView.h"

#define APP_ID @"52821af6"
#define TIMEOUT @"20000"  //联网超时时间
#define MY_DOMAIN @"iat"

#define SPEECH_TIMEOUT @"vad_eos"
#define SPEECH_TIMEOUT_2 @"eos"


@interface ViewController : UIViewController<IFlySpeechRecognizerDelegate,RightToolViewDelegate,UIScrollViewDelegate,LeftToolViewDelegate,UITableViewDataSource,UITableViewDelegate,ClothViewDelegate,TopToolViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate>
{
    NSInteger screenWidth;
    NSInteger screenHeight;
}
-(void)saveTempNote;
-(void)showNavigationWithImage:(NSString*)imgName;
@end
