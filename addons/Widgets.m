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
    if (props.font != nil) {
        self.font = props.font;
    }
    if (props.textColor != nil) {
        self.textColor = props.textColor;
    }
    if (props.textAlign != nil) {
        self.textAlignment = props.textAlign.integerValue;
    }
    if (props.numberOfLines != nil) {
        self.numberOfLines = props.numberOfLines.integerValue;
    }
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
@implementation UIView (ObjcUIWidget)

- (void)objcui_widgetSetCommonProps:(ObjCUIViewProp *)props {
    if (props.backgroundColor != nil) {
        self.backgroundColor = props.backgroundColor;
    }
    if (props.alpha != nil) {
        self.alpha = props.alpha.floatValue;
    }
    if (props.cornerRadius != nil) {
        self.layer.cornerRadius = props.cornerRadius.floatValue;
    }
    if (props.clipToBounds != nil) {
        self.clipsToBounds = props.clipToBounds.boolValue;
    }
    if (props.borderWidth != nil) {
        self.layer.borderWidth = props.borderWidth.floatValue;
    }
    if (props.borderColor != nil) {
        self.layer.borderColor = props.borderColor.CGColor;
    }
    if (props.contentMode != nil) {
        self.contentMode = props.contentMode.integerValue;
    }
    if (props.onTap) {
        if (objc_getAssociatedObject(self, &k_objcui_view_tap) == nil) {
            UITapGestureRecognizer *gesture = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(objcui_ontap)];
            [self addGestureRecognizer:gesture];
        }
        objc_setAssociatedObject(self, &k_objcui_view_tap, props.onTap, OBJC_ASSOCIATION_COPY);
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
    if (props.highlighted) {
        self.highlighted = props.highlighted.boolValue;
    }
    if (props.selected) {
        self.selected = props.selected.boolValue;
    }

    [self setImage:props.image forState:UIControlStateNormal];
    [self setImage:props.highlightedImage forState:UIControlStateHighlighted];
    [self setImage:props.selectedImage forState:UIControlStateSelected];

    if (props.imageEdgeInsets) {
        self.imageEdgeInsets = props.imageEdgeInsets.UIEdgeInsetsValue;
    }
    if (props.titleEdgeInsets) {
        self.titleEdgeInsets = props.titleEdgeInsets.UIEdgeInsetsValue;
    }
    if (props.onClick) {
        objc_setAssociatedObject(self, &k_objcui_button_onclick, props.onClick, OBJC_ASSOCIATION_COPY);
        [self addTarget:self action:@selector(objcui_onclick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)objcui_onclick {
    void(^clickListener)(void) = objc_getAssociatedObject(self, &k_objcui_button_onclick);
    if (clickListener) {
        clickListener();
    }
}

@end

@implementation ObjCUIViewProp

@end

@implementation ObjCUIImageViewProp

@end

@implementation ObjCUILabelProp


@end


