//
//  DetailedPostViewController.h
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"
#import "SlideItemVC.h"

@interface DetailedPostViewController : SlideItemVC <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property Post * post;

- (void)reloadPost;

@end
