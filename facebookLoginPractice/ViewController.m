//
//  ViewController.m
//  facebookLoginPractice
//
//  Created by Ariel Robles on 2/16/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

-(void)toggleHiddenState:(BOOL)shouldHide;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self toggleHiddenState:YES];
    [[self lblLoginStatus] setText:@""];
    //self.loginButton = [[FBLoginView alloc] initWithReadPermissions:
    //                    @[@"public_profile", @"email", @"user_friends"]];
    //self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Log in state
-(void)toggleHiddenState:(BOOL)shouldHide
{
    self.lblEMail.hidden = shouldHide;
    self.lblUserName.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

#pragma mark - FBDelegate
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    self.lblLoginStatus.text = @"You're Logged in.";
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@", user);
    //Todo: It doesn't bring the email.
    self.profilePicture.profileID = user[@"id"];
    self.lblUserName.text = user.name;
    self.lblEMail.text = user[@"email"];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{

    self.lblLoginStatus.text = @"You are logged out.";
    [self toggleHiddenState:YES];
}




- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user performs an action outside of you app to recover,
    // the SDK provides a message, you just need to surface it.
    // This handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
