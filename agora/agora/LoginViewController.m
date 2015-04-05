//
//  LoginViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "LoginViewController.h"
#import "BrowseCollectionViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init{
    if((self = [super init])){
        [self setFields:PFLogInFieldsFacebook];
        [self setFacebookPermissions:@[@"public_profile", @"user_friends", @"user_education_history"]];
        [self setDelegate:self];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    // Configure Login here, Set logo?
    //UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    //self.logInView.logo = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    if([PFUser currentUser]){                                       // Already logged in
        // BUG: FBSDK accessToken not held/refreshed by Parse
        //[[self loginDelegate] loginViewController:self didLogin:YES];
    }
}

- (void)dissmissOnLoginWithUser:(PFUser*) user{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    BrowseCollectionViewController* parent = (BrowseCollectionViewController*)[self parentViewController];
    [parent reloadData];
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    // Login procedure
    [[self loginDelegate] loginViewController:self didLogin:YES];
    
    if([user isNew]){
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if(!error){
                [[PFUser currentUser] setObject:[result objectForKey:@"id"] forKey:@"facebookId"];
                [[PFUser currentUser] save];
            }else{
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Logout procedure
    [[self loginDelegate] loginViewController:self didLogin:NO];
}

@end
