//
//  LoverViewController.m
//  SendCards
//
//  Created by rimi on 14-1-17.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "LoverViewController.h"
#import "Header.h"
#import "ScrollView.h"
#import "EditViewController.h"
#import "SaveCardViewController.h"

@interface LoverViewController ()
{
    NSMutableArray *allImageArray;//存放所有图片的数组
    NSInteger sendTemp;
}

@end

@implementation LoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"情侣"];
        self.tabBarItem.title = @"情侣贺卡";
        self.navigationItem.title = @"情侣";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"背景"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode: UIImageResizingModeTile]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"导航条"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.backgroundColor = [UIColor brownColor];
    
    if (IOS7) {
        //设置ScrollView自适应
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    //添加界面的scrollView
    ScrollView *rootSV = [[ScrollView alloc]initWithFrame:self.view.frame width:8];
    rootSV.delegate = self;
    [self.view addSubview:rootSV];
    
    //已经存储的贺卡
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"已经存储的贺卡" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtn:)];
    saveBtn.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = saveBtn;
    
    //退出程序按钮
    UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStyleBordered target:self action:@selector(exitBtn)];
    exitBtn.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = exitBtn;

    
    allImageArray = [[NSMutableArray alloc]init];
    for (int i = 6; i < 14; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [allImageArray addObject:str];
    }
    
    for (int i = 6; i < 14; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0 + (i-6)*(rootSV.frame.size.width), 5, rootSV.frame.size.width-20, rootSV.frame.size.height);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [rootSV addSubview:imageView];
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:click];
        imageView.userInteractionEnabled = YES;
    }
    
    sendTemp = 0 + 6;
}


//推送到编辑界面
- (void)click:(UIImageView *)_sender
{
    EditViewController *editVC = [[EditViewController alloc]init];
    editVC.imageName = sendTemp;
    UINavigationController *naC = [[UINavigationController alloc]initWithRootViewController:editVC];
    [self presentViewController:naC animated:NO completion:^
     {
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.5];
         naC.view.frame = CGRectMake(WIDTH/2, HEIGHT/2, 0, 0);
         naC.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         [UIView commitAnimations];
     }];
}



//存储按钮点击事件
- (void)saveBtn:(UIBarButtonItem *)_sender
{
    SaveCardViewController *saveCardC =[[SaveCardViewController alloc]init];
    UINavigationController *naC = [[UINavigationController alloc]initWithRootViewController:saveCardC];
    [self presentViewController:naC animated:YES completion:^{}];
}

//退出按钮点击事件
- (void)exitBtn
{
    exit(0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    sendTemp = (NSInteger)scrollView.contentOffset.x/320 + 6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

