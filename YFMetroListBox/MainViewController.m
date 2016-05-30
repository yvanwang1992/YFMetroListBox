//
//  ViewController.m
//  YFMetroListBox
//
//  Created by admin on 16/5/23.
//  Copyright © 2016年 Yvan Wang. All rights reserved.
//

#import "MainViewController.h"
#import "YFMetroListBox.h"

#define kIndexKey @"title"
#define kArrayKey @"array"

#define kCell @"cell"
#define kHeaderView @"headerView"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, YFMetroListBoxDelegate>

@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) YFMetroListBox *metroListBox;

@end


@implementation MainViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)removeSection{
    if(self.arrayData.count == 0){
        return;
    }
    [self.arrayData removeObjectAtIndex:0];
    [self.metroListBox deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self.view setBackgroundColor:[UIColor grayColor]];

    self.title = @"YFMetroListBox";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除第一组" style:UIBarButtonItemStylePlain target:self action:@selector(removeSection)];
    
    self.arrayData =
    @[@{kIndexKey:@"#",kArrayKey:@[@"1520",@"950XL",@"640",@"1020"]},
      @{kIndexKey:@"A",kArrayKey:@[@"abandon",@"aboard",@"absolute",@"academic"]},
      @{kIndexKey:@"B",kArrayKey:@[@"brand",@"battery",@"bucket",@"bull"]},
      @{kIndexKey:@"G",kArrayKey:@[@"government",@"grave",@"guarantee",@"gum",@"grieve"]},
      @{kIndexKey:@"I",kArrayKey:@[@"interference",@"instrument",@"inevitable"]},
      @{kIndexKey:@"K",kArrayKey:@[@"kingdom",@"knife"]},
      @{kIndexKey:@"M",kArrayKey:@[@"mature",@"measurable",@"mention",@"mercy"]},
      @{kIndexKey:@"P",kArrayKey:@[@"pessimistic"]},
      @{kIndexKey:@"Q",kArrayKey:@[@"queer",@"quantity",@"quarterly"]},
      @{kIndexKey:@"T",kArrayKey:@[@"tortoise",@"twentieth",@"transformation"]},
      @{kIndexKey:@"V",kArrayKey:@[@"volcano",@"vibration"]},
      @{kIndexKey:@"W",kArrayKey:@[@"worthwhile",@"worthless",@"world-wide"]},
      @{kIndexKey:@"✿",kArrayKey:@[@"@live.com",@"$1314",@"&&",@"#10086#"]}].mutableCopy;
    
    self.metroListBox = [[YFMetroListBox alloc] initWithFrame:self.view.bounds];
    self.metroListBox.backgroundColor = [UIColor whiteColor];
    self.metroListBox.metroListBoxType = YFMetroListBoxTypeAllAlphabet;
    self.metroListBox.sectionHeaderHeight = 40;

    self.metroListBox.itemSize = CGSizeMake(50, 50);
    self.metroListBox.interSize = CGSizeMake(10, 10);
//    self.metroListBox.itemBackgroundColor = [UIColor redColor];
    
    self.metroListBox.listBoxDelegate = self;
    self.metroListBox.delegate = self;
    self.metroListBox.dataSource = self;
    
    [self.metroListBox registerClass:[UITableViewCell class] forCellReuseIdentifier:kCell];
    [self.metroListBox registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kHeaderView];
    
    [self.view addSubview:self.metroListBox];
    
}

#pragma mark -m UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.arrayData objectAtIndex:section];
    NSArray *array = [dic objectForKey:kArrayKey];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    
    NSDictionary *dic = [self.arrayData objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:kArrayKey];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}


#pragma mark -m YFMetroListBoxDelegate
- (NSArray<NSString *> *)sectionIndexTitlesForYFMetroListBox:(YFMetroListBox *)metroListBox{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < self.arrayData.count; i++) {
        NSDictionary  *dic = [self.arrayData objectAtIndex:i];
        [array addObject:[dic objectForKey:kIndexKey]];
    }
    return array;
}

#pragma mark -m UITableViewDelegate

//Default
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSDictionary  *dic = [self.arrayData objectAtIndex:section];
//    return [dic objectForKey:@"title"];
//}

//有了下面这个  上面这个就无效了
//使用自定义的
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderView];
    [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,40)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:label];
    
    NSDictionary *dic = [self.arrayData objectAtIndex:section];
    NSString *title = [dic objectForKey:kIndexKey];
    label.text = title;
    return header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
