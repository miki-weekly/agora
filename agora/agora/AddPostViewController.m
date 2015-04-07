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
#import "RootVC.h"
#import "UIColor+AGColors.h"

@interface AddPostViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView* mainImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyMainImageButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activitySpinner;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property NSMutableArray* secondaryPictures;

@property (weak, nonatomic) id activeField;

@property BOOL selectingHeadImage;

@property NSDictionary * catColors;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[self scrollView] setContentSize:[[UIScreen mainScreen] bounds].size];
    [[[self descriptionTextView] layer] setBorderWidth:0.5f];
    [[[self descriptionTextView] layer] setCornerRadius:4.0];
    [[[self descriptionTextView] layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    [[self addButton] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self addButton] setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [[[self addButton] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [[[self addButton] layer] setBorderWidth:2.0f];
    [[[self addButton] layer] setBackgroundColor:[[UIColor indigoColor] CGColor]];
    [[[self addButton] layer] setCornerRadius:4.0f];
    [[[self addButton] layer] setBorderColor:[[UIColor indigoColor] CGColor]];
    
    [self setSecondaryPictures:[[NSMutableArray alloc] init]];
    
    [self setupSelectButton:self.categoryButton];
    self.catColors = @{@"Tech":[UIColor techColor],@"Home":[UIColor homeColor],@"Fashion":[UIColor fashColor],@"Education":[UIColor eduColor],@"Misc":[UIColor miscColor]};
}

- (void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    if(![self imagePickerController]){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self setImagePickerController:[[UIImagePickerController alloc] init]];
            [[self imagePickerController] setDelegate:self];
        });
    }
}


#pragma mark - Category selection things
int color;
-(void) setupSelectButton:(UIButton*) button {
    [button.layer setCornerRadius:4.0];
    [button.layer setBorderColor:[UIColor blueColor].CGColor];
    [button.layer setBorderWidth:2.0];
    
    color = 0;
    
}

-(void) presentCategorySelection {
    NSArray * k = self.catColors.allKeys;
    
    NSString * newCat = k[color];
    
    
    [[self categoryButton] setTitle:newCat forState:UIControlStateNormal];
    UIColor * newColor = self.catColors[newCat];
    [self.categoryButton.layer setBorderColor:newColor.CGColor];
    [self.categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    color++;
    if (color == 5) {
        color = 0;
    }
}

-(void)dismissCategoryVCWithSelection:(NSString *)cat {
    
}

#pragma mark - IB Actions

- (IBAction)selectMainImage:(id)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self setSelectingHeadImage:YES];
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}
- (IBAction)addSecondaryImage:(id)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];              // Access photo library
    //[imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];                    // Access Camera ( will crash if no camera (simulator))
    
    [self presentViewController:[self imagePickerController] animated:YES completion:nil];
}

- (IBAction)selectCatagory:(id)sender {
    [self presentCategorySelection];
    
}

- (IBAction)postToParse:(id)sender {
    // TODO: do checks on if required feilds are enter, secondary pics
    if([[[self titleTextField] text] isEqualToString:@""])
        return;
    
    [[self activitySpinner] startAnimating];
    Post* post = [[Post alloc] init];
    
    [post setTitle:[[self titleTextField] text]];
    [post setItemDescription:[[self descriptionTextView] text]];
    [post setCategory:[[[self categoryButton] titleLabel] text]];
    [post setStringTags:@[@"[]"]];
    [post setPrice:[NSNumber numberWithDouble:[[[self priceTextField] text] doubleValue]]];
    [post setHeaderPhoto:[[self mainImage] image]];
    [post setCreatorFacebookId:[[PFUser currentUser] objectForKey:@"facebookId"]];
    [post setPhotosArray:[self secondaryPictures]];
    
    [ParseInterface saveNewPostToParse:post completion:^(BOOL succeeded){
        if(succeeded){
            [[self activitySpinner] stopAnimating];
            [[self delgate] addPostController:self didFinishWithPost:post];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            
        }
    }];
}

- (IBAction)pressedCancel:(id)sender {
    if (self.parentViewController.class == [RootVC class]) {
        RootVC * root = (RootVC*)self.parentViewController;
        [root switchToViewController:0];
    } else {
        [[self delgate] addPostController:self didFinishWithPost:nil];
    }
}

#pragma mark - Text Field

- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, [[self activeField] frame].origin) ) {
        [self.scrollView scrollRectToVisible:[[self activeField] frame] animated:YES];
    }
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    [self setActiveField:sender];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [self setActiveField:nil];
}

- (void) keyboardWillBeHidden:(NSNotification *)notification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
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
    [self setActiveField:textView];
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@""]){
        [textView setText:@"Enter a description"];
        [textView setTextColor:[UIColor grayColor]];
    }
    [self setActiveField:nil];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self setSelectingHeadImage:NO];
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
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == [[self secondaryPictures] count]) { // clicked the last cell (addCell)
        [self addSecondaryImage:nil];
    }
}

@end
