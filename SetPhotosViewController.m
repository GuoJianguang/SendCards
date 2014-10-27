//
//  SetPhotosViewController.m
//  SendCards
//
//  Created by rimi on 14-2-13.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "SetPhotosViewController.h"
#import "Header.h"
#import "EditViewController.h"

@interface SetPhotosViewController ()
{
       CGFloat lastScale;
    UIView *backView;
}


@end

@implementation SetPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"选取并设置照片";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UIImageView *backImageView = [[UIImageView alloc]init];
//    backImageView.frame = CGRectMake(0, 0,HEIGHT , WIDTH);
//    backImageView.image = [UIImage imageNamed:@"dianbg"];
//    [self.view addSubview:backImageView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"点"]];
    //相册和相机的点击事件
    UIBarButtonItem *albumItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"相册"] style:UIBarButtonItemStylePlain target:self action:@selector(turnAlbum)];
    albumItem.tintColor = [UIColor brownColor];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"照相机"] style:UIBarButtonItemStylePlain target:self action:@selector(turnCamera)];
    cameraItem.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:albumItem,cameraItem, nil];
   
    //确定按钮和取消按钮
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItem)];

    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureItem)];
    sureItem.tintColor = [UIColor brownColor];
    cancelItem.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:sureItem,cancelItem,nil];
    
    [self combineTowImage];
}


- (void)turnAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //    //设置图片源(相簿)
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    //设置代理
    picker.delegate = self;
//    picker.allowsEditing = YES;
    //打开拾取器界面
    [self presentViewController:picker animated:NO completion:^{}];
}


- (void)turnCamera
{
    UIActionSheet *sheet;
    sheet.delegate = self;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        //如果设备支持照相机
    {
//        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;//访问照相机
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else {
//        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        NSLog(@"设备不支持相机,跳转到相册");
        [self turnAlbum];
    }
    
    [sheet showInView:self.view];
}

- (void)sureItem
{
    //合并两张图片
    UIGraphicsBeginImageContext(self.outPage.image.size);
    [self.myImage.image drawInRect:CGRectMake(self.myImage.frame.origin.x   , self.myImage.frame.origin.y, self.myImage.frame.size.width*2, self.myImage.frame.size.height*2)];
    [self.outPage.image drawInRect:CGRectMake(0, 0, self.outPage.image.size.width, self.outPage.image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.myImage.image = newImage;
    self.delegate.outPage.image = newImage;
    self.delegate.outPageBtn.hidden = NO;
    self.delegate.pageTurnBtn.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelItem
{
    self.delegate.outPageBtn.hidden = NO;
    self.delegate.pageTurnBtn.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 两张图片的合并
- (void)combineTowImage
{
    backView = [[UIView alloc]init];
    if (IOS7) {
        backView.frame = CGRectMake(80, 34+25, HEIGHT - 160, WIDTH - 74);
    }else{
        backView.frame = CGRectMake(80, 24, HEIGHT - 160, WIDTH - 74);

    }
    backView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:backView];
    
    self.outPage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    self.outPage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)self.imageName]];
    
    _myImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    _myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",self.imageName-50]];
    [backView addSubview:_myImage];
    [backView addSubview:self.outPage];
    
    //滑动
    UIPanGestureRecognizer *MoveHand = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(MOveHa:)];
    [MoveHand setMinimumNumberOfTouches:1];
    [backView addGestureRecognizer:MoveHand];
    backView.clipsToBounds = YES;
    

    //缩放
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] ;
    [pinchRecognizer setDelegate:self];
    [backView addGestureRecognizer:pinchRecognizer];
    
    //旋转
    UIRotationGestureRecognizer * rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [backView addGestureRecognizer:rotateGesture];

}

//旋转
- (void)rotate:(UIRotationGestureRecognizer *)recognizer
{
    float rotation = recognizer.rotation;
    self.myImage.transform = CGAffineTransformMakeRotation(rotation);
}

 //缩放
- (void)scale:(UIPinchGestureRecognizer *)_sender
{
    
    if (_sender.state == UIGestureRecognizerStateEnded||_sender.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        return;
    }
    CGFloat scale = 1.0 + _sender.scale - lastScale;
    self.myImage.transform = CGAffineTransformScale(self.myImage.transform, scale, scale);
    lastScale = _sender.scale;
    NSLog(@"%f",self.myImage.frame.size.height);

}

//滑动
- (void)MOveHa:(UIPanGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateBegan||sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint;
        newPoint = [sender translationInView:self.myImage];
        self.myImage.center = CGPointMake(self.myImage.center.x+newPoint.x, self.myImage.center.y+newPoint.y);
        [sender setTranslation:CGPointZero inView:self.myImage];
        
    }
}

//从相册获取当前点击的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.myImage.image = image;
    
}
-(NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskAll;
}
-(BOOL)shouldAutorotate
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
