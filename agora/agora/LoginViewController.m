//
//  LoginViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "LoginViewController.h"
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
    
    // TODO: Configure Login here, Set logo?
    //UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    
    UILabel * agora = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 200.0, 300.0, 70.0)];
    agora.textAlignment = NSTextAlignmentCenter;
    [agora setFont:[UIFont systemFontOfSize:60.0]];
    [agora setText:@"Agora"];
    
    self.logInView.logo = NULL;
    [self.logInView addSubview:agora];
}

- (void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (BOOL)userLoggedIn{
    PFUser* cUser = [PFUser currentUser];
    FBSDKAccessToken* cAccessToken = [FBSDKAccessToken currentAccessToken];
    NSLog(@"Parse: %@ FB: %@", cUser, cAccessToken);
    if(cUser && cAccessToken){                                       // Already logged in
        return YES;
    }else{
        return NO;
    }
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
