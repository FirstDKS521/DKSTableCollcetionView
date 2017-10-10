#iOS开发：UITableView嵌套UICollectionView结合使用

![效果GIF.gif](http://upload-images.jianshu.io/upload_images/1840399-d9a1689783b1f1d5.gif?imageMogr2/auto-orient/strip)

在UITableViewCell中嵌套UICollectionViewCell，效果图中，上面两个cell和下面几个cell是不同类型的，像这种效果，上面一部分也可以在UITableViewCell中通过自定义视图实现，不过我个人觉得还是这种嵌套的方式更加的简单些；

####RootViewController.h的代码：

```
#import <UIKit/UIKit.h>
#import "RootTableCell.h"

@interface RootViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RootCellDelegate>

@end
```

####RootViewController.m的代码：

```
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
```
####主要是UITableViewCell中的实现  RootTableCell.h文件

```
#import <UIKit/UIKit.h>

@class RootTableCell;
@protocol RootCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(RootTableCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;


/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content;
@end

@interface RootTableCell : UITableViewCell

@property (nonatomic, weak) id<RootCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray *dataAry;

@end
```
####RootTableCell.m文件

```
#import "RootTableCell.h"
#import "RootCollectionCell.h"

#define K_Cell @"cell"
@interface RootTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat heightED;

@end

@implementation RootTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.heightED = 0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
    }
    return self;
}

#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataAry.count == 0) {
        return 1;
    } else {
        return self.dataAry.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RootCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_Cell forIndexPath:indexPath];
    cell.textStr = self.dataAry[indexPath.row];
    [self updateCollectionViewHeight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:withContent:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath withContent:self.dataAry[indexPath.row]];
    }
}

- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.heightED != height) {
        self.heightED = height;
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.frame.size.width, height);
        
        if (_delegate && [_delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
        }
    }
}

#pragma mark ====== init ======
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 50) / 4;
        layout.itemSize = CGSizeMake(width, 60);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[RootCollectionCell class] forCellWithReuseIdentifier:K_Cell];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)setDataAry:(NSArray *)dataAry {
//    [self.collectionView reloadData];
    self.heightED = 0;
    _dataAry = dataAry;
}

@end
```

至于里面的页面，相对来说就很简单了，[参考文章](http://www.jianshu.com/p/e747d15dc460)

[简书地址](http://www.jianshu.com/p/3074665bee73)