//
//  KKAlertActionView.m
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import "KKAlertActionView.h"

@interface KKAlertActionView ()
@property (nonatomic, strong) NSMutableArray<KKAlertAction *> *actions;
@end

@implementation KKAlertActionView
+ (instancetype)alert {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.kkStyle = UIAlertControllerStyleAlert;
        self.actions = @[].mutableCopy;
    }
    return self;
}

#pragma mark - Promise
///=============================================================================
/// @name Promise
///=============================================================================

- (KKAlertActionView *(^)(id title))title {
    return ^id(id title) {
        self.kkTitle = title;
        return self;
    };
}

- (KKAlertActionView *(^)(id message))message {
    return ^id(id message) {
        self.kkMessage = message;
        return self;
    };
}

- (KKAlertActionView *(^)(UIAlertControllerStyle style))style {
    return ^id(UIAlertControllerStyle style) {
        self.kkStyle = style;
        return self;
    };
}

- (KKAlertActionView *(^)(KKAlertAction *action))addAction {
    return ^id(KKAlertAction *action) {
        [self kkAddAction:action];
        return self;
    };
}

- (KKAlertActionView *(^)(id action))addActions {
    return ^id(id action) {
        if ([action isKindOfClass:[NSArray class]]) {
            [self kkAddActions:action];
        } else {
            [self kkAddAction:action];
        }
        return self;
    };
}

- (void(^)(UIViewController *vc))show {
    return ^void(UIViewController *vc) {
        /*! 让可以直接处理 block 而不弹框 */
        if (self.actions.count && self.actions[0].kkNoAlert) {
            if (self.actions[0].block) {
                self.actions[0].block(nil);
            }
            return;
        }
        /*! 弹框 */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.kkTitle message:self.kkMessage preferredStyle:self.kkStyle];
        [self.actions kkEach:^(KKAlertAction *each) {
            [alert addAction:[self alertAction:each]];
        }];
        if (!vc) {
            vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [vc presentViewController:alert animated:YES completion:^{}];
    };
}

- (UIAlertAction *)alertAction:(KKAlertAction *)each {
    if ([each.kkTitle isKindOfClass:[NSString class]]) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:each.kkTitle style:each.kkStyle handler:each.block];
        if (each.kkTextColor) [action setValue:each.kkTextColor forKey:@"titleTextColor"];
        return action;
    } else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:each.kkStyle handler:each.block];
        [action setValue:each.kkTitle forKey:@"attributedTitle"];
        return action;
    }
}

- (void)kkAddAction:(KKAlertAction *)action {
    [self.actions addObject:action];
}

- (void)kkAddActions:(NSArray<KKAlertAction *> *)actions {
    [self.actions addObjectsFromArray:actions];
}

@end

@implementation KKAlertAction

+ (instancetype)action {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.kkStyle = UIAlertActionStyleDefault;
    }
    return self;
}

- (KKAlertAction *(^)(id title))title {
    return ^id(id title) {
        self.kkTitle = title;
        return self;
    };
}

- (KKAlertAction *(^)(UIAlertActionStyle style))style {
    return ^id(UIAlertActionStyle style) {
        self.kkStyle = style;
        return self;
    };
}

- (KKAlertAction *(^)(UIColor *textColor))textColor {
    return ^id(UIColor *textColor) {
        self.kkTextColor = textColor;
        return self;
    };
}

- (KKAlertAction *(^)(BOOL noAlert))noAlert {
    return ^id(BOOL noAlert) {
        self.kkNoAlert = noAlert;
        return self;
    };
}

- (KKAlertAction *(^)(void (^)(UIAlertAction *action)))handler {
    return ^id(void (^block)(UIAlertAction *action)) {
        self.block = block;
        return self;
    };
}

- (KKAlertAction *(^)(NSString *uri))pushHandler {
    return ^id(NSString *uri) {
        return self.handler(^(UIAlertAction *action) {
            if (uri && uri.length) {
                [KKRouter pushUri:uri];
            }
        });
    };
}

- (KKAlertAction *(^)(NSString *uri))pushNoAlertHandler {
    return ^id(NSString *uri) {
        self.kkNoAlert = YES;
        return self.handler(^(UIAlertAction *action) {
            if (uri && uri.length) {
                [KKRouter pushUri:uri];
            }
        });
    };
}

#pragma mark - 常用 Action
///=============================================================================
/// @name 常用 Action
///=============================================================================
/*! 取消 */
+ (KKAlertAction *)cancelAction {
    return [KKAlertAction action].title(@"取消")
    .handler(^(UIAlertAction *action) {});
}

/*! 取消 */
+ (KKAlertAction *(^)(NSString *title))titleAction {
    return ^id(NSString *title) {
        return [KKAlertAction action].title(title)
        .handler(^(UIAlertAction *action) {});;
    };
}

/*! 联系客服 */
+ (KKAlertAction *)contactAction {
    return [KKAlertAction action].title(@"联系客服")
    .handler(^(UIAlertAction *action) {
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", @"4000810707"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
    });
}


@end
