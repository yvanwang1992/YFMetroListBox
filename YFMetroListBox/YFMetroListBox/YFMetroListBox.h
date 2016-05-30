//
//  YFMetroListBox.h
//  YFMetroListBox
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFMetroListBox;

@protocol YFMetroListBoxDelegate <NSObject>

@required

// return list of section titles to display in index view
- (NSArray<NSString *> *)sectionIndexTitlesForYFMetroListBox:(YFMetroListBox *)metroListBox;
@end

typedef NS_ENUM(NSInteger, YFMetroListBoxType){
    YFMetroListBoxTypeGroupName = 0, //name1.name2...
    YFMetroListBoxTypeAllAlphabet,  //#.A.B.C....Z.✿
};


@interface YFMetroListBox : UITableView<UITableViewDelegate>

@property (nonatomic, assign) YFMetroListBoxType metroListBoxType;
@property (nonatomic, weak) id<YFMetroListBoxDelegate> listBoxDelegate;

@property (nonatomic, assign) CGSize itemSize;

//Contains InternalWidth and InternalHeight
@property (nonatomic, assign) CGSize interSize;

@property (nonatomic, strong) UIColor *itemBackgroundColor;

@end
