//
//  SinaViewController.m
//  SendCards
//
//  Created by rimi on 14-2-26.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "SinaViewController.h"
#import <Social/Social.h>

@interface SinaViewController ()

@end

@implementation SinaViewController

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
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTencentWeibo]) {
        SLComposeViewController *socialVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTencentWeibo];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled) {
                
            }else{
            }
            
            [socialVC dismissViewControllerAnimated:YES completion:nil];
        };
        socialVC.completionHandler = myBlock;
        [socialVC setInitialText:@"整得唠嗑痛"];
    [socialVC addImage:self.myImage];
    NSLog(@"%@",self.myImage);
    
        
        [self presentViewController:socialVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
