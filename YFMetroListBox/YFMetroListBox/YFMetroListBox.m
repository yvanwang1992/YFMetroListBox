//
//  YFMetroListBox.m
//  YFMetroListBox
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import "YFMetroListBox.h"

#define kInterHeight 10
#define kInterWidth 10
#define kitemWidth 55
#define kitemHeight 50

#define AllAlphabetLength 28

#define kNumberSign @"#"
#define kSymbolSign @"✿"
#define kAllIndexArray @[kNumberSign, @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",kSymbolSign]

@interface YFMetroListBox(){
    id<UITableViewDelegate> _selfDelegate;
    UIView *_zoomOutView;
    UIView *_zoomView;
    NSInteger *_selectedIndex;
}

@end

@implementation YFMetroListBox

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame style:UITableViewStylePlain]){
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    self.itemSize = CGSizeMake(kitemWidth, kitemHeight);
    self.interSize = CGSizeMake(kInterWidth, kInterHeight);
    self.itemBackgroundColor = [UIColor colorWithRed:0/256.0 green:161/256.0 blue:241/256.0 alpha:1];

    self.metroListBoxType = YFMetroListBoxTypeGroupName;
    
    _zoomOutView = [[UIView alloc] initWithFrame:self.frame];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.8;
    [_zoomOutView addSubview:backgroundView];
    
    _zoomOutView.hidden = YES;
}


//更换代理
-(void)setDelegate:(id<UITableViewDelegate>)delegate{
    _selfDelegate = delegate;
    [super setDelegate:self];
}

//转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([_selfDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:_selfDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

-(BOOL)respondsToSelector:(SEL)aSelector{
    return [_selfDelegate respondsToSelector:aSelector] || [super respondsToSelector:aSelector];
}

#pragma mark -m UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    if([_selfDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
        [_selfDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
    //Add Tap Gesture
    if([self.listBoxDelegate respondsToSelector:@selector(sectionIndexTitlesForYFMetroListBox:)]){
        UITapGestureRecognizer *tapRegesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderViewInSection)];
        view.gestureRecognizers = @[tapRegesture];
    }
}


-(void)setMetroListBoxType:(YFMetroListBoxType)metroListBoxType{
    if(_metroListBoxType == metroListBoxType){
        return;
    }
    _metroListBoxType = metroListBoxType;
}

-(void)tapHeaderViewInSection{
    [self updateZoomOutView];
    [self showZoomOutView];
}



-(UIView *)calculateAndLayout:(YFMetroListBoxType)type{
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor clearColor];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideZoomOutView)]];

    CGSize viewSize = view.frame.size;
    NSInteger items = (type == YFMetroListBoxTypeGroupName) ? self.numberOfSections : AllAlphabetLength;
    
    
    CGFloat actualWith = .0f;
    NSInteger columns = 3;
    
    CGFloat itemWidth = self.itemSize.width, itemHeight = self.itemSize.height;
    CGFloat interWidth = self.interSize.width, interHeight = self.interSize.height;
    for (int i = 1 ; i <= items; i++) {
        actualWith += itemWidth + interWidth * 2;
        if(actualWith >= viewSize.width){//这里可以设置一个最大值  最小值来判断  有一个默认值
            break;
        }
        columns = i;
    }
    NSInteger rows = items / columns + (items % columns == 0 ? 0 : 1);
    
    //计算出X 和 Y
    CGFloat originX = (viewSize.width - columns * itemWidth - (columns - 1) * interWidth) / 2;
    CGFloat originY = (viewSize.height - rows * itemHeight - (rows - 1) * interHeight) / 2;
    
    //布局
    NSArray *headerTextArray = @[];
    if([self.listBoxDelegate respondsToSelector:@selector(sectionIndexTitlesForYFMetroListBox:)]){
        headerTextArray = [self.listBoxDelegate sectionIndexTitlesForYFMetroListBox:self];
    }
    NSArray *showArray = (type == YFMetroListBoxTypeGroupName) ? headerTextArray : kAllIndexArray;
    
    if(headerTextArray.count == 0){
        [self hideZoomOutView];
    }
    
    for (int i = 0 ; i < showArray.count; i++) {
        NSInteger column =  i % columns;
        NSInteger row = i / columns;
        
        UIButton *button = [[UIButton alloc] initWithFrame:
                            CGRectMake(originX + (itemWidth  + interWidth)  * column,
                                       originY + (itemHeight + interHeight) * row,
                                       itemWidth, itemHeight)];
        [button setTitle:[showArray objectAtIndex:i] forState:UIControlStateNormal];
        
        if([headerTextArray containsObject:showArray[i]]){
            [button setBackgroundColor:self.itemBackgroundColor];
            button.tag = 100 + [headerTextArray indexOfObject:showArray[i]];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button setBackgroundColor:[UIColor grayColor]];
        }
        
        [view addSubview:button];
    }
    return view;
}

-(void)buttonTapped:(UIButton *)button{
    NSInteger section = button.tag - 100;
    [self hideZoomOutView];
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma methods about zoomOutView
-(void)updateZoomOutView{
    if([self.listBoxDelegate respondsToSelector:@selector(sectionIndexTitlesForYFMetroListBox:)]){
        
        _zoomView = [self calculateAndLayout:self.metroListBoxType];
        if(_zoomOutView.subviews.count > 1){
            [[_zoomOutView.subviews lastObject] removeFromSuperview];
        }
        [_zoomOutView addSubview:_zoomView];
        [self.superview addSubview:_zoomOutView];
    }
}

-(void)showZoomOutView{
    if(!_zoomOutView.hidden) return;
    //动画
    _zoomOutView.hidden = NO;
    _zoomView.alpha = 0;
    _zoomView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.4 animations:^{
        _zoomOutView.alpha = 1;
        _zoomView.alpha = 1;
        _zoomView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)hideZoomOutView{
    if(_zoomOutView.hidden) return;
    
    [UIView animateWithDuration:0.4 animations:^{
        _zoomOutView.alpha = 0;
        _zoomView.alpha = 0;
        _zoomView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        _zoomOutView.hidden = YES;
    }];
}

#pragma -m mark Update ZoomOutView while editing sections
//Data
-(void)reloadData{
    [self updateZoomOutView];
    [super reloadData];
}

-(void)reloadSectionIndexTitles{
    [self updateZoomOutView];
    [super reloadSectionIndexTitles];
}

// redraw index view after calling insert/delete/reload
-(void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self updateZoomOutView];
    [super insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self updateZoomOutView];
    [super deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self updateZoomOutView];
    [super reloadSections:sections withRowAnimation:animation];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection{
    [self updateZoomOutView];
    [super moveSection:section toSection:newSection];
}

@end
