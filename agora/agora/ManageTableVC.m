//
//  ManageTableVC.m
//  agora
//
//  Created by Ethan Gates on 4/5/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ManageTableVC.h"
#import "RootVC.h"
#import "ManageTableViewCell.h"
#import "ParseInterface.h"
#import "UIColor+AGColors.h"

@interface ManageTableVC()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* postsArray;

@end

@implementation ManageTableVC
// setup if anyone wants to take a crack at it
//                                  -Ethan
//                                  05/04/15

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [ParseInterface getFromParse:@"USER" withSkip:0 completion:^(NSArray *result) {
        self.postsArray = [[NSMutableArray alloc]initWithArray:result];
        [[self tableView] reloadData];
    }];
    
}

- (IBAction)clickMenu:(id)sender {
    
    RootVC * root = (RootVC*)self.parentViewController.parentViewController;
    [root snapOpen];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManageTableViewCell* tableCell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    Post* postForCell = [self.postsArray
                         objectAtIndex:indexPath.row];
        
    //[[tableCell image] setImage:[postForCell thumbnail]];
    tableCell.categoryBar.backgroundColor = [UIColor catColor:postForCell.category];
    tableCell.image.image = [postForCell thumbnail];
    tableCell.title.text = [postForCell title];
    
    return tableCell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postsArray.count;
}

@end
