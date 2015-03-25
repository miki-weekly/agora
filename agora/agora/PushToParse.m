//
//  PushToParse.m
//  agora
//
//  Created by Cang Truong on 3/18/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "PushToParse.h"
#import "Post.h"

@interface PushToParse ()

@property IBOutlet UITextField* titleTextField;
@property IBOutlet UIImageView* postImageView;
@property IBOutlet UITextField* descriptionTextField;
@property IBOutlet UITextField* priceTextField;
@property IBOutlet UIButton* postButton;
@property IBOutlet UIButton* selectPictureButton;

@end

@implementation PushToParse

- (void)viewDidLoad{
    
}

- (IBAction)selectPicture:(id)sender{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[self postImageView] setImage:info[@"UIImagePickerControllerOriginalImage"] ];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postToParse:(id)sender{
    // Do push to parse
}

@end
