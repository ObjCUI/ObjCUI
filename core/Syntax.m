//
//  Syntax.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/8.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Syntax.h"
#import <UIKit/UIKit.h>
#import "Element.h"
#import "Component.h"
#import "Internal.h"
#import <YogaKit/UIView+Yoga.h>
#import <objc/message.h>
#import <objc/runtime.h>

@interface ObjCUIStyleType ()

@property (nonatomic, strong) NSMutableDictionary *changes;

@end

@implementation ObjCUIStyleType

- (instancetype)init {
    if (self = [super init]) {
        _changes = NSMutableDictionary.new;
    }
    return self;
}

OBJCUI_IMP_YOGA_PROPERTY(YGDirection, Direction, direction)
OBJCUI_IMP_YOGA_PROPERTY(YGFlexDirection, FlexDirection, flexDirection)
OBJCUI_IMP_YOGA_PROPERTY(YGJustify, JustifyContent, justifyContent)
OBJCUI_IMP_YOGA_PROPERTY(YGAlign, AlignContent, alignContent)
OBJCUI_IMP_YOGA_PROPERTY(YGAlign, AlignItems, alignItems)
OBJCUI_IMP_YOGA_PROPERTY(YGAlign, AlignSelf, alignSelf)
OBJCUI_IMP_YOGA_PROPERTY(YGPositionType, Position, position)
OBJCUI_IMP_YOGA_PROPERTY(YGWrap, FlexWrap, flexWrap)
OBJCUI_IMP_YOGA_PROPERTY(YGOverflow, Overflow, overflow)
OBJCUI_IMP_YOGA_PROPERTY(YGDisplay, Display, display)
//
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, FlexGrow, flexGrow)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, FlexShrink, flexShrink)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, FlexBasis, flexBasis)
//
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Left, left)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Top, top)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Right, right)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Bottom, bottom)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Start, start)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, End, end)
//
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginLeft, marginLeft)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginTop, marginTop)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginRight, marginRight)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginBottom, marginBottom)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginStart, marginStart)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginEnd, marginEnd)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginHorizontal, marginHorizontal)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MarginVertical, marginVertical)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Margin, margin)
//
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingLeft, paddingLeft)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingTop, paddingTop)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingRight, paddingRight)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingBottom, paddingBottom)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingStart, paddingStart)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingEnd, paddingEnd)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingHorizontal, paddingHorizontal)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, PaddingVertical, paddingVertical)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Padding, padding)
//
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderLeftWidth, borderLeftWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderTopWidth, borderTopWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderRightWidth, borderRightWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderBottomWidth, borderBottomWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderStartWidth, borderStartWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderEndWidth, borderEndWidth)
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, BorderWidth, borderWidth)
//
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Width, width)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, Height, height)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MinWidth, minWidth)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MinHeight, minHeight)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MaxWidth, maxWidth)
OBJCUI_IMP_YOGA_PROPERTY(YGValue, MaxHeight, maxHeight)
//
OBJCUI_IMP_YOGA_PROPERTY(CGFloat, AspectRatio, aspectRatio)


- (void)updateWithView:(UIView *)view {
    if (self.changes.count == 0) {
        return;
    }

    [view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
        if (layout.isEnabled == NO) {
            layout.isEnabled = YES;
        }
        [self.changes enumerateKeysAndObjectsUsingBlock:^(NSString *setter, NSValue *value, BOOL * _Nonnull stop) {
            SEL selector = NSSelectorFromString(setter);
            if (strcmp(@encode(int), value.objCType) == 0) { // enums
                int actual;
                [value getValue:&actual];
                ((void(*)(id, SEL, int))objc_msgSend)(layout, selector, actual);
            } else if (strcmp(@encode(YGValue), value.objCType) == 0) {
                YGValue actual;
                [value getValue:&actual];
                ((void(*)(id, SEL, YGValue))objc_msgSend)(layout, selector, actual);
            } else if (strcmp(@encode(CGFloat), value.objCType) == 0) {
                CGFloat actual;
                [value getValue:&actual];
                ((void(*)(id, SEL, CGFloat))objc_msgSend)(layout, selector, actual);
            }
        }];
    }];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    return [self.changes isEqualToDictionary:[(ObjCUIStyleType *)object changes]];
}

@end


ObjCUIStyleType* ObjCUIStyleBuilder(void(^builder)(ObjCUIStyleType * style)) {
    ObjCUIStyleType *style = ObjCUIStyleType.new;
    builder(style);
    return style;
}
