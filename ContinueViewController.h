//
//  ContinueViewController.h
//  SendCards
//
//  Created by rimi on 14-2-12.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "EditViewController.h"
@class SaveCardViewController;

@interface ContinueViewController : EditViewController
@property (nonatomic,retain) NSString *str;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) SaveCardViewController *saveCardVC;


@end
