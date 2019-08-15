//
//  MessageCenterListModel.h
//  DigitalCurrency
//
//  Created by Michael on 2019/1/17.
//  Copyright © 2019年 bibidai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageCenterListModel : NSObject
//
@property (nonatomic, strong) NSString * noticeID;
//
@property (nonatomic, strong) NSString * noticeTitle;
//
@property (nonatomic, strong) NSString * noticeContent;
//
@property (nonatomic, assign) BOOL noticeIsRead;
//
@property (nonatomic, strong) NSString * sentTime;
@end

NS_ASSUME_NONNULL_END
