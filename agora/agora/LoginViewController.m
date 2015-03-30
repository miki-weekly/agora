//
//  LoginViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init{
    if((self = [super init])){
        [self setFields:PFLogInFieldsFacebook];
        [self setFacebookPermissions:@[@"public_profile", @"user_friends", @"user_education_history"]];
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

@end
