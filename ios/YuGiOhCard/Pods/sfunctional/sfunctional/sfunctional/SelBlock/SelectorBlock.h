//
//  SelectorBlock.h
//  sfunctional
//
//  Created by rarnu on 2018/9/19.
//  Copyright © 2018 rarnu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callback)(void);
@interface NSObject (BlockSEL)
-(SEL)selectorBlock:(callback)block;
@end
