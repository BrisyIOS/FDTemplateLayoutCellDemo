//
//  FDModel.m
//  FDTemplateLayoutCell的简单实用
//
//  Created by zhangxu on 16/2/14.
//  Copyright © 2016年 zhangxu. All rights reserved.
//

#import "FDModel.h"

@implementation FDModel

+ (NSMutableArray *)modelWithDic:(NSDictionary *)dic{
    
    NSMutableArray *modelArray = [NSMutableArray array];
    NSDictionary *dataDic = dic[@"data"];
    NSArray *itemArray = dataDic[@"items"];
    for (NSDictionary *itemDic in itemArray) {
        
        FDModel *model = [[self alloc] init];
        [model setValuesForKeysWithDictionary:itemDic];
        [modelArray addObject:model];
    }
    return modelArray;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
