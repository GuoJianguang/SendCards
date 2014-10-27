//
//  ContinueViewController.m
//  SendCards
//
//  Created by rimi on 14-2-12.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "ContinueViewController.h"
#import "SaveCardViewController.h"
#import "AppDelegate.h"
#import "DetailCardInfo.h"
#import "Header.h"

@interface ContinueViewController ()

@end

@implementation ContinueViewController

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
    //返回按钮
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBtn:)];
    returnBtn.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = returnBtn;
    if (IOS7) {
        self.outPage.frame = CGRectMake(80, 34+40, HEIGHT-160, WIDTH-74-20);
    }
    UIImage *image = [UIImage imageWithData:[[self.saveCardVC.getArray objectAtIndex:self.index]objectForKey:@"imageData"]];
    self.outPage.image = image;
    self.textLabel.text = self.str;
    
}

//返回按钮的点击事件
- (void)returnBtn:(UIBarButtonItem *)_sender
{
    [self changeCoreData];  //改变某行的数据
    self.saveCardVC.getArray = [self readCoreData];//改变数据数据源
    self.saveCardVC.editView.hidden = YES;
    [self.saveCardVC.aTableView reloadData];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 对coreData的操作
//coreData数据的读取
- (NSMutableArray *)readCoreData
{
    /*通过cordData取出数据*/
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DetailCardInfo"];
    NSArray *array  = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:nil]];
    NSMutableArray *dataArray = [NSMutableArray array];
    //先生成字典在加入数据源
    for (DetailCardInfo *obj in array) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:obj.imageName forKey:@"image"];
        [dic setObject:obj.detailText forKey:@"text"];
        [dic setObject:obj.imageData forKey:@"imageData"];
        [dataArray addObject:dic];
    }
    return dataArray;
}

//改变某行的数据
- (void)changeCoreData
{
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DetailCardInfo"];
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    NSData *data = UIImagePNGRepresentation(self.outPage.image);
    
    //改变某行的数据
    for (int i  = 0; i < array.count; i ++) {
        if (i == self.index) {
            ((DetailCardInfo *)[array objectAtIndex:i]).detailText = self.textLabel.text;
            ((DetailCardInfo *)[array objectAtIndex:i]).imageData = data;
        }
    }
    NSError *error = nil;
    BOOL success = NO;
    success = [context save:&error];
    NSAssert(success, @"insert object failed with error message '%@'.", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
