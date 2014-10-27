//
//  EditTextViewViewController.m
//  SendCards
//
//  Created by rimi on 14-2-11.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "EditTextViewViewController.h"
#import "Header.h"
#import "EditViewController.h"

@interface EditTextViewViewController ()

@end

@implementation EditTextViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"编辑文本";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor brownColor];
    //返回按钮
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(returnBtn:)];
    returnBtn.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = returnBtn;
    
    UIBarButtonItem *sureBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(sureBtn:)];
    sureBtn.tintColor = [UIColor brownColor];
    self.navigationItem.rightBarButtonItem = sureBtn;
    
    _editTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, HEIGHT, WIDTH/2.8)];
    if (IOS7) {
        _editTextView.frame = CGRectMake(0, 0+44, HEIGHT, WIDTH/2.8);
    }
    [self.view addSubview:_editTextView];
    
    if (IOS7) {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.editTextView.text = self.delegate.textLabel.text;
    
    [_editTextView becomeFirstResponder];//一进来就处于编辑状态
}

- (void)sureBtn:(UIButton *)_sender
{
    self.delegate.textLabel.text = _editTextView.text;
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.delegate.pageTurnBtn.hidden = NO;
    self.delegate.outPageBtn.hidden = NO;}

- (void)returnBtn:(UIButton *)_sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.delegate.pageTurnBtn.hidden = NO;
    self.delegate.outPageBtn.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
