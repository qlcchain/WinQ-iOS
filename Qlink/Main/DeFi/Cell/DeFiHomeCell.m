//
//  DeFiHomeCell.m
//  Qlink
//
//  Created by Jelly Foo on 2020/5/6.
//  Copyright © 2020 pan. All rights reserved.
//

#import "DeFiHomeCell.h"
#import "DefiProjectListModel.h"
#import "NSString+RemoveZero.h"
#import "DefiProjectModel.h"
#import "DefiLineView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RequestService.h"
#import "GlobalConstants.h"

@interface DeFiHomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *usdLab;
@property (weak, nonatomic) IBOutlet UILabel *chainLab;
@property (weak, nonatomic) IBOutlet UIView *ratingBack;
@property (weak, nonatomic) IBOutlet UIView *lineBack;


@end

@implementation DeFiHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _ratingBack.layer.cornerRadius = 4;
    _ratingBack.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)config:(DefiProjectListModel *)model index:(NSInteger)index {
    _numLab.text = [NSString stringWithFormat:@"%@",@(index+1)];
    NSString *iconStr = [[model.name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    UIImage *iconImg = [UIImage imageNamed:iconStr];
    if (iconImg) {
        _icon.image = iconImg;
    } else {
        if (model.logo && model.logo.length > 0) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RequestService getPrefixUrl],model.logo]];
            [_icon sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            }];
        }
        
    }
    
    _nameLab.text = [model getShowName];
    NSString *usd_defi = [model.tvlUsd showfloatStr_Defi:2];
    _usdLab.text = [NSString stringWithFormat:@"$%@",usd_defi];
    _chainLab.text = [DefiProjectModel getRatingStr:model.rating];
    _ratingBack.backgroundColor = [DefiProjectModel getRatingColor:model.rating];
    
    
    [_lineBack.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self addLineView:model.cache];
}

- (void)addLineView:(NSArray *)arr {
    if (arr==nil || ![arr isKindOfClass:[NSArray class]] || arr.count <= 0) {
        return;
    }
    DefiLineView *view = [DefiLineView new];
    view.frame = _lineBack.bounds;
    view.inputArr = arr;
    [_lineBack addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
