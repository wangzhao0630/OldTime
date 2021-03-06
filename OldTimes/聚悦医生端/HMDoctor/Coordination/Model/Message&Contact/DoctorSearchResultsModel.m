//
//  DoctorSearchResultsModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "DoctorSearchResultsModel.h"
#import "DoctorCompletionInfoModel.h"

@implementation DoctorSearchResultsModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isKindOfClass:[NSString class]] && [oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    return oldValue;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : [DoctorCompletionInfoModel class]
             };
}

@end
