//
//  AddPostViewController.h
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideItemVC.h"

@interface AddPostViewController : SlideItemVC <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

-(void) dismissCategoryVCWithSelection:(NSString*) cat;


@end
