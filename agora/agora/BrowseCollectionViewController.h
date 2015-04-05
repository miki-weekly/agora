//
//  BrowseCollectionViewController.h
//  agora
//
//  Created by Ethan Gates on 2/13/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"
#import "SlideItemCVC.h"

@interface BrowseCollectionViewController : SlideItemCVC

- (void)reloadDataWithCategory:(NSString*) cat;
- (void)reloadData;

@end
