//
//  Component.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ObjCUIElement;

@interface ObjCUIComponent : NSObject

@property (nonatomic, readonly) id props;

@property (nonatomic, readonly, strong, nullable) id state;

- (instancetype)initWithProps:(id _Nullable)props children:(NSArray<ObjCUIElement *> * _Nullable)children;

- (void)setState:(id _Nullable)state;

/// initialize state without update component
- (void)initState:(id _Nullable)state;

- (__kindof ObjCUIElement * _Nullable)render;

// hooks
- (BOOL)shouldUpdateComponent:(id)newState;

/// not implemented
- (BOOL)shouldUpdateProps:(id)props;

- (void)updateProps:(id)props;

@end


NS_ASSUME_NONNULL_END
