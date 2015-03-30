//
//  SlideItemVC.m
//  agora
//
//  Created by Ethan Gates on 3/30/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "SlideItemVC.h"

@implementation SlideItemVC

-(void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer * gesture = [self.root getEdgePanGesture];
    [self.view addGestureRecognizer:gesture];
}

@end
