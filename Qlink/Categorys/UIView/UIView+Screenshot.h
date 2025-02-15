//
//  UIView+Screenshot.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage *)screenshot;

- (UIImage *)snapshotImage;

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

- (NSData *)snapshotPDF;

@end
