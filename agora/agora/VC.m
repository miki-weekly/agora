//
//  VC.m
//  agora
//
//  Created by Ethan Gates on 3/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "VC.h"
@interface VC()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@end
@implementation VC



-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self.scroll setContentSize:CGSizeMake(320, 1000)];
    
}

@end
