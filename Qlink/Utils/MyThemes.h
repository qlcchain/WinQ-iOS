//
//  MyThemes.h
//  SwiftTheme
//
//  Created by Gesen on 16/5/26.
//  Copyright © 2016年 Gesen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MyThemesTypeBlue = 0,
    MyThemesTypePurple,
} MyThemesType;

@interface MyThemes : NSObject

+ (void)switchTo:(MyThemesType)type;
+ (void)switchToNext;
//+ (void)switchNight:(BOOL)isToNight;
//+ (BOOL)isNight;

+ (void)restoreLastTheme;
+ (void)saveLastTheme;

@end
