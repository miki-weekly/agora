//
//  ChatVC.m
//  agora
//
//  Created by Ethan Gates on 4/11/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ChatVC.h"
#import "ParseInterface.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface ChatVC()

@property NSArray* conversations;
@property NSMutableArray * names;

@end
@implementation ChatVC

//@synthesize conversations = _conversations;

-(void) setConversations:(NSArray*) convos {
        self->_conversations = convos;
        [self reloadNames];
}



-(void)viewDidLoad {
        [super viewDidLoad];
        self.title = @"Messages"; //working title
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:(213.0/256.0) alpha:1.0]];
        
        [ParseInterface getConversations:^(NSArray *result) {
                self.conversations = result;
        }];
        
        
}

-(void) reloadNames {
        self.names = [[NSMutableArray alloc]initWithCapacity:self.conversations.count];
        for (int i = 0; i < self.conversations.count; i++) {
                
                
                PFUser * otherGuy = ((Conversation*)self.conversations[i]).recipient;
                if ([otherGuy.username isEqualToString:[[PFUser currentUser] username]]) {
                        //other guy is not other guy, other guy is me
                        //otherGuy = ((Conversation*)self.conversations[i]).sender;
                        
                }
                
                FBSDKGraphRequest * request = [[FBSDKGraphRequest alloc]initWithGraphPath:[otherGuy objectForKey:@"facebookId"] parameters:NULL];
                [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        if (!error) {
                                [self.names addObject:result[@"name"]];
                                [self.tableView reloadData];
                        }
                }];
        }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"conversation"];
        
        [cell.textLabel setText:self.names[indexPath.row]];
        
        
        return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.names.count?self.names.count:0;
}


@end
