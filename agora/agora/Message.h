//
//  Message.h
//  agora
//
//  Created by Tony Chen on 4/14/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conversation.h"

@interface Message : NSObject

@property Conversation *parent;
@property NSString *chatMessage;
@property NSDate *sentDate;

@end
