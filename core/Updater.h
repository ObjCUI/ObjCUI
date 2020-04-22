//
//  Updater.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ObjCUIContainer;

typedef NS_ENUM(NSUInteger, ObjCUIPatchType) {
    ObjCUIPatchTypeReplace,
    ObjCUIPatchTypeReorder,
    ObjCUIPatchTypeProps,
//    ObjCUIPatch
};

@interface ObjCUIUpdater : NSObject

+ (instancetype)shared;

- (void)scheduleContainer:(ObjCUIContainer *)container;

@end

NS_ASSUME_NONNULL_END
