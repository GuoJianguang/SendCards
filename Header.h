//
//  Header.h
//  NWM
//
//  Created by rimi0239 on 14-1-18.
//  Copyright (c) 2014年 yanghan. All rights reserved.
//

#ifndef NWM_Header_h
#define NWM_Header_h
//字体颜色
#define fontColor [UIColor colorWithRed:139.0/255 green:178.0/255 blue:38.0/255 alpha:1]
//版本控制
#define IOS7 (([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)?YES:NO)
//屏幕尺寸判断
#define IHPONE5 (([[UIScreen mainScreen]bounds].size.height-568)?NO:YES)

//屏幕高度
#define HEIGHT ([[UIScreen mainScreen]bounds].size.height)
//屏幕宽度
#define WIDTH  ([[UIScreen mainScreen]bounds].size.width)

#endif
