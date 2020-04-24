//
//  Syntax.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/8.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YogaKit/UIView+Yoga.h>
#define OBJCUI_FUNC_OVERLOAD __attribute__((__overloadable__))
#define OBJCUI_DECLARE_SINGLECHILD_ELEMENT(short_hand) OBJCUI_FUNC_OVERLOAD extern ObjCUIElement * short_hand(void);
#define OBJCUI_DECLARE_MULTICHILD_ELEMENT(short_hand) OBJCUI_FUNC_OVERLOAD NS_REQUIRES_NIL_TERMINATION extern ObjCUIElement * short_hand(id child, ...);

#define OBJCUI_IMP_SINGLECHILD_ELEMENT(expected_type, short_hand) OBJCUI_FUNC_OVERLOAD ObjCUIElement * short_hand(void) {\
    return ObjCCreateElement(expected_type.class, nil, nil);\
}

#define OBJCUI_IMP_MULTICHILD_ELEMENT(expected_type, short_hand) OBJCUI_FUNC_OVERLOAD ObjCUIElement * short_hand(id child, ...) {\
    NSArray *children;\
    if ([child isKindOfClass:NSArray.class]) {\
        children = child;\
    } else if (child) {\
        NSMutableArray *temp = [NSMutableArray new];\
        [temp addObject:child];\
        va_list args;\
        va_start(args, child);\
        ObjCUIElement *arg;\
        while ((arg = va_arg(args, ObjCUIElement *))) {\
            [temp addObject:arg];\
        }\
        children = temp.copy;\
    }\
    return ObjCCreateElement(expected_type.class, nil, children);\
}

#define OBJCUI_IMP_YOGA_PROPERTY(Type, CapitalizedName, NormalName) - (void)set##CapitalizedName:(Type)NormalName {\
    _##NormalName=NormalName;\
    [self.changes setObject:[NSValue value:&_##NormalName withObjCType:@encode(Type)] forKey:@"set"#CapitalizedName":"];\
}

NS_ASSUME_NONNULL_BEGIN
@class ObjCUIElement;

@protocol ObjCUIWidgetPropsReceiver <NSObject>

@required
- (void)objcui_updateWithProps:(id)props;

@end


@interface ObjCUILayout : NSObject

@property (nonatomic, assign) YGDirection direction;
@property (nonatomic, assign) YGFlexDirection flexDirection;
@property (nonatomic, assign) YGJustify justifyContent;
@property (nonatomic, assign) YGAlign alignContent;
@property (nonatomic, assign) YGAlign alignItems;
@property (nonatomic, assign) YGAlign alignSelf;
@property (nonatomic, assign) YGPositionType position;
@property (nonatomic, assign) YGWrap flexWrap;
@property (nonatomic, assign) YGOverflow overflow;
@property (nonatomic, assign) YGDisplay display;

@property (nonatomic, assign) CGFloat flexGrow;
@property (nonatomic, assign) CGFloat flexShrink;
@property (nonatomic, assign) YGValue flexBasis;

@property (nonatomic, assign) YGValue left;
@property (nonatomic, assign) YGValue top;
@property (nonatomic, assign) YGValue right;
@property (nonatomic, assign) YGValue bottom;
@property (nonatomic, assign) YGValue start;
@property (nonatomic, assign) YGValue end;

@property (nonatomic, assign) YGValue marginLeft;
@property (nonatomic, assign) YGValue marginTop;
@property (nonatomic, assign) YGValue marginRight;
@property (nonatomic, assign) YGValue marginBottom;
@property (nonatomic, assign) YGValue marginStart;
@property (nonatomic, assign) YGValue marginEnd;
@property (nonatomic, assign) YGValue marginHorizontal;
@property (nonatomic, assign) YGValue marginVertical;
@property (nonatomic, assign) YGValue margin;

@property (nonatomic, assign) YGValue paddingLeft;
@property (nonatomic, assign) YGValue paddingTop;
@property (nonatomic, assign) YGValue paddingRight;
@property (nonatomic, assign) YGValue paddingBottom;
@property (nonatomic, assign) YGValue paddingStart;
@property (nonatomic, assign) YGValue paddingEnd;
@property (nonatomic, assign) YGValue paddingHorizontal;
@property (nonatomic, assign) YGValue paddingVertical;
@property (nonatomic, assign) YGValue padding;

@property (nonatomic, assign) CGFloat borderLeftWidth;
@property (nonatomic, assign) CGFloat borderTopWidth;
@property (nonatomic, assign) CGFloat borderRightWidth;
@property (nonatomic, assign) CGFloat borderBottomWidth;
@property (nonatomic, assign) CGFloat borderStartWidth;
@property (nonatomic, assign) CGFloat borderEndWidth;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) YGValue width;
@property (nonatomic, assign) YGValue height;
@property (nonatomic, assign) YGValue minWidth;
@property (nonatomic, assign) YGValue minHeight;
@property (nonatomic, assign) YGValue maxWidth;
@property (nonatomic, assign) YGValue maxHeight;

// Yoga specific properties, not compatible with flexbox specification
@property (nonatomic, assign) CGFloat aspectRatio;


@end

extern ObjCUILayout* ObjCUILayoutBuilder(void(^builder)(ObjCUILayout *style));

#define OBJCUI_STYLE_DEFINE_PROPERTY(property_name) @property (nonatomic, readonly) ObjCUILayout* property_name;



NS_ASSUME_NONNULL_END
