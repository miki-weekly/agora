//
//  ConversationView.h
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageView : UIView


@property Message * msg;
+(instancetype) viewForMessage:(Message*) msg;
-(void) reloadProfilePic;


@end
