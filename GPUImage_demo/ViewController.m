//
//  ViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/25.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "ViewController.h"

#import "PictureFilterViewController.h"
#import "MovieViewController.h"
#import "LiveCameraViewController.h"
#import "VedioFilterViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *firstVC;
@property (nonatomic, copy) NSArray *firstArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstArr = @[@"图片加滤镜", @"本地视频加滤镜", @"直播(前后)美颜", @"录制(美颜)"];
    [self createTableView];
}


- (void)createTableView {
    self.firstVC = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.firstVC.delegate = self;
    self.firstVC.dataSource = self;
    [self.view addSubview:self.firstVC];
    self.firstVC.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.firstArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.firstArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureFilterViewController *picVC = [PictureFilterViewController new];
    MovieViewController *movVC = [MovieViewController new];
    LiveCameraViewController *liveVC = [LiveCameraViewController new];
    VedioFilterViewController *vedioVC = [VedioFilterViewController new];
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:picVC animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:movVC animated:YES];
    } else if (indexPath.row == 2){
        [self.navigationController pushViewController:liveVC animated:YES];
    } else {
        [self.navigationController pushViewController:vedioVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
