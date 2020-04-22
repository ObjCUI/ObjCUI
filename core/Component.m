//
//  Component.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Component.h"
#import "Element.h"
#import "Internal.h"
#import "Container.h"

@interface ObjCUIComponent ()

@property (nonatomic, strong) id props;

@property (nonatomic, strong) id state;

@property (nonatomic, strong) NSArray<ObjCUIElement *> *children;

@property (nonatomic, assign) BOOL needsRender;

@end

@implementation ObjCUIComponent


- (instancetype)initWithProps:(id)props children:(NSArray<ObjCUIElement *> *)children {
    if (self = [super init]) {
        _props = props;
        _children = children;
    }
    return self;
}

- (ObjCUIElement *)render { return nil; }

- (BOOL)shouldUpdateComponent:(id)newState { return YES; }

- (BOOL)shouldUpdateProps:(id)props { return YES; }

- (void)setState:(id)state {
    if ([self shouldUpdateComponent:state] == NO) {
        return;
    }
    _state = state;
    ObjCUIElement *ele = [self render];
    [self.holder setHoldElement:ele];
}

- (void)updateProps:(id)props {
    if ([self shouldUpdateProps:props] == NO) {
        return;
    }
    _props = props;
    ObjCUIElement *ele = [self render];
    [self.holder setHoldElement:ele];
}

- (void)initState:(id)state {
    _state = state;
}

- (void)dealloc {
    
}

@end



