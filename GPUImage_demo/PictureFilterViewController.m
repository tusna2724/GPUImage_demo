//
//  PictureFilterViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/27.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "PictureFilterViewController.h"

#import "GPUImage.h"

@interface PictureFilterViewController ()

@end

@implementation PictureFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - 1. 图片+滤镜
    UIImage *image = [UIImage imageNamed:@"iOS"];
    
    //    GPUImageGammaFilter *stretchDis = [GPUImageGammaFilter new]; // 伽马
    //    GPUImageSphereRefractionFilter *stretchDis = [GPUImageSphereRefractionFilter new];//鱼眼倒立
    GPUImageToonFilter *stretchDis = [GPUImageToonFilter new];          // 卡通
    //    GPUImageSharpenFilter *stretchDis = [GPUImageSharpenFilter new];  // 锐化
    //    GPUImageStretchDistortionFilter *stretchDis = [GPUImageStretchDistortionFilter new]; // 弹性变形
    [stretchDis forceProcessingAtSize:image.size];
    [stretchDis useNextFrameForImageCapture];
    
    // 获取数据源
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    // 添加滤镜
    [pic addTarget:stretchDis];
    // 渲染
    [pic processImage];
    
    // 获取滤镜后的image
    UIImage *afterImg = [stretchDis imageFromCurrentFramebuffer];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:afterImg];
    imageView.frame = CGRectMake(100, 100, 200, 300);
    
    [self.view addSubview:imageView];


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
