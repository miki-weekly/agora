//
//  ChatVC.m
//  agora
//
//  Created by Ethan Gates on 4/11/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ChatVC.h"

@implementation ChatVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Messages"; //working title
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:(213.0/256.0) alpha:1.0]];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"conversation"];
    [cell.textLabel setText:@"Ethan"];
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


@end
