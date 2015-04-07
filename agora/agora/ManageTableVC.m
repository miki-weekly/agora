//
//  ManageTableVC.m
//  agora
//
//  Created by Ethan Gates on 4/5/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ManageTableVC.h"
#import "RootVC.h"

@implementation ManageTableVC
// setup if anyone wants to take a crack at it
//                                  -Ethan
//                                  05/04/15

- (IBAction)clickMenu:(id)sender {
    
    RootVC * root = (RootVC*)self.parentViewController.parentViewController;
    [root snapOpen];
}


@end
