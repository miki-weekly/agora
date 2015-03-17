//
//  BrowseViewController.m
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>

#import "BrowseViewController.h"
#import "LoginViewController.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     //Creates an object for class/table TestObject
     PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
     //Creates a field of "foo" with value "bar"
     testObject[@"foo"] = @"bar";
     //Sends the object to the cloud
     [testObject saveInBackground];
     */
    
    /*
    LoginViewController *logInController = [[LoginViewController alloc] init];
    [logInController setDelegate:self];
    [logInController setFields:PFLogInFieldsFacebook];
    [logInController setFacebookPermissions:@[@"public_profile", @"email", @"user_education_history"]];
    
    [self presentViewController:logInController animated:YES completion:nil];
     */
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
