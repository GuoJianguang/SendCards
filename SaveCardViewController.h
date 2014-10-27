//
//  SaveCardViewController.h
//  SendCards
//
//  Created by rimi on 14-2-11.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveCardViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,retain) UITableView *aTableView;
//用来存储数据源的数组
@property (nonatomic,retain) NSMutableArray *getArray;
//加于cell之上，用来放置编辑和删除按钮的view（注意设置其隐藏属性）
@property (nonatomic,retain) UIView *editView;


- (NSMutableArray *)readCoreData;

@end
