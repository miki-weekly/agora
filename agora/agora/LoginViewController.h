//
//  LoginViewController.h
//  agora
//
//  Created by Kalvin Loc on 3/16/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@class LoginViewController;

@protocol LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController*)loginViewController didLogin:(BOOL)login;

@end

@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate>

@property id <LoginViewControllerDelegate> loginDelegate;

@end
