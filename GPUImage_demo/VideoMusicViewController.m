//
//  VideoMusicViewController.m
//  GPUImage_demo
//
//  Created by tusna2724 on 16/11/7.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "VideoMusicViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface VideoMusicViewController () /*<AVAsynchronousKeyValueLoading>*/
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *recBtn;

@property (nonatomic, strong) UILabel *srtLabel;

@property (nonatomic, strong) NSMutableArray *subtitlesarray;
@property (nonatomic, strong) NSMutableArray *begintimearray;
@property (nonatomic, strong) NSMutableArray *endtimearray;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, retain) NSTimer *timer;
@end

@implementation VideoMusicViewController
//- (AVKeyValueStatus)statusOfValueForKey:(NSString *)key error:(NSError *__autoreleasing  _Nullable *)outError {
//    return key;
//}
//
//-(void)loadValuesAsynchronouslyForKeys:(NSArray<NSString *> *)keys completionHandler:(void (^)(void))handler {
//    
//}

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


    self.srtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.frame.size.height - 50,
                                                             self.imageView.frame.size.width, 20)];
    [self.view addSubview:self.srtLabel];

}

- (void)merge {
    NSLog(@"点击");
    
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"莫文蔚 - 阴天" ofType:@"mp3"]];
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"keep" ofType:@"mp4"]];
    
    NSURL *srtURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Westworld.S01E06.The.Adversary.1080p.HBO.WEBRip.DD5.1.H.264-monkee.简体&英文" ofType:@"srt"]];

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

// /// /// ///字幕
    AVURLAsset *srtAsset = [[AVURLAsset alloc] initWithURL:srtURL options:nil];
    CMTimeRange srtRange = videoRange;
    AVMutableCompositionTrack *srtTrack = [composition addMutableTrackWithMediaType:AVMediaTypeText
                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *srtAssryTrack = [[srtAsset tracksWithMediaType:AVMediaTypeText] firstObject];
    [srtTrack insertTimeRange:srtRange ofTrack:srtAssryTrack atTime:nextTime error:nil];

    // 创建输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:composition
                                                                         presetName:AVAssetExportPresetMediumQuality];
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputURL = outputFileURL;
    assetExport.shouldOptimizeForNetworkUse = YES;

    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playWithURL:outputFileURL srtURL:srtURL];
        });
    }];

}


- (void)playWithURL:(NSURL *)url srtURL:(NSURL *)srtUrl {

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    NSLog(@"playerItem : %@", playerItem);
    _player = [AVPlayer playerWithPlayerItem:playerItem];

    // 播放器layer
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
    layer.frame = self.imageView.frame;
    layer.videoGravity = AVLayerVideoGravityResizeAspect;


    ////AVMediaTypeSubtitle
    AVPlayerItem *srtItem = [AVPlayerItem playerItemWithURL:srtUrl];
        NSLog(@"srtItem : %@", srtItem);
    AVPlayer *srtPlayer = [AVPlayer playerWithPlayerItem:srtItem];
    AVPlayerLayer *srtLayer = [AVPlayerLayer playerLayerWithPlayer:srtPlayer];

    layer.frame = CGRectMake(0, 20, self.view.frame.size.width, 20);
    layer.videoGravity = AVLayerVideoGravityResize;
//    [self.view.layer addSublayer:srtLayer];


    NSString *srtStr = [NSString stringWithContentsOfURL:srtUrl
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
    // GBK编码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    // 解码
    NSString *string = [NSString stringWithFormat:@"%s", [srtStr cStringUsingEncoding:enc]];
    NSLog(@"string : %@", string);
    //按行分割存放到数组中
    NSArray *singlearray = [string componentsSeparatedByString:@"\n"];


    _subtitlesarray = [NSMutableArray array];
    _begintimearray = [NSMutableArray array];
    _endtimearray = [NSMutableArray array];

    //遍历存放所有行的数组
    for (NSString *ss in singlearray) {
        
        NSRange range = [ss rangeOfString:@"{\\a3}"];
        
        NSRange range2 = [ss rangeOfString:@" --> "];
        
        if (range.location != NSNotFound) {
            [_subtitlesarray addObject:[ss substringFromIndex:range.location + range.length]];
        }
        if (range2.location != NSNotFound) {
            
            NSString *beginstr = [ss substringToIndex:range2.location];
            NSString *endstr = [ss substringFromIndex:range2.location + range2.length];
            
            NSArray * arr = [beginstr componentsSeparatedByString:@":"];
            NSArray * arr1 = [arr[2] componentsSeparatedByString:@","];
            
            //将开始时间数组中的时间换化成秒为单位的
            float teim = [arr[0] floatValue] * 60*60 + [arr[1] floatValue]*60 + [arr1[0] floatValue] + [arr1[1] floatValue]/1000;
            //将float类型转化成NSNumber类型才能存入数组
            NSNumber *beginnum = [NSNumber numberWithFloat:teim];
            [_begintimearray addObject:beginnum];
            
            NSArray *array = [endstr componentsSeparatedByString:@":"];
            NSArray *arr2 = [array[2] componentsSeparatedByString:@","];
            
            //将结束时间数组中的时间换化成秒为单位的
            float fl=[array[0] floatValue] * 60*60 + [array[1] floatValue]*60 + [arr2[0] floatValue] + [arr2[1] floatValue]/1000;
            NSNumber *endnum = [NSNumber numberWithFloat:fl];
            [_endtimearray addObject:endnum];
        }
    }
//    NSLog(@" 开始时间数组-=-=-==-=%@", _begintimearray);
//    NSLog(@" 结束时间数组-=-=-==-=%@", _endtimearray);
//    NSLog(@" 字幕数组-=-=-==-=%@", _subtitlesarray);


    CATextLayer *subtitle1Text = [CATextLayer new];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    [subtitle1Text setFrame:CGRectMake(0, 100, self.view.frame.size.width, 100)];
//    [subtitle1Text setString:_subTitle1.text];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor redColor] CGColor]];
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    [overlayLayer setMasksToBounds:YES];
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    videoLayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"加载");
    // 这里看出区别了吧，我们把overlayLayer放在了videolayer的上面，所以水印总是显示在视频之上的。
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
//    composition.animationTool = [AVVideoCompositionCoreAnimationTool
//                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer
//                                 inLayer:parentLayer];

    [self.view.layer addSublayer:layer];

    [_player play];
}

//- (void)timeAction {
//    NSInteger currentSecond = CMTimeGetSeconds(_player.currentItem.currentTime);
//    
//    for (int i = 0; i<_begintimearray.count ; i++) {
//        NSInteger beginarr =  [_begintimearray[i] integerValue];
//        NSInteger endarr = [_endtimearray[i]integerValue];
//        if (currentSecond > beginarr && currentSecond< endarr) {
//            //同步字幕
//            _subtitlesLabel.text = _subtitlesarray[i];
//            NSLog(@" 字幕  %@",_subtitlesarray[i]);
//        }
//    }
//    
//    //播放完成 暂停
//    if (currentSecond == (int)CMTimeGetSeconds(self.player.currentItem.duration)) {
//        [self.player pause];
//        [self updateUI];
//    }
//
//}

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
