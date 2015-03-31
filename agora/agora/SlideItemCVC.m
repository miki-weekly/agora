//
//  SlideItemCVC.m
//  agora
//
//  Created by Ethan Gates on 3/30/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "SlideItemCVC.h"
#import "RootVC.h"

@implementation SlideItemCVC

-(void)viewDidLoad {
    UIViewController * vc = self;
    
    while (![vc respondsToSelector:@selector(getEdgePanGesture)]) {
        vc = vc.parentViewController;
    }
    
    RootVC * root = (RootVC*)vc;
    
    UIScreenEdgePanGestureRecognizer * gesture = [root getEdgePanGesture];
    [self.view addGestureRecognizer:gesture];
}

@end
