//
//  ViewController.h
//  Qlink
//
//  Created by Jelly Foo on 2018/3/21.
//  Copyright © 2018年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchViewController : UIViewController

@property (nonatomic, copy) void(^loopCompletionBlock)(NSUInteger loopCountRemaining);

+ (void)showLog;
+ (NSTimeInterval)getGifDuration;

@end

