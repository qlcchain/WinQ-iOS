//
//  EntrustOrderDetailCell.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/18.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TradeOrderListModel;

static NSString *EntrustOrderDetailCellReuse = @"EntrustOrderDetailCell";
#define EntrustOrderDetailCell_Height 88

@interface EntrustOrderDetailCell : QBaseTableCell

- (void)config:(TradeOrderListModel *)model;

@end

NS_ASSUME_NONNULL_END
