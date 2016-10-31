//
//  MovieViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/27.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "MovieViewController.h"
#import "GPUImage.h"

@interface MovieViewController () <GPUImageMovieDelegate>
@property (weak, nonatomic) IBOutlet GPUImageView *gpuImageView;

@property (nonatomic, strong) GPUImageMovie *movie;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#pragma mark - 2. 已有视频 + 滤镜
    /**
     *  在快手(或秒拍)下载的小视频，大小637KB，时长8s，尺寸480x640
     *
     *  http://tx2.a.yximgs.com/upic/2016/07/01/21/BMjAxNjA3MDEyMTM4MjhfNzIwMjExNF84NTc1MTQ1NjJfMl8z.mp4?tag=1-1467534669-w-0-25bdx25jov-5a63ad5ba6299f84
     */
    //    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mp4" subdirectory:nil];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"Bruno Mars - SNL Second Song" ofType:@"MP4"];
    NSURL *sampleURL = [NSURL fileURLWithPath:str];
    
    
    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
    NSLog(@"asset : %@", asset);

    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];//素材的视频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];//素材的音频轨
    NSLog(@"\n %@ \n %@", videoAssetTrack, audioAssertTrack);
    

//    AVMutableComposition *composition = [AVMutableComposition composition];//这是工程文件
//    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
//                                                                                preferredTrackID:kCMPersistentTrackID_Invalid]; //视频轨道
//    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)
//                                   ofTrack:videoAssetTrack
//                                    atTime:kCMTimeZero error:nil];//在视频轨道插入一个时间段的视频


    /**
     *  初始化 movie
     */
    _movie = [[GPUImageMovie alloc] initWithURL:sampleURL];
//    _movie = [[GPUImageMovie alloc] initWithPlayerItem:_movie.playerItem]; //这样调用可以有声音有视频，但是发现不能用writer 方法存起来。
//    _movie.playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
//    NSLog(@"_movie.playerItem : %@", _movie.playerItem);

    //    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
    //                                                                                preferredTrackID:kCMPersistentTrackID_Invalid];//音频轨道
    //    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)
    //                                   ofTrack:audioAssertTrack
    //                                    atTime:kCMTimeZero
    //                                     error:nil];//插入音频数据，否则没有声音
//    _movie.playerItem = [[AVPlayerItem alloc] initWithURL:sampleURL];
//    AVPlayer *player = [AVPlayer playerWithPlayerItem:_movie.playerItem];
//    //    [_movie addTarget:filterView];
//    _movie.playAtActualSpeed = YES;
//    _movie.shouldRepeat = true;


    /**
     *  是否重复播放
     */
    _movie.shouldRepeat = NO;
    
    /**
     *  控制GPUImageView预览视频时的速度是否要保持真实的速度。
     *  如果设为NO，则会将视频的所有帧无间隔渲染，导致速度非常快。
     *  设为YES，则会根据视频本身时长计算出每帧的时间间隔，然后每渲染一帧，就sleep一个时间间隔，从而达到正常的播放速度。
     */
    _movie.playAtActualSpeed = YES;
    
    /**
     *  设置代理 GPUImageMovieDelegate，只有一个方法 didCompletePlayingMovie
     */
    _movie.delegate = self;

    /**
     *  This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
     *
     *  这使当前视频处于基准测试的模式，记录并输出瞬时和平均帧时间到控制台
     *
     *  每隔一段时间打印： Current frame time : 51.256001 ms，直到播放或加滤镜等操作完毕
     */
    _movie.runBenchmark = YES;

    /**
     *  添加卡通滤镜
     */
    GPUImageToonFilter *filter = [GPUImageToonFilter new];//胶片效果
    //    GPUImageSharpenFilter *filter = [GPUImageSharpenFilter new];
    //    GPUImageThresholdedNonMaximumSuppressionFilter *filter = [GPUImageThresholdedNonMaximumSuppressionFilter new];
    [_movie addTarget:filter];

    /**
     *  添加显示视图
     */
    [filter addTarget:self.gpuImageView];


    /**
     *  视频处理后输出到 GPUImageView 预览时不支持播放声音，需要自行添加声音播放功能
     *
     *  开始处理并播放...
     */
    [_movie startProcessing];
}

- (void)didCompletePlayingMovie {
    NSLog(@"已完成播放");
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
