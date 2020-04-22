//
//  Updater.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ObjcUIContainer;

typedef NS_ENUM(NSUInteger, ObjcUIPatchType) {
    ObjcUIPatchTypeReplace,
    ObjcUIPatchTypeReorder,
    ObjcUIPatchTypeProps,
//    ObjcUIPatch
};

@interface ObjcUIUpdater : NSObject

+ (instancetype)shared;

- (void)scheduleContainer:(ObjcUIContainer *)container;

@end

NS_ASSUME_NONNULL_END
