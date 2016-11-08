//
//  LiveCameraViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/27.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "LiveCameraViewController.h"

#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LiveCameraViewController ()

@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *beautifyButton;

@property (nonatomic, strong) UIButton *recBtn;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic , strong) UILabel  *mLabel;
@property (nonatomic , assign) long     mLabelTime;
@property (nonatomic, strong) NSTimer *mTimer;

@property (nonatomic , strong) CADisplayLink *mDisplayLink;

@end

@implementation LiveCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma mark - 3. 直播(前后)美颜
    // 前置
    //    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
    //                                                           cameraPosition:AVCaptureDevicePositionFront];
    // 后置
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                           cameraPosition:AVCaptureDevicePositionBack];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    self.videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterView.center = self.view.center;

    // 响应链
    [self.view addSubview:self.filterView];
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];

    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautifyButton.backgroundColor = [UIColor whiteColor];
    [self.beautifyButton setTitle:@"打开" forState:UIControlStateNormal];
    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
    [self.beautifyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautifyButton];
    self.beautifyButton.frame = CGRectMake(100, 550, 50, 40);

    self.recBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 550, 50, 40)];
    [self.recBtn setTitle:@"录制" forState:UIControlStateNormal];
    [self.recBtn sizeToFit];
    [self.recBtn addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.recBtn];
}


- (void)beautify {
    if (self.beautifyButton.selected) {
        //关闭
        self.beautifyButton.selected = NO;
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.filterView];
//        UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo)
//        UISaveVideoAtPathToSavedPhotosAlbum()
    } else {
        //打开
        self.beautifyButton.selected = YES;
        [self.videoCamera removeAllTargets];
        GPUImageBeautifyFilter *beautifyFilter = [GPUImageBeautifyFilter new];
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
    }
}

- (void)record:(UIButton *)sender {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Document/movie.mp4"];
    NSURL *url = [NSURL fileURLWithPath:pathToMovie];
    if ([sender.currentTitle isEqualToString:@"录制"]) {
        [sender setTitle:@"结束" forState:UIControlStateNormal];
        NSLog(@"start record");

        unlink([pathToMovie UTF8String]);
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:url size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];

        _mLabelTime = 0;
        _mLabel.hidden = YES;
        self.mTimer = nil;
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

    } else {

        [sender setTitle:@"录制" forState:UIControlStateNormal];
        NSLog(@"End recording");

        _mLabel.hidden = YES;
        if (_mTimer) {
            [_mTimer invalidate];
        }
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;


        PHAssetChangeRequest *library = [PHAssetChangeRequest new];
//        ALAssetsLibrary *library = [ALAssetsLibrary new];
//        PHPhotoLibrary *library = [PHPhotoLibrary new];

        // 获取所有资源的集合，并按资源的创建时间排序
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        NSLog(@"assetsFetchResults : %@", assetsFetchResults);

        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie)) {
//            [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   if (error) {
//                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败"
//                                                                       message:nil
//                                                                      delegate:nil
//                                                             cancelButtonTitle:@"OK"
//                                                             otherButtonTitles:nil];
//                       [alert show];
//                   } else {
//                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功"
//                                                                       message:nil
//                                                                      delegate:self
//                                                             cancelButtonTitle:@"OK"
//                                                             otherButtonTitles:nil];
//                       [alert show];
//                   }
//               });
//            }];
        }
        

    }
}



- (void)onTimer:(id)sender {
    _mLabel.text = [NSString stringWithFormat:@"录制时间 : %ld", _mLabelTime++];
    [_mLabel sizeToFit];
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
