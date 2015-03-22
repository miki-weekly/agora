//
//  AddPostViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()

@property (strong, nonatomic) IBOutlet UIImageView* mainImage;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)showimagePickerForMain:(id)sender{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = info[@"UIImagePickerControllerOriginalImage"];
    // How to know which imagePicker is which? (Main vs array of subimage)
    // do something with Image
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/

@end
