//
//  RootViewController.m
//  DKSTableCollcetionView
//
//  Created by aDu on 2017/10/10.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "MyTableCell.h"

#define K_T_Cell @"t_cell"
#define K_C_Cell @"c_cell"
@interface RootViewController ()

@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dicH;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"嵌套使用";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.dataAry = @[@[@"1元", @"2元", @"3元", @"4元", @"5元", @"6元"],
                     @[@"1元", @"2元", @"3元", @"4元", @"10元", @"20元", @"30元", @"40元", @"11元", @"22元", @"33元"]];
    [self.view addSubview:self.tableView];
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dicH[indexPath]) {
        NSNumber *num = self.dicH[indexPath];
        return [num floatValue];
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataAry.count) {
        [tableView registerClass:[RootTableCell class] forCellReuseIdentifier:K_C_Cell];
        RootTableCell *cell = [tableView dequeueReusableCellWithIdentifier:K_C_Cell forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.dataAry = self.dataAry[indexPath.row];
        return cell;
    } else {
        [tableView registerClass:[MyTableCell class] forCellReuseIdentifier:K_T_Cell];
        MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:K_T_Cell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark ====== RootTableCellDelegate ======
- (void)updateTableViewCellHeight:(RootTableCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.dicH[indexPath] isEqualToNumber:@(height)]) {
        self.dicH[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

//点击UICollectionViewCell的代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark ====== init ======
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableDictionary *)dicH {
    if (!_dicH) {
        _dicH = [[NSMutableDictionary alloc] init];
    }
    return _dicH;
}

@end
