//
//  AddPostViewControllerDelegate.h
//  agora
//
//  Created by Kalvin Loc on 4/3/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostViewController.h"
#import "Post.h"

@class AddPostViewController;

@protocol AddPostViewControllerDelegate

- (void)addPostController:(AddPostViewController*)addPostController didFinishWithPost:(Post*)addedPost;

@end