//
//  AddressBookViewController.m
//  SendCards
//
//  Created by rimi on 15-2-18.
//  Copyright (c) 2015年 Guo Jiangaung. All rights reserved.
//

#import "AddressBookViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Header.h"
//CFArrayRef ABAddressBookCopyArrayOfAllPeople (
//                                              ABAddressBookRef addressBook
//                                              );
//CFArrayRef ABAddressBookCopyPeopleWithName (
//                                            ABAddressBookRef addressBook,
//                                            CFStringRef name
//                                            );


@interface AddressBookViewController ()

@end

@implementation AddressBookViewController

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
        ABAddressBookRef addressBook = nil;
    if (!IOS7) {
   addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
   dispatch_semaphore_t sema = dispatch_semaphore_create(0);
   ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
//    CFArrayRef contacts = ABAddressBookCopyArrayOfAllGroups(addressBook);
//    NSLog(@"%@",contacts);
    }
    NSArray *array = (__bridge  NSArray *)(ABAddressBookCopyArrayOfAllGroups(addressBook));
    NSLog(@"%@",array);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
