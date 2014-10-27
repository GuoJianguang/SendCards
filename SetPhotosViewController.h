//
//  SetPhotosViewController.h
//  SendCards
//
//  Created by rimi on 14-2-13.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditViewController;

@interface SetPhotosViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>


@property (nonatomic,assign) NSInteger imageName;
@property (nonatomic,retain) UIImageView *outPage;//封面外页

@property (nonatomic,retain) UIImageView *myImage;

@property (nonatomic,retain) EditViewController *delegate;//传真





@end
