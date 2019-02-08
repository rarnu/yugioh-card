//
//  SelectorBlock.m
//  sfunctional
//
//  Created by rarnu on 2018/9/19.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import "SelectorBlock.h"
#import <objc/runtime.h>

@implementation NSObject (BlockSEL)

- (SEL)selectorBlock:(void (^)(void))block {
    if (!block) {
        [NSException raise:@"block can not be nil" format:@"%@ selectorBlock error", self];
    }
    NSString *selName = [NSString stringWithFormat:@"selector_%p:", block];
    SEL sel = NSSelectorFromString(selName);
    class_addMethod([self class], sel, (IMP)selectorImp, "v@:@");
    objc_setAssociatedObject(self, sel, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return sel;
}

static void selectorImp(id self, SEL _cmd, id arg) {
    callback block = objc_getAssociatedObject(self, _cmd);
    if (block) {
        block();
    }
}

@end
