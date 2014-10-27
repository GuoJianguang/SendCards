//
//  EditViewController.m
//  SendCards
//
//  Created by rimi on 14-2-10.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "EditViewController.h"
#import "AppDelegate.h"
#import "Header.h"
#import "EditTextViewViewController.h"
#import "SetPhotosViewController.h"
#import "AddressBookViewController.h"
#import "SinaViewController.h"
#import "DetailCardInfo.h"



@interface EditViewController ()
{
//    UIImageView *outPage;//封面外页
    CGPoint point;
    UIImageView *inPage;//内页
    
    UIActionSheet *returnSheet;
    UIActionSheet *sendSheet;
    
}

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //大背景图片
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.frame = CGRectMake(0, 0,HEIGHT , WIDTH);
    backImageView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:backImageView];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"导航条"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    
    [self buttonSet];
    [self pageSet];
   }

#pragma mark - 各种button以及其点击事件
- (void)buttonSet
{
    //返回按钮
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBtn:)];
    returnBtn.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = returnBtn;
    
    //购买按钮
    UIBarButtonItem *buyBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(send)];
    buyBtn.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = buyBtn;

    //内页和外页的按钮
    _pageTurnBtn  = [[UIButton alloc]initWithFrame:CGRectMake(180, 5, 50, 22)];
    _pageTurnBtn.layer.cornerRadius = 3;
    [_pageTurnBtn setTitle:@"内页" forState:UIControlStateNormal];
    _pageTurnBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    _pageTurnBtn.layer.borderWidth = 1;
    _pageTurnBtn.backgroundColor = [UIColor brownColor];
    [self.navigationController.navigationBar addSubview:_pageTurnBtn];
    [_pageTurnBtn addTarget:self action:@selector(turnPageIn) forControlEvents:UIControlEventTouchUpInside];
    
    _outPageBtn = [[ UIButton alloc]initWithFrame:CGRectMake(231, 5, 50, 22)];
    _outPageBtn.layer.cornerRadius = 3;
    [_outPageBtn setTitle:@"外页" forState:UIControlStateNormal];
    _outPageBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    _outPageBtn.layer.borderWidth = 1;
    _outPageBtn.backgroundColor = [UIColor brownColor];
    [self.navigationController.navigationBar addSubview:_outPageBtn];
    [_outPageBtn addTarget:self action:@selector(turnPageOut:) forControlEvents:UIControlEventTouchUpInside];
}

//发送按钮点击时间
- (void)send
{
   sendSheet = [[UIActionSheet alloc] initWithTitle:@"选择发送方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"分享到微博" otherButtonTitles:@"取消发送", nil];
    [sendSheet showInView:self.view];
}
//选择发送方式；
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (actionSheet == sendSheet) {
    switch (buttonIndex) {
        case 1:
        {
            SinaViewController *sinaVC = [[SinaViewController alloc]init];
            sinaVC.myImage = self.outPage.image;
            [self.navigationController pushViewController:sinaVC animated:NO];
        }
            break;
        default:
            break;
    }
    }else if (actionSheet == returnSheet){
        switch (buttonIndex) {
            case 0://存储
            {
                //像coreData存入数据
                NSData *imageData = UIImagePNGRepresentation(self.outPage.image);
                [self saveCoreData:self.imageName lebelText:self.textLabel.text AndImageData:imageData];
//                //把图片写入到相册。
//                UIImageWriteToSavedPhotosAlbum(self.outPage.image, nil, nil, nil);
                
            }
                [self dismissViewControllerAnimated:YES completion:^{}];
                break;
            case 1://不存储
                [self dismissViewControllerAnimated:YES completion:^{}];
                
                break;
            case 2://取消
                [[self.navigationController.view viewWithTag:1] removeFromSuperview];
                [[self.navigationController.view viewWithTag:2] removeFromSuperview];
                [[self.navigationController.view viewWithTag:3] removeFromSuperview];
                break;
            default:
                break;
        }
    }
}
//发送邮箱失败
- (void)mailComposeController: (MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"发送失败!");
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//返回按钮的点击事件
- (void)returnBtn:(UIBarButtonItem *)_sender
{
    returnSheet = [[UIActionSheet alloc] initWithTitle:@"是否存储" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"存储" otherButtonTitles:@"不存储", @"取消", nil];
    [returnSheet showInView:self.view];
}

#pragma mark - 对coreData的操作
//向coreData存入数据
- (void)saveCoreData:(NSInteger )index lebelText:(NSString *)labelText AndImageData:(NSData *)imageData
{
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    DetailCardInfo *detailCardInfo = [NSEntityDescription insertNewObjectForEntityForName:[DetailCardInfo returnEntityName] inManagedObjectContext:context];
    detailCardInfo.imageName = [NSString stringWithFormat:@"%d",index];
    detailCardInfo.detailText = labelText;
    detailCardInfo.imageData = imageData;

    //保存
    NSError *error = nil;
    BOOL success = NO;
    success = [context save:&error];
    NSAssert(success, @"insert object failed with error message '%@'.", [error localizedDescription]);

}


#pragma mark - 封面和内页
- (void)pageSet
{
  
    //贺卡封面图片
    if (!IOS7) {//版本的适配
        //封面的图片
        _outPage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 34, HEIGHT - 160, WIDTH - 74)];
        //内页图片
        inPage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 34, HEIGHT -  160, WIDTH - 74 - 20)];
    }else{
        _outPage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 34 + 40, HEIGHT - 160, WIDTH - 74)];
        inPage = [[UIImageView alloc]initWithFrame:CGRectMake(80, 34 + 40, HEIGHT -  160, WIDTH - 74 - 20)];
    }
    inPage.image = [UIImage imageNamed:@"内页1"];
    inPage.layer.borderWidth = 1;
    _outPage.image = [ UIImage imageNamed:[NSString stringWithFormat:@"%d",self.imageName]];
    _outPage.userInteractionEnabled = YES;
    [self.view addSubview:inPage];
    [self.view addSubview:_outPage];
    
    //添加上滑事件
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnPageIn)];
    swip.direction = UISwipeGestureRecognizerDirectionUp;
    [_outPage addGestureRecognizer:swip];
    
    
    UISwipeGestureRecognizer *swip1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(turnPageOut:)];
    swip1.direction = UISwipeGestureRecognizerDirectionDown;
    [self.outPage addGestureRecognizer:swip1];
    
    //添加点击事件
    UITapGestureRecognizer *photosTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(visitPhotos)];
    [_outPage addGestureRecognizer:photosTap];
    
    point = _outPage.center;
    
    //内页的编辑的textView
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(65 , 20, inPage.frame.size.width - 120,190 )];
    _textLabel.text = @"路漫漫其修远兮\n吾将上下而求索";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.userInteractionEnabled = YES;
    _textLabel.numberOfLines = 0;
    _textLabel.font = [UIFont fontWithName:@"Arial" size:12];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    [inPage addSubview:_textLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushEditTVC)];
    [_textLabel addGestureRecognizer:tap];
}

//设置外页图片
- (void)visitPhotos
{
    SetPhotosViewController *setPVC = [[SetPhotosViewController alloc]init];
    setPVC.delegate = self;
    setPVC.imageName = self.imageName +50;
    [self.navigationController pushViewController:setPVC animated:YES];
    _outPageBtn.hidden = YES;
    _pageTurnBtn.hidden = YES;
    
}

//推送到编辑页
- (void)pushEditTVC
{
    EditTextViewViewController *editTVC = [[EditTextViewViewController alloc]init];
    editTVC.delegate = self;
    [self.navigationController pushViewController:editTVC animated:YES];
    _outPageBtn.hidden = YES;
    _pageTurnBtn.hidden = YES;
    
}

#pragma mark - 翻页的动画
static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 =  -1.0 / z;
    return t;
}


//打开封面的动画
- (void)turnPageIn
{
    inPage.userInteractionEnabled = YES;
    if (IOS7) {
        _outPage.center = CGPointMake(point.x, 34 + 40);
    }else{
        _outPage.center = CGPointMake(point.x, 34);
    }
    _outPage.layer.transform = CATransform3DMakePerspective(500);
    _outPage.layer.anchorPoint = CGPointMake(0.5, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    self.outPage.layer.transform = CATransform3DMakeRotation(M_PI*135/180, 1, 0, 0);
    [UIView commitAnimations];
}

//关闭封面的动画
- (void)turnPageOut:(UIButton *)_sender
{
     self.outPage.layer.anchorPoint = CGPointMake(0.5, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    self.outPage.layer.transform = CATransform3DMakeRotation(M_PI*0/180, 1, 0, 0);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
