//
//  ConversationVC.m
//  agora
//
//  Created by Ethan Gates on 4/17/15.
//  Copyright (c) 2015 Ethan. All rights reserved.
//

#import "ConversationVC.h"
#import "MessageView.h"
#import "Message.h"
#import "Conversation.h"
#import "UIColor+AGColors.h"

#define SEND_VIEW_HEIGHT 44
#define SEND_BUTTON_WIDTH 50
#define MARGIN 16
#define FIELD_BUTTON_PADDING 9

@interface ConversationVC() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property NSMutableArray * messageViews;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property UIView * sendMsgView;
@property UITextField * sendMsgField;
@property UIButton * sendMsgButton;




@end

@implementation ConversationVC




#pragma mark - view life cycle methods

-(void) viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
        
        
}

-(void)viewDidLoad {
        [super viewDidLoad];
        
        self.title = @"Kalvin";
        
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        
        [self setupTextInputView];
        
        [self setupKeyboardAnimations];
        
        [self loadMessages];
        
        
        
        
        
}

-(void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        
       

        
        //CGSize s = [UIScreen mainScreen].bounds.size;
        //self.view.frame = CGRectMake(0, 0, s.width, s.height - 1);
        // the tableview for this vc was instantiated by the storyboard for the parent nav controller with the wrongg
        // frame.  It ends up being too tall by the height of a nav bar and just pushes it off screen.  obvi the nav bar
        // height should be subtracted, but when i do that, it suddenly instantiates with the correct frame and the
        // adjustment makes it too short.  somehow when you subtract 1 point it does it corretly, but the subtraction
        // is too small to see so id doesn't matter
        
        
        
        
}

#pragma mark - setup one time things

-(void) setupKeyboardAnimations {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardDidHideNotification object:nil];
}



-(void) setupTextInputView {
        CGRect r = self.view.frame;
        self.sendMsgView = [[UIView alloc]initWithFrame:CGRectMake(0, r.size.height-SEND_VIEW_HEIGHT, self.view.frame.size.width, SEND_VIEW_HEIGHT)];
        self.sendMsgField = [[UITextField alloc]initWithFrame:CGRectMake(MARGIN, 7, r.size.width - 2*MARGIN - FIELD_BUTTON_PADDING - 50, 30)];
        
        
        self.sendMsgButton = [[UIButton alloc]initWithFrame:CGRectMake(self.sendMsgField.frame.size.width + MARGIN + FIELD_BUTTON_PADDING, 7, 50, 30)];
        
        [self.sendMsgView addSubview:self.sendMsgButton];
        [self.sendMsgView addSubview:self.sendMsgField];
        [self.sendMsgView setBackgroundColor:[UIColor redColor]];
        
        [self.view insertSubview:self.sendMsgView aboveSubview:self.tableview];
}

-(void) loadMessages {
        if (!self.messageViews) {
                self.messageViews = [[NSMutableArray alloc] init];
        }
        
        Message * firstMsg = [[Message alloc]init];
        firstMsg.chatMessage = @"Hey I'm interested in buying your raybans, setup a meet?";
        firstMsg.sentDate = [NSDate date];
        firstMsg.sender = [[PFUser currentUser] objectForKey:@"facebookId"];
        
        MessageView * firstView = [MessageView viewForMessage:firstMsg];
        [self.messageViews addObject:firstView];
        
        
        Message * second = [[Message alloc]init];
        second.chatMessage = @"yeah sure lets meet lantern tomorrow noon";
        firstMsg.sentDate = [NSDate date];
        second.sender = @"956635704369806";
        
        [self.messageViews addObject:[MessageView viewForMessage:second]];
        
        [self.messageViews addObject:[MessageView viewForMessage:second]];
        
        [self.messageViews addObject:[MessageView viewForMessage:second]];
        
        [self.messageViews addObject:[MessageView viewForMessage:second]];
        
        
}

#pragma mark - connections for keyboard

-(IBAction)keyboardOffScreen:(NSNotification*) note {
        [self animateFieldAbsolute:0];
        
}

-(IBAction)keyboardOnScreen:(NSNotification*) note {
        NSDictionary *info  = note.userInfo;
        NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
        
        CGRect rawFrame      = [value CGRectValue];
        CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
        CGFloat height = keyboardFrame.size.height;
        NSLog(@"height: %f", height);
        
        [self animateFieldAbsolute:height];
        
}


-(void) animateFieldAbsolute:(CGFloat) height {
        
        
        [UIView animateWithDuration:0.0 animations:^{
                CGRect old = self.sendMsgView.frame;
                self.sendMsgView.frame = CGRectMake(old.origin.x, [UIScreen mainScreen].bounds.size.height - height - old.size.height, old.size.width, old.size.height);
                
                CGRect tableFrame = self.tableview.frame;
                self.tableview.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, [UIScreen mainScreen].bounds.size.height - height - self.sendMsgView.frame.size.height); // for status bar
        }];
        
}

#pragma mark - Text field delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
        
        
        return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        [textField resignFirstResponder];
        return YES;
}

#pragma mark - Table View delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.messageViews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        MessageView * msgView = (MessageView*)self.messageViews[indexPath.row];
        CGFloat height = msgView.frame.size.height + msgView.frame.origin.y*2.0;
        return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"message cell"];
        
        MessageView * msgView = (MessageView*)self.messageViews[indexPath.row];
        [cell.contentView addSubview:msgView];
        
        
        
        
        return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}



@end


























