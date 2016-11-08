//
//  GPUImageBeautifyFilter.h
//  GPUImage_demo
//
//  Created by tusna2724 on 16/10/26.
//  Copyright © 2016年 XGY. All rights reserved.
//

#import "GPUImage.h"

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup
{
    GPUImageBilateralFilter *bilateralFilter;        // 美颜
//    GPUImageStretchDistortionFilter *bilateralFilter; // 拉伸变形
//    GPUImageAverageLuminanceThresholdFilter *bilateralFilter; // 平均亮度阈值
    GPUImageColorInvertFilter *colorInvert;         //反色
    GPUImageSepiaFilter *sepia;     //怀旧
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter; // 边缘检测
    GPUImageCombinationFilter *combinationFilter;// 组合
    GPUImageHSBFilter *hsbFilter;
}
@end
