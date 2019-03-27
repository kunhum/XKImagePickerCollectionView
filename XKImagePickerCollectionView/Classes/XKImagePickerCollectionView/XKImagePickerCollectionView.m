//
//  XKImagePickerCollectionView.m
//  TestDemo
//
//  Created by Nicholas on 2017/10/27.
//  Copyright © 2017年 nicholas. All rights reserved.
//

#import "XKImagePickerCollectionView.h"
#import "IQUIView+Hierarchy.h"
#import "XKPhotoCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "UIImageView+WebCache.h"

static NSString *cellIdentifier = XKPhotoCollectionViewCellIdentifier;

@interface XKImagePickerCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray <UIImage *>*allImages;
@property (nonatomic, strong) NSMutableArray <UIImage *>*pickerImages;
@property (nonatomic, strong) NSMutableArray <UIImage *>*tzImages;

@property (nonatomic, strong) NSMutableArray   *tzAssets;

@property (nonatomic, strong) NSArray <NSURL *>*imageUrlObjects;

@end

@implementation XKImagePickerCollectionView

- (instancetype)init {
    if (self = [super init]) {
        [self initializeData];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeData];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeData];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - 初始化数据
- (void)initializeData {
    
    self.dataSource                 = self;
    self.delegate                   = self;
    self.maxImagesCount             = 3;
    self.showsHorizontalScrollIndicator = NO;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([XKPhotoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    _allImages    = [NSMutableArray array];
    _pickerImages = [NSMutableArray array];
    _tzImages     = [NSMutableArray array];
    _tzAssets     = [NSMutableArray array];
    
    self.autoresizesSubviews = NO;
}
#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image  = info[UIImagePickerControllerOriginalImage];
    
    if (self.allImages.count < self.maxImagesCount) {
        
        [self.allImages addObject:image];
        [self.pickerImages addObject:image];
        [self reloadData];
    }
    
    if (self.xkDidFinishPickImage) self.xkDidFinishPickImage(self.allImages.count,self.collectionViewLayout.collectionViewContentSize.height);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 公共方法
#pragma mark imagePicker
- (void)xk_presentToImagePicker {
    
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.allowsEditing   = NO;
    imagePicker.sourceType      = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate        = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.viewContainingController presentViewController:imagePicker animated:YES completion:nil];
//        [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    }
    
}
#pragma mark tzImagePicker
- (void)xk_presnetToTZImagePicker:(UIColor *)barTintColor {
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxImagesCount-self.pickerImages.count delegate:nil];
      imagePicker.selectedAssets = self.tzAssets;
    imagePicker.allowTakeVideo = NO;
    imagePicker.allowPickingVideo = NO;
    imagePicker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if (self.allImages.count < self.maxImagesCount) {

            for (int i = 0; i < photos.count; i++) {
                id asset = assets[i];
                if ([self.tzAssets containsObject:asset] == NO) {
                    [self.allImages addObject:photos[i]];
                    [self.tzImages addObject:photos[i]];
                }
            }

            NSMutableArray *delImages = [NSMutableArray array];
            for (int i = 0; i < self.tzAssets.count; i++) {
                id asset = self.tzAssets[i];
                if ([assets containsObject:asset] == NO) {
                    UIImage *image = self.tzImages[i];
                    [delImages addObject:image];
                }
            }

            [self.allImages removeObjectsInArray:delImages];
            [self.tzImages removeObjectsInArray:delImages];

            [self.tzAssets removeAllObjects];
            [self.tzAssets addObjectsFromArray:assets];

            [self reloadData];

            if (self.xkDidFinishPickImage) self.xkDidFinishPickImage(self.allImages.count,self.collectionViewLayout.collectionViewContentSize.height);
        }
    };
    if (barTintColor) {
        imagePicker.navigationBar.barTintColor = barTintColor;
    }
    [self.viewContainingController presentViewController:imagePicker animated:YES completion:nil];
//    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 获取选中的图片
- (NSArray<UIImage *> *)xk_getSelectedImages {
    return self.allImages;
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls ? self.imageUrls.count : (self.addBtnImageName ? self.allImages.count+1 : self.allImages.count);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XKPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.deleteButton setImage:self.itemDeleteImage forState:UIControlStateNormal];
    
    //显示图片
    if (self.imageUrls) {
        cell.deleteButton.hidden = YES;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[indexPath.item]] placeholderImage:self.placeholderImage];
    }
    else {
        cell.deleteButton.hidden = indexPath.item==self.allImages.count;
        
        if (indexPath.item == self.allImages.count && self.addBtnImageName) {
            
            cell.imageView.image = [UIImage imageNamed:self.addBtnImageName];
        }
        else {
            cell.imageView.image = self.allImages[indexPath.item];
        }
        
        __weak typeof(collectionView) weakCV = collectionView;
        __weak typeof(self) weakSelf = self;
        cell.deleteCell = ^(XKPhotoCollectionViewCell *curCell) {
            NSIndexPath *curIndexPath = [weakCV indexPathForCell:curCell];
            if ([weakSelf.pickerImages containsObject:curCell.imageView.image]) {
                //            NSLog(@"包含");
                [weakSelf.allImages removeObjectAtIndex:curIndexPath.item];
                [weakSelf.pickerImages removeObject:curCell.imageView.image];
            }
            else {
                //            NSLog(@"不包含");
                NSInteger index = [weakSelf.tzImages indexOfObject:curCell.imageView.image];
                [weakSelf.allImages removeObjectAtIndex:curIndexPath.item];
                [weakSelf.tzImages removeObject:curCell.imageView.image];
                [weakSelf.tzAssets removeObjectAtIndex:index];
                
            }
            [weakCV reloadData];
            
            if (weakSelf.xkDidDeleteImage) weakSelf.xkDidDeleteImage(weakSelf.allImages.count, weakSelf.collectionViewLayout.collectionViewContentSize.height);
        };
    }
    
    !self.xkCellConfig ?: self.xkCellConfig(cell);
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat height = CGRectGetHeight(self.bounds);
////    CGFloat gap    = (CGRectGetWidth(self.bounds)-3*height)/2.0;
//    return CGSizeMake(height, height);
    return self.itemSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    CGFloat height = CGRectGetHeight(self.bounds);
//    CGFloat gap    = (CGRectGetWidth(self.bounds)-3*height)/2.0;
//    return gap;
    return self.itemSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    CGFloat height = CGRectGetHeight(self.bounds);
//    CGFloat gap    = (CGRectGetWidth(self.bounds)-3*height)/2.0;
//    return gap;
    return self.itemSpacing;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.imageUrls) {
//        XKPhotoCollectionViewCell *cell = (XKPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
    }
    else {
        //最后一个
        if (indexPath.item == self.allImages.count && self.addBtnImageName) {
            if (self.allImages.count >= self.maxImagesCount) return;
            if (self.xkDidClickAddButton) self.xkDidClickAddButton(self);
        }
    }
    
}

#pragma mark - 设置图片
- (void)setImageUrls:(NSArray<NSString *> *)imageUrls {
    _imageUrls = imageUrls;
    NSMutableArray *urlArr = [NSMutableArray arrayWithCapacity:imageUrls.count];
    for (NSString *urlStr in imageUrls) {
        [urlArr addObject:[NSURL URLWithString:urlStr]];
    }
    self.imageUrlObjects = urlArr;
    [self reloadData];
}

#pragma mark 删除所选图片
- (void)xk_removeAllImages {
    
    [self.allImages removeAllObjects];
    [self.pickerImages removeAllObjects];
    [self.tzImages removeAllObjects];
    [self.tzAssets removeAllObjects];
    
    [self reloadData];
    
    if (self.xkDidDeleteImage) self.xkDidDeleteImage(self.allImages.count, self.collectionViewLayout.collectionViewContentSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
