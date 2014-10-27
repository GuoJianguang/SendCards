//
//  DetailCardInfo.h
//  SendCards
//
//  Created by ucit on 14-4-1.
//  Copyright (c) 2014年 Guo Jiangaung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DetailCardInfo : NSManagedObject

@property (nonatomic, retain) NSString * detailText;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSData * imageData;

+ (NSString *)returnEntityName;

@end
