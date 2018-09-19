//
//  XKPhotoCollectionViewCell.m
//  AFC
//
//  Created by Nicholas on 2017/3/24.
//  Copyright © 2017年 carlyle. All rights reserved.
//

#import "XKPhotoCollectionViewCell.h"

//typedef void(^XKPhotoCollectionViewCellBlock)();

@interface XKPhotoCollectionViewCell ()

//@property (nonatomic, copy) XKPhotoCollectionViewCellBlock deleteBlock;

@end

@implementation XKPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)delete:(id)sender {
//    if (_deleteBlock) {
//        _deleteBlock();
//    }
    if (self.deleteCell) self.deleteCell(self);
}

//- (void)deleteCell:(void (^)())deleteHandler {
//    if (deleteHandler) {
//        _deleteBlock = deleteHandler;
//    }
//}

@end
