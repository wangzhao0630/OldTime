//
//  RowButtonGroup.h
//  Shape
//
//  Created by Andrew Shen on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RowButtonGroupDelegate <NSObject>

// 按钮点击
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag;

@end
@interface RowButtonGroup : UIView
@property (nonatomic, weak)  id <RowButtonGroupDelegate>  delegate; // 委托
@property (nonatomic, strong)  UIButton  *selectedBtn; // 当前选中的btn

/**
 *  初始化一行按钮
 *
 *  @param arrayTitles        按钮标题
 *  @param arrayTags          按钮tag
 *  @param normalTitleColor   标题正常状态颜色
 *  @param selectedTitleColor 标题选中状态颜色
 *  @param lineColor          线条颜色，nil则不显示线条
 *  @param minumButtonWidth   最小按钮宽度
 *
 *  @return 
 */
- (instancetype)initWithTitles:(NSArray *)arrayTitles tags:(NSArray *)arrayTags normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor font:(UIFont *)font lineColor:(UIColor *)lineColor minimumButtonWidth:(CGFloat)minimumButtonWidth;

/**
 *  设置根据tag按钮选中
 *
 *  @param tag 选中按钮tag
 */
- (void)setBtnSelectedWithTag:(NSInteger)tag;
@end
