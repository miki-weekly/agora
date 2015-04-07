//
//  AddPostViewController.h
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseInterface.h"
#import "SlideItemVC.h"

@class AddPostViewController;

@protocol AddPostViewControllerDelegate
@optional
- (void)addPostController:(AddPostViewController*)addPostController didFinishWithPost:(Post*)addedPost;
- (void)addPostController:(AddPostViewController*)addPostController didFinishUpdatePost:(Post *)updatedPost;

@end

@interface AddPostViewController : SlideItemVC <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property id <AddPostViewControllerDelegate> delgate;

@property Post* editingPost;

@end
