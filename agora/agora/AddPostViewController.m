//
//  AddPostViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView* mainImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyMainImageButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *catagoryButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextFeild;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self scrollView] addSubview:[self contentView]];
    CGSize size = [self contentView].frame.size;
    //size.height = 1000;
    [[self scrollView] setContentSize:size];
    [[self scrollView] setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [[[self descriptionTextFeild] layer] setBorderWidth:0.5f];
    [[[self descriptionTextFeild] layer] setCornerRadius:4.0];
    [[[self descriptionTextFeild] layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"Enter a description"]){
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@""]){
        [textView setText:@"Enter a description"];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [[textView text] length] + ([text length] - range.length) <= 200;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (IBAction)selectMainImage:(id)sender {
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (IBAction)postToParse:(id)sender {
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@""]){
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = info[@"UIImagePickerControllerOriginalImage"];
    // How to know which imagePicker is which? (Main vs array of subimage)
    // do something with Image
    [[self mainImage] setImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
