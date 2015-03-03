//
//  ViewController.m
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Creates an object for class/table TestObject
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //Creates a field of "foo" with value "bar"
    testObject[@"foo"] = @"bar";
    //Sends the object to the cloud
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
