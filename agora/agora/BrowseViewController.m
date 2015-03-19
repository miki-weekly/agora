//
//  BrowseViewController.m
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "BrowseViewController.h"
#import "LoginViewController.h"

@interface BrowseViewController ()

@property (strong, nonatomic) IBOutlet UIButton* loginButton;

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
}
- (IBAction)pressedLoginButton:(id)sender{
    LoginViewController *logInController = [[LoginViewController alloc] init];
    [logInController setDelegate:self];
    [logInController setFields:PFLogInFieldsFacebook];
    [logInController setFacebookPermissions:@[@"user_education_history"]];
    
    [self presentViewController:logInController animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary* userInfo = result;
            //NSString* email = userInfo[@"email"];
            //NSString* name = userInfo[@"name"];
            NSString* college = [[[[userInfo objectForKey:@"education"] objectAtIndex:2] objectForKey:@"school"] objectForKey:@"name"];
            NSLog(@"College: %@", college);
            //NSLog(@"user info: %@", result);
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    // Logout procedure
    
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

@end
