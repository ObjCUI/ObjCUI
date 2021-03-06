//
//  Element.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ObjCUIComponent, ObjCUILayout;

typedef NS_ENUM(NSUInteger, ObjCUIElementType) {
    // raw type means element directly points to a UIView
    ObjCUIElementTypeRaw,
    // component type means element points to a ObjCUIComponent
    ObjCUIElementTypeComponent,
};

@interface ObjCUIElement : NSObject

@property (nonatomic, readonly) Class className;

@property (nonatomic, readonly) id properties;

@property (nonatomic, readonly) ObjCUILayout *style;

@property (nonatomic, readonly) NSArray<ObjCUIElement *> *children;

@property (nonatomic, readonly, assign) ObjCUIElementType elementType;

@property (nonatomic, readonly, strong) ObjCUIComponent *component;

+ (instancetype)elementWithType:(Class)className;

+ (instancetype)elementWithType:(Class)className children:(NSArray<ObjCUIElement *> * _Nullable)children;

/// actually render element into a UIView
- (__kindof UIView *)render;

/// set new static props
- (ObjCUIElement *(^)(id))props;

/// set new static layouts
- (ObjCUIElement *(^)(ObjCUILayout *))layouts;

@end

extern ObjCUIElement * ObjCCreateElement(Class elementType, id _Nullable props, NSArray * _Nullable children);

NS_ASSUME_NONNULL_END
