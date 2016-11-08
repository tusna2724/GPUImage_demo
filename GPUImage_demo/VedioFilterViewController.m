//
//  VedioFilterViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/28.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "VedioFilterViewController.h"
#import "GPUImage.h"

@interface VedioFilterViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *vedioFilterView;

@property (nonatomic, weak) GPUImageBilateralFilter *bilateraFilter; //双边滤波器
@property (nonatomic, weak) GPUImageBrightnessFilter *brightnessFilter;// 亮度筛选器

@property (nonatomic, strong) GPUImageSepiaFilter *filter;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@end

@implementation VedioFilterViewController

/*
 *GPUImage原生美颜
 步骤：创建视频源GPUImageVideoCamera
 步骤：创建最终目的源：GPUImageView
 步骤：创建滤镜组(GPUImageFilterGroup)，需要组合亮度(GPUImageBrightnessFilter)和双边滤波(GPUImageBilateralFilter)这两个滤镜达到美颜效果.
 步骤：设置滤镜组链
 步骤：设置GPUImage处理链，从数据源 => 滤镜 => 最终界面效果
 步骤：开始采集视频
 */
- (void)viewDidLoad {
    [super viewDidLoad];

//    //创建视频源
//    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080
//                                                           cameraPosition:AVCaptureDevicePositionBack];
//    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//
//    self.vedioFilterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
//    self.vedioFilterView.center = self.view.center;
//
//    // 创建美颜滤镜
//    GPUImageFilterGroup *group = [GPUImageFilterGroup new];
//
//    GPUImageBilateralFilter *bilateralFilter = [GPUImageBilateralFilter new];
//    [group addFilter:bilateralFilter];
//    _bilateraFilter = bilateralFilter;
//
//    GPUImageBrightnessFilter *brightnessFilter = [GPUImageBrightnessFilter new];
//    [group addFilter:brightnessFilter];
//    _brightnessFilter = brightnessFilter;
//
//    // 设置滤镜链
//    [_brightnessFilter addTarget:brightnessFilter];
//    [group setInitialFilters:@[bilateralFilter]];
//    group.terminalFilter = brightnessFilter;
//
//    [self.view addSubview:self.vedioFilterView];
//    [self.videoCamera addTarget:self.vedioFilterView];
////    [group addTarget:self.vedioFilterView];
//    [self.videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
