//
//  AddPostViewController.m
//  agora
//
//  Created by Kalvin Loc on 3/19/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "AddPostViewController.h"
#import "AddPostViewCell.h"
#import "RootVC.h"
#import "UIColor+AGColors.h"
#import <QuartzCore/QuartzCore.h>

@interface AddPostViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIImageView* mainImage;
@property (weak, nonatomic) IBOutlet UIButton *modifyMainImageButton;
@property (weak, nonatomic) IBOutlet UIButton *removeMainImageButton;
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
@property BOOL initialHeadImageSelect;
@property BOOL selectingHeadImage;

@property UIView* statusBarBack;

@property NSDictionary * catColors;

@end

@implementation AddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statusBarBack = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
    [[_statusBarBack layer] setBackgroundColor:[[[UIColor indigoColor] colorWithAlphaComponent:0.8f] CGColor]];
    [[self view] addSubview:_statusBarBack];
    
    [[self scrollView] setContentSize:[[UIScreen mainScreen] bounds].size];
    
    [[self mainImage] setContentMode:UIViewContentModeScaleAspectFill];
    [[self mainImage] setClipsToBounds:YES];
    
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

    if([self editingPost]){
        [self setUpEditting];
    }else{
		[self setInitialHeadImageSelect:YES];
        [[self removeMainImageButton] setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if(![self imagePickerController]){
        [self setImagePickerController:[[UIImagePickerController alloc] init]];
		[[self imagePickerController] setAllowsEditing:YES];
        [[self imagePickerController] setDelegate:self];
    }
	
	if([self initialHeadImageSelect]){
		[[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
		[self setSelectingHeadImage:YES];
		[self presentViewController:[self imagePickerController] animated:YES completion:nil];
	}
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setUpEditting{
    Post* post = [self editingPost];
    [[self mainImage] setImage:[post headerPhoto]];
    [[self modifyMainImageButton] setTitle:@"" forState:UIControlStateNormal];
    [[self removeMainImageButton] setEnabled:YES];
    
    [[self titleTextField] setTextColor:[UIColor blackColor]];
    [[self titleTextField] setText:[post title]];
    [[self priceTextField] setText:[[post price] stringValue]];
	
    [[self categoryButton] setTitle:[post category] forState:UIControlStateNormal];
    [[self categoryButton] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self presentCategorySelection];
	
	[[self addButton] setTitle:@"Save" forState:UIControlStateNormal];
	
    [[self descriptionTextView] setText:[post itemDescription]];
    [[self descriptionTextView] setTextColor:[UIColor blackColor]];
	
    [self setSecondaryPictures:[[NSMutableArray alloc] initWithArray:[post photosArray]]];
}

- (BOOL)userFilledinRequiredFields{
	bool text = true, category = true, price = true, mainImg = true;
	
	if([[[self titleTextField] text] isEqualToString:@""]){
		NSLog(@"no title");
		[UIView animateWithDuration:.1
						 animations:^{
							 [_titleTextField setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
						 } completion:^(BOOL finished) {
							 [UIView animateWithDuration:.7
											  animations:^{
												  [_titleTextField setBackgroundColor:[UIColor whiteColor]];
											  }];
						 }];
		text = false;
	}
	
	if([[[[self categoryButton] titleLabel] text] isEqualToString:@"Select"]){
		NSLog(@"no category");
		[UIView animateWithDuration:.1
						 animations:^{
							 [_categoryButton setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
						 } completion:^(BOOL finished) {
							 [UIView animateWithDuration:.7
											  animations:^{
												  [_categoryButton setBackgroundColor:[UIColor whiteColor]];
											  }];
						 }];
		category = false;
	}
	
	if([self.priceTextField.text isEqualToString:@""]){
		NSLog(@"no price");
		[UIView animateWithDuration:.1
						 animations:^{
							 [_priceTextField setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
						 } completion:^(BOOL finished) {
							 [UIView animateWithDuration:.7
											  animations:^{
												  [_priceTextField setBackgroundColor:[UIColor whiteColor]];
											  }];
						 }];
		price = false;
	}
	
	CGImageRef cgref = self.mainImage.image.CGImage;
	CIImage *cim = self.mainImage.image.CIImage;
	
	if (cim == nil && cgref == NULL){
		NSLog(@"no main image");
		[UIView animateWithDuration:.1
						 animations:^{
							 [_mainImage setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
						 } completion:^(BOOL finished) {
							 [UIView animateWithDuration:.7
											  animations:^{
												  [_mainImage setBackgroundColor:[UIColor whiteColor]];
											  }];
						 }];
		mainImg = false;
	}
	
	if (!text || !category || !price || !mainImg){
		return NO;
	}
	
	return YES;
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
	
    // also change statusBarBackground
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [[_statusBarBack layer] setBackgroundColor:[[newColor colorWithAlphaComponent:0.8f] CGColor]];
                     }
                     completion:^(BOOL finished){}];
    color++;
    if (color == 5) {
        color = 0;
    }else if(color == 1){	// if color is yellow, set black statusbar
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

-(void)dismissCategoryVCWithSelection:(NSString *)cat {
    
}

#pragma mark - IB Actions

- (IBAction)selectMainImage:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:	@"Camera",
                            @"Photo Library",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
    [self setSelectingHeadImage:YES];
}
- (IBAction)addSecondaryImage:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:	@"Camera",
                            @"Photo Library",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)selectCatagory:(id)sender {
    [self presentCategorySelection];
}

- (IBAction)postToParse:(id)sender {
	// TODO: do checks on if required feilds are enter, secondary pics
	if(![self userFilledinRequiredFields])
		return;
	
	[[self scrollView] setUserInteractionEnabled:NO];
	[[self activitySpinner] startAnimating];
	
	
	Post* post;
	if(![self editingPost])
		post = [[Post alloc] init];
	else
		post = [self editingPost];

	if(![[[self descriptionTextView] text] isEqualToString:@"Enter a description"])
		[post setItemDescription:[[self descriptionTextView] text]];
	
	[post setTitle:[[self titleTextField] text]];
	[post setCategory:[[[self categoryButton] titleLabel] text]];
	[post setStringTags:@[@"[]"]];
	[post setHeaderPhoto:[[self mainImage] image]];
	[post setCreatorFacebookId:[[PFUser currentUser] objectForKey:@"facebookId"]];
	[post setPhotosArray:[self secondaryPictures]];
	
	NSString* price = [[[self priceTextField] text] stringByReplacingOccurrencesOfString:@"$" withString:@""];
	[post setPrice:[NSNumber numberWithDouble:[price doubleValue]]];
	
	if(![self editingPost]){
		[ParseInterface saveNewPostToParse:post completion:^(BOOL succeeded){
			if(succeeded){
				// TODO: setting to post to facebook or not
				[post postToFacebook];
				
				[[self activitySpinner] stopAnimating];
				[[self delgate] addPostController:self didFinishWithPost:post];
			}else{
				// TODO: failed add
			}
		}];
	}else{
		[ParseInterface updateParsePost:post completion:^(BOOL succeeded) {
			if(succeeded){
				// TODO: Splash screen succeded or not
				[[self activitySpinner] stopAnimating];
				[[self delgate] addPostController:self didFinishUpdatePost:post];
			}else{
				// TODO: failed update
			}
		}];
	}
}

- (IBAction)pressedCancel:(id)sender {
    if(![self editingPost])
        [[self delgate] addPostController:self didFinishWithPost:nil];
    else
        [[self delgate] addPostController:self didFinishUpdatePost:nil];
}

- (IBAction)removeMainImage:(id)sender {
    [[self mainImage] setImage:nil];
    
    [[self removeMainImageButton] setHidden:YES];
    [[self removeMainImageButton] setEnabled:NO];
    [[self modifyMainImageButton] setTitle:@"📷+" forState:UIControlStateNormal];
}

- (IBAction)removeImageFromArray:(UIButton*)sender{
    [[self secondaryPictures] removeObjectAtIndex:[sender tag]];
    [[self collectionView] reloadData];
}

- (void)hideKeyboard{
    [self.descriptionTextView resignFirstResponder];
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

- (void) keyboardWillBeHidden:(NSNotification *)notification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [[self scrollView] setContentInset:contentInsets];
    [[self scrollView] setScrollIndicatorInsets:contentInsets];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender {
    [self setActiveField:sender];
    
    if(sender == [self priceTextField])
        [[self priceTextField] setText:[[[self priceTextField] text] stringByReplacingOccurrencesOfString:@"$" withString:@""]];
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender {
    [self setActiveField:nil];
    
    if(sender == [self priceTextField] && ![[[self priceTextField] text] isEqualToString:@""])
        [[self priceTextField] setText:[@"$" stringByAppendingString:[[self priceTextField] text]]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// http://stackoverflow.com/questions/27308595/how-do-you-dynamically-format-a-number-to-have-commas-in-a-uitextfield-entry
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField != [self priceTextField]) return YES; // only moderate the priceLabel
    if([[textField text] length] > 6 && ![string isEqualToString:@""]) return NO;
    
    if (([string isEqualToString:@"0"] || [string isEqualToString:@""]) && [textField.text rangeOfString:@"."].location < range.location) {
        return YES;
    }
    
    // First check whether the replacement string's numeric...
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bool isNumeric = [string isEqualToString:filtered];
    
    // Then if the replacement string's numeric, or if it's
    // a backspace, or if it's a decimal point and the text
    // field doesn't already contain a decimal point,
    // reformat the new complete number using
    // NSNumberFormatterDecimalStyle
    if (isNumeric ||
        [string isEqualToString:@""] ||
        ([string isEqualToString:@"."] &&
         [textField.text rangeOfString:@"."].location == NSNotFound)) {
            
            // Create the decimal style formatter
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:10];
            
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSNumber *number = [formatter numberFromString:numberWithoutCommas];
            
            NSString *formattedString = [formatter stringFromNumber:number];
            
            // If the last entry was a decimal or a zero after a decimal,
            // re-add it here because the formatter will naturally remove
            // it.
            if ([string isEqualToString:@"."] &&
                range.location == textField.text.length) {
                formattedString = [formattedString stringByAppendingString:@"."];
            }
            
            textField.text = formattedString;
            
        }
    
    // Return no, because either the replacement string is not
    // valid or it is and the textfield has already been updated
    // accordingly
    return NO;
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch(actionSheet.tag){
        case 1:{
            switch (buttonIndex){
                case 0:		// Camera
                    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:		// Photo Library
                    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                    break;
                default:
                    break;
            }
			[self presentViewController:[self imagePickerController] animated:YES completion:nil];
            break;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = info[@"UIImagePickerControllerEditedImage"];
    // How to know which imagePicker is which? (Main vs array of subimage)
    // do something with Image
    
    if([self selectingHeadImage] || [self initialHeadImageSelect]){
        [[self mainImage] setImage:image];
        [self setSelectingHeadImage:NO];
		[self setInitialHeadImageSelect:NO];
        [[self removeMainImageButton] setHidden:NO];
		[[self removeMainImageButton] setEnabled:YES];
        [[self modifyMainImageButton] setTitle:@"" forState:UIControlStateNormal];
    }else{
        [[self secondaryPictures] addObject:image];
        [[self collectionView] reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
	[self setInitialHeadImageSelect:NO];
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
        AddPostViewCell* imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        NSInteger row = [indexPath row];
        [imageCell setContentMode:UIViewContentModeScaleAspectFill];
        [[imageCell cellImage] setImage:[[self secondaryPictures] objectAtIndex:[indexPath row]]];
        [[imageCell removeButton] setTag:row];
        [[imageCell removeButton] addTarget:self action:@selector(removeImageFromArray:) forControlEvents:UIControlEventTouchDown];
        
        return imageCell;
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
