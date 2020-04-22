//
//  Internal.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Element.h"
#import "Component.h"
#import "Syntax.h"
NS_ASSUME_NONNULL_BEGIN

@class ObjCUIElement, ObjCUIContainer;

@interface UIView (ObjCUI)

@property (nonatomic, strong, readwrite) ObjCUIElement *objcui_element;

@property (nonatomic, strong, readonly) NSPointerArray *objcui_subviews;

- (void)objcui_updateWithElement:(ObjCUIElement *)element;

@end

@interface ObjCUIElement ()

@property (nonatomic, weak) ObjCUIContainer *container;

/// actual element node when element is stateful
@property (nonatomic, strong) ObjCUIElement *holdElement;

@end

@interface ObjCUIComponent ()

@property (nonatomic, weak) ObjCUIElement *holder;

@end

@interface ObjCUILayout ()

- (void)updateWithView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END
