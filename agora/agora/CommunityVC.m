//
//  CommunityVC.m
//  agora
//
//  Created by Ethan Gates on 4/11/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>

#import "CommunityVC.h"
#import "RootVC.h"

@interface CommunityVC ()

@property IBOutlet UITableViewCell* membersCell;
@property IBOutlet UITableViewCell* postsCell;
@property IBOutlet UISwitch* postToFacebookSwitch;

@end

@implementation CommunityVC


- (void)viewDidLoad{
	[super viewDidLoad];

	_postToFacebookSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"postToFB"];

	PFQuery *query = [PFQuery queryWithClassName:@"User"];
	[query whereKey:@"playername" equalTo:@"Sean Plott"];
	[query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
		if(!error){
			[[_membersCell detailTextLabel] setText:[NSString stringWithFormat:@"%d", count]];
		}else{
		  // The request failed
		}
	}];

	query = [PFQuery queryWithClassName:@"Posts"];
	[query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
		if(!error){
			[[_postsCell detailTextLabel] setText:[NSString stringWithFormat:@"%d", count]];
		}else{
			// The request failed
		}
	}];
}

- (IBAction)clickMenu:(id)sender {
	RootVC * root = (RootVC*)self.parentViewController.parentViewController;
	[root snapOpen];
}

- (IBAction)pressedPostToFB:(id)sender{
	_postToFacebookSwitch.on = !(_postToFacebookSwitch.on);
	[[NSUserDefaults standardUserDefaults] setBool:_postToFacebookSwitch.on forKey:@"postToFB"];
}

@end
