//
//  Widgets.h
//  objcUI
//
//  Created by stephenwzl on 2020/4/9.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import <ObjCUI/Syntax.h>

NS_ASSUME_NONNULL_BEGIN
@class ObjCUIElement;


// ====================== View =================
OBJCUI_DECLARE_SINGLECHILD_ELEMENT(View);
OBJCUI_DECLARE_MULTICHILD_ELEMENT(View);


@interface ObjCUIViewProp : NSObject

@property (nonatomic, nullable) UIColor *backgroundColor;
@property (nonatomic, nullable) NSNumber *alpha;
@property (nonatomic, nullable) NSNumber *cornerRadius;
@property (nonatomic, nullable) NSNumber *clipToBounds;
@property (nonatomic, nullable) NSNumber *borderWidth;
@property (nonatomic, nullable) UIColor *borderColor;

@property (nonatomic, nullable) NSNumber *contentMode;

@property (nonatomic, copy, nullable) void(^onTap)(void);

@end

@interface ObjCUIView : UIView<ObjCUIWidgetPropsReceiver>

@end

// ====================== Label =================
@interface ObjCUILabelProp :ObjCUIViewProp

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, copy) UIColor *textColor;
@property (nonatomic, copy) NSNumber *textAlign;
@property (nonatomic, copy) NSNumber *numberOfLines;

@end

OBJCUI_DECLARE_SINGLECHILD_ELEMENT(Label);
@interface ObjCUILabel : UILabel<ObjCUIWidgetPropsReceiver>

@end

// ====================== ImageView =================
@interface ObjCUIImageViewProp : ObjCUIViewProp

@property (nonatomic, strong) UIImage *image;

@end

OBJCUI_DECLARE_SINGLECHILD_ELEMENT(ImageView);
@interface ObjCUIImageView : UIImageView<ObjCUIWidgetPropsReceiver>

@end

// ====================== Button =================
@interface ObjCUIButtonProp : ObjCUIViewProp

@property (nonatomic, copy) NSAttributedString *title;
@property (nonatomic, copy) NSAttributedString *highlightedTitle;
@property (nonatomic, copy) NSAttributedString *selectedTitle;

@property (nonatomic, copy) NSNumber *highlighted;
@property (nonatomic, copy) NSNumber *selected;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSValue *titleEdgeInsets;
@property (nonatomic, copy) NSValue *imageEdgeInsets;

@property (nonatomic, copy) void(^onClick)(UIButton *button);

@end

OBJCUI_DECLARE_SINGLECHILD_ELEMENT(Button);
@interface ObjCUIButton : UIButton<ObjCUIWidgetPropsReceiver>

@end

@interface UIView (ObjCUIWidget)

- (void)objcui_widgetSetCommonProps:(__kindof ObjCUIViewProp *)props;

@end


NS_ASSUME_NONNULL_END
