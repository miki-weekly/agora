//
//  ConversationVC.m
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ConversationVC.h"
#import "MessageView.h"
#import "Message.h"
#import "Conversation.h"
#import "UIColor+AGColors.h"

@interface ConversationVC()

@property NSMutableArray * messages;




@end
@implementation ConversationVC


#pragma mark - view life cycle methods

-(void)viewDidLoad {
        [super viewDidLoad];
        self.title = @"Kalvin";
        
        [self loadMessages];
        
        
}

-(void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        
        //    for (ConversationView * m in self.messages) {
        //        [m reloadProfilePic];
        //    }
        
        
}

-(void) loadMessages {
        if (!self.messages) {
                self.messages = [[NSMutableArray alloc] init];
        }
        
        Message * firstMsg = [[Message alloc]init];
        firstMsg.chatMessage = @"Hey I'm interested in buying your raybans, setup a meet?";
        firstMsg.sentDate = [NSDate date];
        firstMsg.sender = [[PFUser currentUser] objectForKey:@"facebookId"];
        
        
        MessageView * firstView = [MessageView viewForMessage:firstMsg];
        [self.messages addObject:firstView];
        
}

#pragma mark - Table View delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 10.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        return NULL;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}



@end


























