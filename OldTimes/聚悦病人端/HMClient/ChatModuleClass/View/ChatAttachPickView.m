//
//  ChatAttachPickView.m
//  Titans
//
//  Created by Remon Lv on 14-9-15.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatAttachPickView.h"
#import "QuickCreateManager.h"

#define IMG_BTN_PHOTO       @"message_chat_photo"
#define IMG_BTN_IMG         @"message_chat_image"
#define IMG_BTN_FILE        @"message_chat_file"
#define IMG_BTN_LOCATION    @"message_chat_location"
#define IMG_BTN_CHECK       @"message_chat_check"

#define TITLE_BTN_VIDEO       @"视频"

static const NSInteger kMaxLineItems = 4; // 每行最大item数量
static const NSInteger kMaxPageItems = 8; // 每页最大item数量
static const NSInteger kMaxPageLines = 2; // 每页最大行数

@interface ChatAttachPickView()<UIScrollViewDelegate>
@property (nonatomic, strong)  UIPageControl  *pageControl; // <##>
@property (nonatomic, strong)  UIScrollView  *scrollView; // <##>
@end

@implementation ChatAttachPickView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

// 配置附件栏输入类型,必须设置
- (void)configAttachPickViewType:(ChatAttachPickType)attachPickType {
    NSArray *arrImg = [NSArray arrayWithObjects:IMG_BTN_IMG,IMG_BTN_PHOTO, nil];
    NSArray *arrTitle = [NSArray arrayWithObjects:@"图片",@"拍照", nil];
    ChatAttachPick_tag maxTag;
    switch (attachPickType) {
        case ChatAttachPickTypeBase: {
            arrImg = @[IMG_BTN_IMG,IMG_BTN_PHOTO];
            arrTitle = @[@"图片",@"拍照"];
            maxTag = tag_pick_takePhoto;
            break;
        }
        case ChatAttachPickTypeFull: {
            arrImg = @[IMG_BTN_IMG,IMG_BTN_PHOTO,@"message_chat_healthPlan",@"message_chat_survey",@"message_chat_inquiry",@"message_chat_prescribe",@"message_chat_care",@"message_chat_evaluate",@"message_chat_wardRound"];
            arrTitle = @[@"图片",@"拍照",@"健康计划",@"随访",@"问诊",@"开处方",@"关怀",@"评估",@"查房"];
            maxTag = tag_pick_max - 1;
            
            break;
        }
    }
    
    // 配置元素
    [self configElementsWithImages:arrImg titles:arrTitle maxItemTag:maxTag];
}

// 配置元素
- (void)configElementsWithImages:(NSArray<NSString *> *)arrImg titles:(NSArray<NSString *> *)arrTitle maxItemTag:(ChatAttachPick_tag)maxTag {
    NSInteger allLines = (maxTag / kMaxLineItems) + ((maxTag % kMaxLineItems) ? 1 : 0);
    NSInteger pages = (maxTag / kMaxPageItems) + ((maxTag % kMaxPageItems) ? 1 : 0);
    
    // 重置size,配置scrollView
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, MIN(kMaxPageLines, allLines) * H_ATTACH_VIEW)];
    self.scrollView.contentSize = CGSizeMake(pages * self.frame.size.width, MIN(kMaxPageLines, allLines) * H_ATTACH_VIEW);
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 配置pageControl
    self.pageControl.numberOfPages = pages;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    // 配置Item
    CGFloat w_view = self.frame.size.width / MIN(arrTitle.count, kMaxLineItems);
    for (ChatAttachPick_tag tag = tag_pick_min + 1; tag <= maxTag; tag ++)
    {
        NSString *imgName = [arrImg objectAtIndex:tag];
        NSString *title = [arrTitle objectAtIndex:tag];
        
        ChatAttachPickBtn *btn = [[ChatAttachPickBtn alloc] initWithFrame:CGRectMake((tag % kMaxLineItems) * w_view + (tag / kMaxPageItems) * self.frame.size.width, ((tag % kMaxPageItems) / kMaxLineItems) * H_ATTACH_VIEW, w_view, H_ATTACH_VIEW) ImageName:imgName Title:title Tag:tag Target:self Action:@selector(btnClicked:)];
        [self.scrollView addSubview:btn];
    }
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = (scrollView.contentOffset.x - self.frame.size.width * 0.5) / self.frame.size.width + 1;
    self.pageControl.currentPage = currentIndex;
}

#pragma mark -- Private Method
- (void)btnClicked:(id)sender
{
    ChatAttachPick_tag tag = (ChatAttachPick_tag)(((UIButton *)sender).tag);
    
    // 转发按钮点击的委托
    if ([self.delegate respondsToSelector:@selector(ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:)])
    {
        [self.delegate ChatAttachPickViewDelegateCallBack_BtnClickedWithTag:tag];
    }
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"cccccc"];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"686b6d"];
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setPagingEnabled:YES];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView setDelegate:self];
    }
    return _scrollView;
}

@end



#pragma mark - MyButton

#define W_BTN   56
#define Y_BTN   18
#define M_TITLE 7
#define H_TITLE 15

@implementation ChatAttachPickBtn

- (id)initWithFrame:(CGRect)frame ImageName:(NSString *)imgName Title:(NSString *)title Tag:(NSInteger)tag Target:(id)target Action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 按钮
        _btn = [QuickCreateManager creatButtonWithFrame:CGRectMake((frame.size.width - W_BTN) * 0.5, Y_BTN, W_BTN, W_BTN) Title:nil TitleFont:nil TitleColor:nil BgImage:[UIImage imageNamed:imgName] HighImage:nil BgColor:nil Tag:tag];
        [_btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [_btn setTag:tag];
        [self addSubview:_btn];
        
        // 标签
        _lbTitle = [QuickCreateManager creatLableWithFrame:CGRectMake(0, CGRectGetMaxY(_btn.frame) + M_TITLE, frame.size.width, H_TITLE) Text:title Font:[UIFont font_28] Alignment:NSTextAlignmentCenter Color:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_lbTitle];
    }
    return self;
}

@end
