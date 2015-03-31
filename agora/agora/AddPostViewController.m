//
//  AddPostViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostViewController.h"
#import "Post.h"
#import "ParseInterface.h"

@interface AddPostViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView* mainImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyMainImageButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *catagoryButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property NSMutableArray* secondaryPictures;

@property BOOL selectingHeadImage;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        [self setImagePickerController:[[UIImagePickerController alloc] init]];
        [[self imagePickerController] setDelegate:self];
    });
    
    [[self scrollView] setContentSize:[[self contentView] frame].size];
    //[[self scrollView] setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [[[self descriptionTextView] layer] setBorderWidth:0.5f];
    [[[self descriptionTextView] layer] setCornerRadius:4.0];
    [[[self descriptionTextView] layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    [self setSecondaryPictures:[[NSMutableArray alloc] init]];
}

#pragma mark - IB Actions

- (IBAction)selectMainImage:(id)sender {
    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self setSelectingHeadImage:YES];
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}
- (IBAction)addSecondaryImage:(id)sender {
    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}

- (IBAction)selectCatagory:(id)sender {
    [[self catagoryButton] setTitle:@"Misc" forState:UIControlStateNormal];
    // TODO: show list of catagories to choose from
}

- (IBAction)postToParse:(id)sender {
    // TODO: do checks on if required feilds are enter, secondary pics
    if([[[self titleTextField] text] isEqualToString:@""])
        return;
    
    Post* post = [[Post alloc] init];
    
    [post setTitle:[[self titleTextField] text]];
    [post setItemDescription:[[self descriptionTextView] text]];
    [post setCategory:[[[self catagoryButton] titleLabel] text]];
    [post setStringTags:@[@"[]"]];
    [post setPrice:[NSNumber numberWithDouble:[[[self priceTextField] text] doubleValue]]];
    [post setHeaderPhoto:[[self mainImage] image]];
    [post setCreatorFacebookId:[[PFUser currentUser] objectForKey:@"facebookId"]];
    [post setPhotosArray:[self secondaryPictures]];
    
    [ParseInterface saveNewPostToParse:post];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Text Field

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect frame = [[self view] frame];
    [[self view] setFrame:CGRectMake(frame.origin.x, frame.origin.y - 25, frame.size.width, frame.size.height)];
    [UIView commitAnimations];*/
    //[self scrollView] setContentSize:[[[]self scrollView]
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    /*
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect frame = [[self view] frame];
    [[self view] setFrame:CGRectMake(frame.origin.x, frame.origin.y + 25, frame.size.width, frame.size.height)];
    [UIView commitAnimations];*/
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text View

// following two functions work to manually put placeholder text
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if([textView.text isEqualToString:@"Enter a description"]){
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        [textView setText:@"Enter a description"];
        [textView setTextColor:[UIColor grayColor]];
    }
    
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Limit textView to 200 char
    return [[textView text] length] + ([text length] - range.length) <= 200;
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = info[@"UIImagePickerControllerOriginalImage"];
    // How to know which imagePicker is which? (Main vs array of subimage)
    // do something with Image
    
    if([self selectingHeadImage]){
        [[self mainImage] setImage:image];
        [self setSelectingHeadImage:NO];
    }else{
        [[self secondaryPictures] addObject:image];
        [[self collectionView] reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self secondaryPictures] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell;
    if([indexPath row] != [[self secondaryPictures] count]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
        [imageView setImage:[[self secondaryPictures] objectAtIndex:[indexPath row]]];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
    }
    
    [[cell layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[cell layer] setBorderWidth:1.5f];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [[self secondaryPictures] count]) {
        [self addSecondaryImage:nil];
    }
}

@end
