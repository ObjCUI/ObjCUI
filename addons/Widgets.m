//
//  Widgets.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/9.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Widgets.h"
#import "Element.h"
#import <objc/runtime.h>

// preset components
OBJCUI_IMP_MULTICHILD_ELEMENT(ObjCUIView, View);
OBJCUI_IMP_SINGLECHILD_ELEMENT(ObjCUIView, View);

@implementation ObjCUIView

- (void)objcui_updateWithProps:(id)props {
    [self objcui_widgetSetCommonProps:props];
}

@end

OBJCUI_IMP_SINGLECHILD_ELEMENT(ObjCUILabel, Label);
@implementation ObjCUILabel

- (void)objcui_updateWithProps:(ObjCUILabelProp *)props {
    [self objcui_widgetSetCommonProps:props];
    self.text = props.text;
    self.font = props.font != nil ? props.font : [UIFont systemFontOfSize:12];
    self.textColor = props.textColor ?: UIColor.blackColor;
    self.textAlignment = props.textAlign ? props.textAlign.integerValue : NSTextAlignmentLeft;
    self.numberOfLines = props.numberOfLines ? props.numberOfLines.integerValue : 0;
}

@end

OBJCUI_IMP_SINGLECHILD_ELEMENT(ObjCUIImageView, ImageView);
@implementation ObjCUIImageView

- (void)objcui_updateWithProps:(ObjCUIImageViewProp *)props {
    [self objcui_widgetSetCommonProps:props];
    if (props.image != nil) {
        self.image = props.image;
    }
}

@end

const char k_objcui_view_tap;
@implementation UIView (ObjCUIWidget)

- (void)objcui_widgetSetCommonProps:(ObjCUIViewProp *)props {
    self.backgroundColor = props.backgroundColor ?: UIColor.clearColor;
    self.alpha = props.alpha != nil ? props.alpha.floatValue : 1;
    self.layer.cornerRadius = props.cornerRadius != nil ? props.cornerRadius.floatValue : 0;
    self.clipsToBounds = props.clipToBounds ? props.clipToBounds.boolValue : NO;
    self.layer.borderWidth = props.borderWidth ? props.borderWidth.floatValue : 0;
    self.layer.borderColor = props.borderColor ? props.borderColor.CGColor : UIColor.clearColor.CGColor;
    self.contentMode = props.contentMode ? props.contentMode.integerValue : UIViewContentModeScaleToFill;
    if (props.onTap) {
        if (objc_getAssociatedObject(self, &k_objcui_view_tap) == nil) {
            UITapGestureRecognizer *gesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(objcui_ontap)];
            [self addGestureRecognizer:gesture];
        }
        objc_setAssociatedObject(self, &k_objcui_view_tap, props.onTap, OBJC_ASSOCIATION_COPY);
    } else {
        objc_setAssociatedObject(self, &k_objcui_view_tap, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)objcui_ontap {
    void(^ontap)(void) = objc_getAssociatedObject(self, &k_objcui_view_tap);
    if (ontap) {
        ontap();
    }
}

@end

@implementation ObjCUIButton

const char k_objcui_button_onclick;
- (void)objcui_updateWithProps:(ObjCUIButtonProp *)props {
    [self objcui_widgetSetCommonProps:props];
    [self setAttributedTitle:props.title forState:UIControlStateNormal];
    [self setAttributedTitle:props.highlightedTitle forState:UIControlStateHighlighted];
    [self setAttributedTitle:props.selectedTitle forState:UIControlStateSelected];
    self.highlighted = self.highlighted ? props.highlighted.boolValue : NO;
    self.selected = props.selected ? props.selected.boolValue : NO;

    [self setImage:props.image forState:UIControlStateNormal];
    [self setImage:props.highlightedImage forState:UIControlStateHighlighted];
    [self setImage:props.selectedImage forState:UIControlStateSelected];

    self.imageEdgeInsets = props.imageEdgeInsets ? props.imageEdgeInsets.UIEdgeInsetsValue : UIEdgeInsetsZero;
    self.titleEdgeInsets = props.titleEdgeInsets ? props.titleEdgeInsets.UIEdgeInsetsValue : UIEdgeInsetsZero;
    if (props.onClick) {
        objc_setAssociatedObject(self, &k_objcui_button_onclick, props.onClick, OBJC_ASSOCIATION_COPY);
        [self addTarget:self action:@selector(objcui_onclick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        objc_setAssociatedObject(self, &k_objcui_button_onclick, nil, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (void)objcui_onclick {
    void(^clickListener)(UIButton *) = objc_getAssociatedObject(self, &k_objcui_button_onclick);
    if (clickListener) {
        clickListener(self);
    }
}

@end

@implementation ObjCUIViewProp

@end

@implementation ObjCUIImageViewProp

@end

@implementation ObjCUILabelProp


@end


