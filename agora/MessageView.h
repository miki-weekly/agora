//
//  ConversationView.h
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView


+(instancetype) leftViewWithText:(NSString*) msg;
+(instancetype) rightViewWithText:(NSString*) msg;
-(void) reloadProfilePic;

@property BOOL leftSide;

@end
