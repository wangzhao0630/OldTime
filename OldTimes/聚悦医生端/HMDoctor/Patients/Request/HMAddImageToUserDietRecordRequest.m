//
//  HMAddImageToUserDietRecordRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/8/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAddImageToUserDietRecordRequest.h"

@implementation HMAddImageToUserDietRecordRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postcommonHealthyPlanService:@"addUserDietRecord4IM"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        //        NSArray *array = [RecordExtendTitleModel mj_objectArrayWithKeyValuesArray:stepResult];
        //        _taskResult = array;
        //        return;
    }
    //    _taskErrorMessage = @"接口数据访问失败。";
    //    _taskError = StepError_NetwordDataError;
}

@end
