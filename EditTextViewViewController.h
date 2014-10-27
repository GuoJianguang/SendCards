//
//  EditTextViewViewController.h
//  SendCards
//
//  Created by rimi on 14-2-11.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditViewController;

@interface EditTextViewViewController : UIViewController
@property (nonatomic,assign)EditViewController *delegate;
@property (nonatomic,retain)UITextView *editTextView;


@end
