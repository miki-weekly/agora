//
//  slideItemTVC.m
//  agora
//
//  Created by Ethan Gates on 4/5/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "slideItemTVC.h"
#import "RootVC.h"

@implementation slideItemTVC


-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController * vc = self;
    
    while (![vc respondsToSelector:@selector(getEdgePanGesture)] && vc) {
        vc = vc.parentViewController;
    }
    
    if (!vc) {
        // view controller was presented modally most likely
        // either way is not on the VC stack so can't find ancestor root
        return;
    }
    
    RootVC * root = (RootVC*)vc;
    
    UIScreenEdgePanGestureRecognizer * gesture = [root getEdgePanGesture];
    [self.view addGestureRecognizer:gesture];
}
@end
