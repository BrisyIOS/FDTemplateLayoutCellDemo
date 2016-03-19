//
//  FDModel.h
//  FDTemplateLayoutCell的简单实用
//
//  Created by zhangxu on 16/2/14.
//  Copyright © 2016年 zhangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDModel : NSObject
@property (nonatomic,strong) NSDictionary *cover;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *consumption_per_person;
@property (nonatomic,copy) NSString *address;

+ (NSMutableArray *)modelWithDic:(NSDictionary *)dic;

@end
