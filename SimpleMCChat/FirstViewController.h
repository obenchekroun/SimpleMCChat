//
//  FirstViewController.h
//  SimpleMCChat
//
//  Created by Othmane Benchekroun on 16/08/2015.
//  Copyright (c) 2015 BO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface FirstViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UITextView *tvChat;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)sendMessage:(id)sender;
- (IBAction)cancelMessage:(id)sender;


@end

