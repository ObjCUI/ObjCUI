//
//  Container.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ObjCUIElement;

@interface ObjcUIContainer : NSObject

@property (nonatomic, readonly) NSString *uniqueId;

- (instancetype)initWithRootElement:(ObjCUIElement *)element mountPoint:(__kindof UIView *)view;

- (void)update;

- (void)setNeedsRender;

@end

NS_ASSUME_NONNULL_END
