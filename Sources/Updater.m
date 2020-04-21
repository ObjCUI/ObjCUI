//
//  Updater.m
//  objcUI
//
//  Created by stephenwzl on 2020/4/7.
//  Copyright © 2020 stephenwzl. All rights reserved.
//

#import "Updater.h"
#import "Container.h"

@interface ObjcUIUpdater ()

@property (nonatomic, strong) CADisplayLink *vsync;

@property (nonatomic, strong) NSMapTable *scheduleQueue;

@end

@implementation ObjcUIUpdater

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ObjcUIUpdater *updater;
    dispatch_once(&onceToken, ^{
        updater = [ObjcUIUpdater new];
        updater.vsync = [CADisplayLink displayLinkWithTarget:updater selector:@selector(onVsyncCallback)];
        updater.vsync.paused = YES;
        [updater.vsync addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    });
    return updater;
}

- (void)onVsyncCallback {
    [[[self.scheduleQueue objectEnumerator] allObjects]
     enumerateObjectsUsingBlock:^(ObjcUIContainer *obj, NSUInteger idx, BOOL *stop) {
        [obj update];
    }];
    [self.scheduleQueue removeAllObjects];
    self.vsync.paused = YES;
}

- (void)scheduleContainer:(ObjcUIContainer *)container {
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


