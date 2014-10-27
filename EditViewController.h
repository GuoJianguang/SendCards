//
//  EditViewController.h
//  SendCards
//
//  Created by rimi on 14-2-10.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface EditViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,assign) NSInteger imageName;

@property (nonatomic,retain) UILabel *textLabel;//显示问候语的label
@property (nonatomic,retain) UIButton *outPageBtn;//显示外页的按钮
@property (nonatomic,retain) UIButton *pageTurnBtn;//显示内页的按钮
@property (nonatomic,retain) UIImageView *outPage;//封面外页

@end
