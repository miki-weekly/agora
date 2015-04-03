//
//  AddPostViewController.h
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "SlideItemVC.h"

@protocol AddPostDelegate

- (void)didFinishWithPost:(Post*)addedPost;

@end

@interface AddPostViewController : SlideItemVC <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property id <AddPostDelegate> delgate;

@end
