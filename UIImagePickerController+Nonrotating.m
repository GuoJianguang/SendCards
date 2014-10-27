//
//  UIImagePickerController+Nonrotating.m
//  SendCards
//
//  Created by rimi on 14-2-13.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "UIImagePickerController+Nonrotating.h"

@implementation UIImagePickerController (Nonrotating)

-(BOOL)shouldAutorotate
{
     return YES;
}


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
////    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//    return UIInterfaceOrientationPortrait;
//}

//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//}
@end

