//
//  BuySellDetailViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2019/7/8.
//  Copyright © 2019 pan. All rights reserved.
//

#import "QBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ClaimQLCType) {
    ClaimQLCTypeMiningRewards,
    ClaimQLCTypeCLAIM_COVID,
};

typedef void(^ClaimQLCSuccessBlock)(void);

@interface ClaimQLCViewController : QBaseViewController

@property (nonatomic, strong) NSString *inputCanClaimAmount;
@property (nonatomic) ClaimQLCType claimQLCType;
@property (nonatomic, copy) ClaimQLCSuccessBlock claimSuccessBlock;

@end

NS_ASSUME_NONNULL_END
