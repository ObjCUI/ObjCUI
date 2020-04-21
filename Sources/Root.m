//
//  Root.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/2.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Root.h"
#import "Component.h"
#import "Element.h"
#import "Container.h"

@implementation ObjCUI

+ (Class)component {
    return ObjCUIComponent.class;
}

+ (Class)element {
    return ObjCUIElement.class;
}

+ (id)mountComponent:(__kindof ObjCUIElement *)element onView:(__kindof UIView *)rootView {
    return [ObjcUIContainer.alloc initWithRootElement:element mountPoint:rootView];
}

@end
