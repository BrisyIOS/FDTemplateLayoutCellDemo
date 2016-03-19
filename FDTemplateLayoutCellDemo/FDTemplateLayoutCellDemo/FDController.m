//
//  FDController.m
//  FDTemplateLayoutCell的简单实用
//
//  Created by zhangxu on 16/2/14.
//  Copyright © 2016年 zhangxu. All rights reserved.
//

#import "FDController.h"
#import "FDCell.h"
#import "FDModel.h"
#define pageSize 20

typedef NS_ENUM(NSInteger,RefreshType){
    RefreshTypeHeader,// 上拉刷新
    RefreshTypeFooter// 下拉加载更多
};

NSString * const url = @"http://api.yizhong.cccwei.com/api.php?srv=2015&cid=524991&uid=0&tms=20151206220819&sig=7eca60a054f50ab0&wssig=63636f0fa161fd8a&os_type=3&version=8&city_id=2&channel=meizu&cate_id=1&scene_id=0&sort_type=1&since_id=0&tag_id=0&page_num=1&page_size=20&coordinate=121.295084,31.13407";
NSString * const ID = @"FDCell";
@interface FDController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,assign) BOOL cellHeightCacheEnabled;


@end

@implementation FDController{
    
    RefreshType refreshType;
}

- (UIRectEdge)edgesForExtendedLayout{
    return UIRectEdgeNone;
}

// 懒加载
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  添加tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 500;// 预估高度
    [self.view addSubview:_tableView];
    
    // 注册cell
    [self.tableView registerClass:[FDCell class] forCellReuseIdentifier:ID];
    
    // 加载数据
    [self setDataWithURL:[NSURL URLWithString:url]];
    
    
    // 上拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refreshType = RefreshTypeHeader;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.modelArray removeAllObjects];
            [weakSelf setDataWithURL:[NSURL URLWithString:url]];
        });
    }];
    
    
    // 下拉加载更多
    __block int page_size = pageSize;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refreshType = RefreshTypeFooter;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            page_size += pageSize;
            NSString *newURL = [NSString stringWithFormat:@"http://api.yizhong.cccwei.com/api.php?srv=2015&cid=524991&uid=0&tms=20151206220819&sig=7eca60a054f50ab0&wssig=63636f0fa161fd8a&os_type=3&version=8&city_id=2&channel=meizu&cate_id=1&scene_id=0&sort_type=1&since_id=0&tag_id=0&page_num=1&page_size=%d&coordinate=121.295084,31.13407",page_size];
            [weakSelf setDataWithURL:[NSURL URLWithString:newURL]];
            
        });
    }];
    
    
    // 给tableView添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    // 开始更新
    [self.tableView.mj_header beginRefreshing];
    
    // 显示菊花
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
}


#pragma mark - 加载数据
- (void)setDataWithURL:(NSURL *)url{
    
    [HttpRequest getWithURL:url.absoluteString params:nil success:^(id json) {
        
        self.modelArray = [FDModel modelWithDic:json];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
        switch (refreshType) {
                // 上啦刷新
            case RefreshTypeHeader:
                [self.tableView.mj_header endRefreshing];
                break;
                // 下拉加载更多
            case RefreshTypeFooter:
                [self.tableView.mj_footer endRefreshing];
                break;
            default:
                break;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      
    } failure:nil];
    
}


#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellHeightCacheEnabled) {
        return [tableView fd_heightForCellWithIdentifier:ID cacheByIndexPath:indexPath configuration:^(id cell) {
            
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:ID configuration:^(id cell) {
            
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}


#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

#pragma mark - 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FDCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(FDCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 防错处理
    if (indexPath.row > self.modelArray.count) {
        return;
    }
    cell.fd_enforceFrameLayout = YES;
    cell.model = self.modelArray[indexPath.row];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
