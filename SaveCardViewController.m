//
//  SaveCardViewController.m
//  SendCards
//
//  Created by rimi on 14-2-11.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#define cellHeight 80

#import "SaveCardViewController.h"
#import "Header.h"
#import "EditViewController.h"
#import "ContinueViewController.h"
#import "AppDelegate.h"
#import "DetailCardInfo.h"

@interface SaveCardViewController ()
{
    UIButton *delBtn;
    UIButton *continueBtn;
}

@end

@implementation SaveCardViewController

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
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBtn)];
    returnBtn.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = returnBtn;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"导航条"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    
    // 初始化tableView
    self.aTableView = [[UITableView alloc]init];
    self.aTableView.frame = CGRectMake(0, 0, HEIGHT, WIDTH-self.navigationController.navigationBar.frame.size.height);
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        self.aTableView.frame = CGRectMake(0, 0, HEIGHT, WIDTH-self.navigationController.navigationBar.frame.size.height-20);
    }
    self.aTableView.delegate = self;
    self.aTableView.dataSource = self;
    [self.view addSubview:self.aTableView];
    //取出存储的卡片名字
    //    _getArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"dataSouce"]];
    
    //读取coreData里面的数据
    self.getArray = [NSMutableArray arrayWithArray:[self readCoreData]];
}


#pragma mark - tableView代理事件

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _getArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *identifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消cell的选中状态
    
    /*获取已存储贺卡的信息，包括图片，和详细内容*/
    UIImage *image = [UIImage imageWithData:[[self.getArray objectAtIndex:indexPath.row]objectForKey:@"imageData"]];
    cell.imageView.image = image;

    cell.imageView.userInteractionEnabled = YES;
    UIButton *btn  = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 110, cellHeight);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(turnContinueVC:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = indexPath.row + 500;
    [cell.imageView addSubview:btn];
    
    cell.textLabel.text = @"详细信息";

    cell.detailTextLabel.text = [[_getArray objectAtIndex:indexPath.row]objectForKey:@"text"];
    cell.detailTextLabel.numberOfLines = 0;
    
    //存放编辑按钮和删除按钮的View
    _editView = [[UIView alloc]init];
    if (!IOS7) {
        _editView.frame = CGRectMake(110, 0, cell.frame.size.width, cellHeight);
    }else {
        _editView.frame = CGRectMake(140, 0, cell.frame.size.width, cellHeight);
    }
    _editView.tag = indexPath.row + 100;
    _editView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:_editView];
    
    //编辑按钮
    continueBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 5, 25, 50)];
    continueBtn.tag = 400 + indexPath.row;
    [continueBtn setImage:[UIImage imageNamed:@"继续编辑"] forState:UIControlStateNormal];
    [continueBtn addTarget:self action:@selector(continueBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:continueBtn];
    
    for (int i  = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(95 + i * (30 + 75), 55, 30, 15)];
        if (i == 0) {
            label.text = @"编辑";
        }else{
            label.text = @"删除" ;
        }
        label.font = [UIFont fontWithName:@"Arial" size:13];
        [_editView addSubview:label];
    }
    
    //删除按钮
    delBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 5, 25, 50)];
    delBtn.tag = 200 + indexPath.row;
    [delBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteSaveCard:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:delBtn];
    
    
    _editView.hidden = YES;
    
    
    //对当前选中的卡片进行操作的按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = indexPath.row + 300;
    editBtn.frame = CGRectMake(0, 0, 25, 25);
    editBtn.selected = NO;
    [editBtn setImage:[UIImage imageNamed:@"按钮蓝"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"按钮绿"] forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = editBtn;
    return cell;

}

#pragma mark - 一些点击事件;

- (void)editBtn:(UIButton *)_sender
{
    _sender.selected = !_sender.selected;
    //获取当前点击cell上的editView;
    if (_sender.selected) {
    [((UITableViewCell *)[_sender superview]) viewWithTag:_sender.tag - 200].hidden = NO;
    }else{
    [((UITableViewCell *)[_sender superview]) viewWithTag:_sender.tag - 200].hidden = YES;

    }
}

//删除当前选中的存储图片
- (void)deleteSaveCard:(UIButton *)_sender
{
    [((UITableViewCell *)[_sender superview]) viewWithTag:_sender.tag - 100].hidden = YES;
    [_getArray removeObjectAtIndex:_sender.tag - 200];
    //删除coreData里面的数据
    [self deleteCoreData:_sender.tag];
    [self.aTableView reloadData];
}

//进入编辑页面重新继续编辑
- (void)continueBtn:(UIButton *)_sender
{
    /*用来放置编辑和删除按钮的view（注意设置其隐藏属性）设置为隐藏，
     不然继续编辑完毕后跳转回来，该View还是处于显示状态*/
    [((UITableViewCell *)[_sender superview]) viewWithTag:_sender.tag - 300].hidden = YES;
    
    
    ContinueViewController *editVC = [[ContinueViewController alloc]init];
    editVC.saveCardVC = self;
    editVC.imageName = [[[_getArray objectAtIndex:_sender.tag - 400] objectForKey:@"image"]integerValue];
    editVC.str = [[_getArray objectAtIndex:_sender.tag - 400] objectForKey:@"text"];
    editVC.index = _sender.tag - 400;
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

- (void)turnContinueVC:(UIButton *)_sender
{
    ContinueViewController *editVC = [[ContinueViewController alloc]init];
    editVC.saveCardVC = self;
    editVC.imageName = [[[_getArray objectAtIndex:_sender.tag - 500] objectForKey:@"image"]integerValue];
    editVC.str = [[_getArray objectAtIndex:_sender.tag - 500] objectForKey:@"text"];
    editVC.index = _sender.tag - 500;
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

//返回主页
- (void)returnBtn
{
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

//coreData数据的删除
- (void)deleteCoreData:(NSInteger)index
{
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"DetailCardInfo"];
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error = nil;
    if (array && array.count > 0) {
        [array enumerateObjectsUsingBlock:^(id obj , NSUInteger idx,BOOL *stop){
            if (idx == index -200) {
                [context deleteObject:obj];
            }
        }];
    }
    
    //保存数据
    BOOL success = [context save:&error];
    NSLog(@"%d",success);
    NSAssert(success, @"delete object failed with error message '%@'.", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
