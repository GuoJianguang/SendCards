//
//  ScrollView.m
//  SendCards
//
//  Created by rimi on 14-1-18.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import "ScrollView.h"
#import "Header.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame width:(NSInteger)width
{
    self = [super initWithFrame:frame];
    if (self) {
//对版本的适配
        if (!IOS7) {
            self.frame  = CGRectMake(80, 14, HEIGHT - 160, WIDTH - 64 -49);
            self.contentSize = CGSizeMake((HEIGHT - 160)*width, WIDTH - 64 -49);
        }else{
            self.frame  = CGRectMake(80, 14, HEIGHT - 160, WIDTH - 64 -49);
            self.contentSize = CGSizeMake((HEIGHT - 160)*width, WIDTH - 64 -49);
        }
//        self.backgroundColor = [UIColor redColor];

        self.clipsToBounds = NO;
        self.pagingEnabled = YES;
        //让其不显示滑条
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
