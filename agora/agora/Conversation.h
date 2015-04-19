//
//  Conversation.h
//  agora
//
//  Created by Tony Chen on 4/14/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface Conversation : NSObject

@property NSString* objectId;
@property PFUser *recipient;
@property Post *post;

@end
