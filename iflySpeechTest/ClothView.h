//
//  ClothView.h
//  ZPO
//
//  Created by 伍 兵 on 13-6-20.
//
//

#import <UIKit/UIKit.h>




@protocol ClothViewDelegate<NSObject>
-(void)addCustomBackImage;
-(void)clothViewClickedButton:(UIButton*)button;
@end
@interface ClothView : UIScrollView
{
    id<ClothViewDelegate> delegate;
}
@property(nonatomic, assign) id<ClothViewDelegate> delegate;
-(void)addImage:(UIImage*)aImg;
@end
