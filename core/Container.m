//
//  Container.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Container.h"
#import "Updater.h"
#import "Element.h"
#import "Internal.h"
#import <objc/runtime.h>
#import <YogaKit/UIView+Yoga.h>

typedef struct {
    ObjCUIPatchType type;
    ObjCUIElement *node;
    NSDictionary *props;
} ObjCUIPatch;

NSMutableDictionary *ObjCUIDiff(ObjCUIElement *oldTree, ObjCUIElement *newTree);
void dfsWalk(ObjCUIElement *oldTree, ObjCUIElement *newTree, NSUInteger *index, NSMutableDictionary *patches);
void diffChildren(NSArray<ObjCUIElement *> *oldChildren, NSArray<ObjCUIElement *> *newChildren, NSUInteger *index, NSMutableDictionary *patches);

@interface ObjCUIContainer ()

@property (nonatomic, strong) ObjCUIElement *rootElement;

@property (nonatomic, weak) UIView *mountView;


@end

const char k_objcui_container_associate;
@implementation ObjCUIContainer

@synthesize uniqueId=_uniqueId;

- (instancetype)initWithRootElement:(ObjCUIElement *)element mountPoint:(__kindof UIView *)view {
    if (self = [super init]) {
        _rootElement = element;
        _rootElement.container = self;
        _mountView = view;
        // associate with root view to avoid container dealloc
        objc_setAssociatedObject(view, &k_objcui_container_associate, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setNeedsRender];
    }
    return self;
}

- (NSString *)uniqueId {
    if (!_uniqueId) {
        _uniqueId = [NSUUID UUID].UUIDString;
    }
    return _uniqueId;
}

- (void)update {
    if (self.mountView.subviews.count == 0) {
        UIView *view = [self.rootElement render];
        [self.mountView addSubview:view];
        [self.mountView.objcui_subviews addPointer:(__bridge void *)(view)];
        [view.yoga applyLayoutPreservingOrigin:NO];
        return;
    }
    [self.mountView.objcui_subviews.allObjects.firstObject objcui_updateWithElement:self.rootElement];
    YGLayout *yoga = [self.mountView.objcui_subviews.allObjects.firstObject yoga];
    [yoga applyLayoutPreservingOrigin:NO];
}

- (void)setNeedsRender {
    [ObjCUIUpdater.shared scheduleContainer:self];
}

@end


NSMutableDictionary *ObjCUIDiff(ObjCUIElement *oldTree, ObjCUIElement *newTree) {
    NSMutableDictionary *patches = NSMutableDictionary.new;
    NSUInteger index = 0;
    dfsWalk(oldTree, newTree, &index, patches);
    return patches;
}

void dfsWalk(ObjCUIElement *oldTree, ObjCUIElement *newTree, NSUInteger *index, NSMutableDictionary *patches) {
    if (oldTree.className != newTree.className) {

    }
}

void diffChildren(NSArray<ObjCUIElement *> *oldChildren, NSArray<ObjCUIElement *> *newChildren, NSUInteger *index, NSMutableDictionary *patches) {

}

