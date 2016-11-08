//
//  VideoMusicViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/11/7.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "VideoMusicViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoMusicViewController ()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *recBtn;


@end

@implementation VideoMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 446)];
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    
    self.recBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 550, 50, 40)];
    [self.recBtn setTitle:@"合并" forState:UIControlStateNormal];
    [self.recBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.recBtn sizeToFit];
    [self.recBtn addTarget:self action:@selector(merge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recBtn];

}


- (void)merge {
    NSLog(@"点击");
    
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"莫文蔚 - 阴天" ofType:@"mp3"]];
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"keep" ofType:@"mp4"]];

    //最终合成输出
    NSString *outputFile = [document stringByAppendingPathComponent:@"1.mp4"];
    // 添加合成路径
    NSURL *outputFileURL = [NSURL fileURLWithPath:outputFile];
    //时间起点
    CMTime nextTime = kCMTimeZero;
    // 创建可变音视频组合
    AVMutableComposition *composition = [AVMutableComposition composition];


    // 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    // 视频时间
    CMTimeRange videoRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    //视频通道
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                     preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    // 把采集到写入可变轨道中
    [videoTrack insertTimeRange:videoRange ofTrack:videoAssetTrack atTime:nextTime error:nil];


    //音频采集
    AVURLAsset *musicAsset = [[AVURLAsset alloc] initWithURL:musicURL options:nil];
    CMTimeRange musicRange = videoRange;
    AVMutableCompositionTrack *musicTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                     preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *musicAssetTrack = [[musicAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [musicTrack insertTimeRange:musicRange ofTrack:musicAssetTrack atTime:nextTime error:nil];

    // 创建输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                         presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = outputFileURL;
    assetExport.shouldOptimizeForNetworkUse = YES;

    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"播放");
            [self playWithURL:outputFileURL];
        });
    }];

}


- (void)playWithURL:(NSURL *)url {
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    NSLog(@"url : %@", url);
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];

    // 播放器layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = self.imageView.frame;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;

    NSLog(@"加载");
    [self.view.layer addSublayer:layer];

    [player play];
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
