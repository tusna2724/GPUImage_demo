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
#import "VideoMusicViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *firstVC;
@property (nonatomic, copy) NSArray *firstArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstArr = @[@"图片加滤镜", @"本地视频加滤镜", @"直播(前后)美颜", @"录制(美颜)", @"视频音频合成"];
    [self createTableView];
//    [self GCDDemoALL];
//    [self CGDDemoSync];
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
    VideoMusicViewController *vmVC = [VideoMusicViewController new];
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:picVC animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:movVC animated:YES];
    } else if (indexPath.row == 2){
        [self.navigationController pushViewController:liveVC animated:YES];
    } else  if (indexPath.row == 3){
        [self.navigationController pushViewController:vedioVC animated:YES];
    } else {
        [self.navigationController pushViewController:vmVC animated:YES];
    }
}


- (void)GCDDemoALL {
    //全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);

}

#pragma mark - 用同步函数往并发队列中添加任务
- (void)CGDDemoSync {
    dispatch_queue_t queue = dispatch_queue_create("jiandanceshi", 0);
    dispatch_sync(queue, ^{
        NSLog(@"1====%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2====%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3====%@", [NSThread currentThread]);
    });
    NSLog(@"主线程====%@", [NSThread mainThread]);
    //不开启新线程, 并发队列失去并发
}

#pragma mark - 用同步函数往串行队列中添加任务
- (void)GCDAsync {
    dispatch_queue_t queue = dispatch_queue_create("jiandanceshi", 0);
    dispatch_async(queue, ^{
        NSLog(@"");
    });
    
//    NSURL *url = []
//    NSData *data = [NSData dataWithContentsOfURL:<#(nonnull NSURL *)#>]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
