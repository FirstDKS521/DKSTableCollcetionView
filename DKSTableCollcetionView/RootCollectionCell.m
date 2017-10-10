//
//  TestCollectionCell.m
//  DKSTableCollcetionView
//
//  Created by aDu on 2017/10/10.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootCollectionCell.h"

@interface RootCollectionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RootCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        self.backgroundView = _label;
        
        self.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0];
    }
    return self;
}

- (void)setTextStr:(NSString *)textStr {
    if (_textStr != textStr) {
        _textStr = textStr;
        self.label.text = textStr;
    }
}

@end
