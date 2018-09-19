//
//  XKImagePickerCollectionView.h
//  TestDemo
//
//  Created by Nicholas on 2017/10/27.
//  Copyright © 2017年 nicholas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKImagePickerCollectionView : UICollectionView

///TZImagePicker
- (void)xk_presnetToTZImagePicker;

///系统的
- (void)xk_presentToImagePicker;

///获取选中的图片
- (NSArray <UIImage *>*)xk_getSelectedImages;

///添加按钮
@property (nonatomic, copy) void(^xkDidClickAddButton)(XKImagePickerCollectionView *curCV);

///选择结束
@property (nonatomic, copy) void(^xkDidFinishPickImage)(NSInteger imageCount, CGFloat viewHeight);

///选择结束
@property (nonatomic, copy) void(^xkDidDeleteImage)(NSInteger imageCount, CGFloat viewHeight);

///最大图片数
@property (nonatomic, assign) NSInteger maxImagesCount;

///图片url
@property (nonatomic, strong) NSArray <NSString *>*imageUrls;

///展位图
@property (nonatomic, strong) UIImage *placeholderImage;

///添加按钮图片
@property (nonatomic, copy)   NSString *addBtnImageName;

///itemsize
@property (nonatomic, assign) CGSize itemSize;

///item spacing
@property (nonatomic, assign) CGFloat itemSpacing;

@end
