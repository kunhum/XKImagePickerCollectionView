//
//  XKPhotoCollectionViewCell.h
//  AFC
//
//  Created by Nicholas on 2017/3/24.
//  Copyright © 2017年 carlyle. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XKPhotoCollectionViewCellIdentifier @"XKPhotoCollectionViewCellIdentifier"

@interface XKPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, copy) void(^deleteCell)(XKPhotoCollectionViewCell *curCell);

//- (void)deleteCell:(void(^)())deleteHandler;

@end
