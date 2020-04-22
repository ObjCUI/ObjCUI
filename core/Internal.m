//
//  Internal.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Internal.h"
#import "Syntax.h"
#import "Widgets.h"
#import <objc/runtime.h>
#import <YogaKit/UIView+Yoga.h>

@implementation UIView (ObjCUI)

const char k_element;
- (ObjCUIElement *)objcui_element {
    return objc_getAssociatedObject(self, &k_element);
}

- (void)setObjcui_element:(ObjCUIElement *)objcui_element {
    objc_setAssociatedObject(self, &k_element, objcui_element, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // update properties with split protocol
    if ([self conformsToProtocol:@protocol(ObjCUIViewPropsReceiver)] &&
        [self respondsToSelector:@selector(objcui_updateWithProps:)]) {
        [(id<ObjCUIViewPropsReceiver>)self objcui_updateWithProps:objcui_element.properties];
    }
    // update style
    self.yoga.isEnabled = YES;
    [objcui_element.style updateWithView:self];
}

const char k_subviews;
- (NSPointerArray *)objcui_subviews {
    NSPointerArray *arr = objc_getAssociatedObject(self, &k_subviews);
    if (arr == nil) {
        arr = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
        objc_setAssociatedObject(self, &k_subviews, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [arr compact];
    return arr;
}


// 这种更新算法目前无法应对以下情况
// 1. children中某个不需要重新渲染的 element的位置改变了，前面插入了新的 element
// 那么这个 element就会被替换成新的 element，造成很大的更新变动，需要更合适的 diff算法
- (void)objcui_updateWithElement:(ObjCUIElement *)element {
    // 判断是否需要替换
    element = element.holdElement;
    ObjCUIElement *oriElement = self.objcui_element;
    NSAssert(oriElement != nil, @"origin retained element should not be nil");
    if (oriElement.className != element.className) {
        UIView *view = [element render];
        [self.superview insertSubview:view aboveSubview:self];
        [self.superview.objcui_subviews insertPointer:(__bridge void * _Nullable)(view) atIndex:[self.superview.subviews indexOfObject:self]];
        [self removeFromSuperview];
        return;
    }
    // 非替换，判断 element是否改变
    if (![oriElement isEqual:element]) {
        [self setObjcui_element:element];
    }
    [element.holdElement.children enumerateObjectsUsingBlock:^(ObjCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subview = self.objcui_subviews.allObjects.count > idx ? [self.objcui_subviews.allObjects objectAtIndex:idx] : nil;
        // 这里其实会有一种情况，如果前后两个视图仅仅只是换了位置，有可能会引起重排p
        if (subview) {
            [subview objcui_updateWithElement:obj];
        } else {
            UIView *v = obj.holdElement.render;
            [self insertSubview:v atIndex:idx];
            [self.objcui_subviews addPointer:(__bridge void * _Nullable)(v)];
        }
    }];
    // 防止 element.children 数量比 self.subviews 少
    if (element.holdElement.children.count < self.objcui_subviews.allObjects.count) {
        NSInteger count = self.objcui_subviews.allObjects.count - element.holdElement.children.count;
        NSArray *views = [self.objcui_subviews.allObjects subarrayWithRange:NSMakeRange(element.holdElement.children.count, count)];
        [views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

}

@end
