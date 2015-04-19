//
//  ConversationVC.m
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ConversationVC.h"
#import "MessageView.h"

@interface ConversationVC()

@property NSMutableArray * messages;

@end

@implementation ConversationVC


-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Kalvin";
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    for (ConversationView * m in self.messages) {
//        [m reloadProfilePic];
//    }
    
    
}

-(void) setupMessageBubbles {
    
}









@end
