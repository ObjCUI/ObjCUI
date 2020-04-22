//
//  Element.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Element.h"
#import "Component.h"
#import "Internal.h"
#import "Container.h"

@interface ObjCUIElement ()

@property (nonatomic, strong) Class className;

@property (nonatomic, strong) id properties;

@property (nonatomic, strong) ObjCUIStyleType *style;

@property (nonatomic, strong) NSArray<ObjCUIElement *> *children;

@property (nonatomic, assign) ObjCUIElementType elementType;

@end

@implementation ObjCUIElement

@synthesize component = _component;

+ (instancetype)elementWithType:(Class)className {
    return [self elementWithType:className children:nil];
}

+ (instancetype)elementWithType:(Class)className children:(NSArray<ObjCUIElement *> *)children {
    NSParameterAssert(![className isSubclassOfClass:UIView.class] || ![className isSubclassOfClass:ObjCUIComponent.class]);
    ObjCUIElement *ele = [ObjCUIElement new];
    ele.className = className;
    ele.elementType = [className isSubclassOfClass:ObjCUIComponent.class] ? ObjCUIElementTypeComponent : ObjCUIElementTypeRaw;
    ele.children = children;
    return ele;
}

- (ObjCUIComponent *)component {
    if (self.elementType == ObjCUIElementTypeRaw) {
        return nil;
    }
    if (!_component) {
        _component = [_className.alloc initWithProps:self.properties children:self.children];
        _component.holder = self;
    }
    return _component;
}


@synthesize holdElement = _holdElement;
- (ObjCUIElement *)holdElement {
    // when type == raw, holdElement is itself
    if (self.elementType == ObjCUIElementTypeRaw) {
        return self;
    }
    if (!_holdElement) {
        _holdElement = [self.component render];
    }
    return _holdElement;
}

- (void)setHoldElement:(ObjCUIElement *)holdElement {
    _holdElement = holdElement;
    _holdElement.container = self.container;
    [self.container setNeedsRender];
}


// completely rerender
- (UIView *)render {
    if (self.elementType == ObjCUIElementTypeRaw) {
        UIView *view = [[self.className alloc] init];
        view.objcui_element = self;
        [self.children enumerateObjectsUsingBlock:^(ObjCUIElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *v = obj.render;
            [view addSubview:v];
            [view.objcui_subviews addPointer:(__bridge void *)v];
        }];
        return view;
    }
    return [self.holdElement render];
}

- (ObjCUIElement * _Nonnull (^)(id))props {
    return ^ObjCUIElement * (id newProps) {
        self.properties = newProps;
        return self;
    };
}

- (ObjCUIElement * _Nonnull (^)(ObjCUIStyleType * _Nonnull))styles {
    return ^ObjCUIElement * (ObjCUIStyleType * style) {
        self.style = style;
        return self;
    };
}


- (void)setContainer:(ObjCUIContainer *)container {
    _container = container;
    [self.children makeObjectsPerformSelector:@selector(setContainer:) withObject:container];
}

- (void)setProperties:(id)properties {
    _properties = properties;
    // stateful component compare
    if ((_component && [self.component shouldUpdateProps:properties])) {
        [self.component updateProps:properties];
        return;
    }
    // stateless component compare
    if (![_properties isEqual:properties]) {
        [self.container setNeedsRender];
        return;
    }
}

- (BOOL)isEqual:(ObjCUIElement *)object {
    if (self == object) {
        return YES;
    }
    if (self.className != object.className) {
        return NO;
    }
    if (self.properties == nil && object.properties == nil) {
        return YES;
    }
    return [self.properties isEqual:object.properties] && [self.style isEqual:object.style];
}

- (void)dealloc {
    
}

@end


ObjCUIElement * ObjCCreateElement(Class elementType,
                                  id _Nullable props,
                                  NSArray * _Nullable children) {
    ObjCUIElement *ele = [ObjCUIElement elementWithType:elementType];
    ele.properties = props;
    ele.children = children;
    return ele;
}
