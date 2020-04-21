//
//  Root.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ObjCUIElement;

@interface ObjCUI : NSObject

// types
+ (Class)component;

+ (Class)element;

// root specification
+ (id)mountComponent:(__kindof ObjCUIElement *)element onView:(__kindof UIView *)rootView;

@end


NS_ASSUME_NONNULL_END
