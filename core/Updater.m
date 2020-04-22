//
//  Updater.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Updater.h"
#import "Container.h"

@interface ObjCUIUpdater ()

@property (nonatomic, strong) CADisplayLink *vsync;

@property (nonatomic, strong) NSMapTable *scheduleQueue;

@end

@implementation ObjCUIUpdater

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ObjCUIUpdater *updater;
    dispatch_once(&onceToken, ^{
        updater = [ObjCUIUpdater new];
        updater.vsync = [CADisplayLink displayLinkWithTarget:updater selector:@selector(onVsyncCallback)];
        updater.vsync.paused = YES;
        [updater.vsync addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    });
    return updater;
}

- (void)onVsyncCallback {
    [[[self.scheduleQueue objectEnumerator] allObjects]
     enumerateObjectsUsingBlock:^(ObjCUIContainer *obj, NSUInteger idx, BOOL *stop) {
        [obj update];
    }];
    [self.scheduleQueue removeAllObjects];
    self.vsync.paused = YES;
}

- (void)scheduleContainer:(ObjCUIContainer *)container {
    [self.scheduleQueue setObject:container forKey:container.uniqueId];
    self.vsync.paused = NO;
}

- (NSMapTable *)scheduleQueue {
    if (!_scheduleQueue) {
        _scheduleQueue = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn
                                       valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _scheduleQueue;
}

@end


