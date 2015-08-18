//
//  FirstViewController.m
//  SimpleMCChat
//
//  Created by Othmane Benchekroun on 16/08/2015.
//  Copyright (c) 2015 BO. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

- (void)sendMyMessage;
- (void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _txtMessage.delegate = self;
    
    _tvChat.layoutManager.allowsNonContiguousLayout = NO;
    [_sendButton setEnabled:NO];
    _tvChat.selectable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    _sendButton.enabled = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    testString = [testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if( testString.length)
        _sendButton.enabled = YES;
    else
        _sendButton.enabled = NO;
    
    return YES;
}


#pragma mark - IBAction method implementation

- (IBAction)sendMessage:(id)sender {
    [self sendMyMessage];
}

- (IBAction)cancelMessage:(id)sender {
    
    //[_txtMessage setText:@""];
    //_sendButton.enabled = NO;
    
    //[self textFieldShouldReturn:_txtMessage];
    //[_txtMessage resignFirstResponder];
    
    [_txtMessage resignFirstResponder];

}

#pragma mark - Private method implementation

-(void)sendMyMessage{
    
    if ([[_txtMessage.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        //If any code when the field is empty
    }
    else
    {
        NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
        NSError *error;
        
        [_appDelegate.mcManager.session sendData:dataToSend
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataReliable
                                           error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        NSDate *localDate = [NSDate date];
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
        timeFormatter.dateFormat = @"dd/MM/yy HH:mm";
        NSString *dateString = [timeFormatter stringFromDate: localDate];
        
        UIColor *colorMe = [UIColor orangeColor];
        NSMutableAttributedString *sentText = [[NSMutableAttributedString alloc]init];
        NSMutableAttributedString *formattedDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" @ %@ ~\n",dateString]];
        
        [sentText appendAttributedString:[[NSAttributedString alloc] initWithString:@"Me"]];
        [sentText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,[[sentText mutableString]length])];
        [sentText addAttribute:NSForegroundColorAttributeName value:colorMe range:NSMakeRange(0,[[sentText mutableString]length])];
        
        [formattedDate addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,[[formattedDate mutableString]length])];
        [formattedDate addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[[formattedDate mutableString]length])];
        
        [sentText appendAttributedString:formattedDate];
        
        [sentText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:_txtMessage.text attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:20]}]];
        
        [sentText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"\n\n"]];
        
        NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] initWithAttributedString:_tvChat.attributedText];
        
        [historyText appendAttributedString:sentText];
        
        //NSMutableAttributedString *textSee = [[[NSAttributedString alloc] initWithAttributedString:_tvChat.attributedText];
        
        [_tvChat setAttributedText:historyText];
    
        [_tvChat layoutIfNeeded];
        NSRange range = NSMakeRange(_tvChat.text.length - 2, 1); //I ignore the final carriage return, to avoid a blank line at the bottom
        [_tvChat scrollRangeToVisible:range];
    
        //[_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"Me: %@\n\n", _txtMessage.text]]];
        [_txtMessage setText:@""];
        _sendButton.enabled = NO;
    
        //[_txtMessage resignFirstResponder];
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    //NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    UIColor *colorOther = [UIColor purpleColor];
    
    NSDate *localDate = [NSDate date];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"dd/MM/yy HH:mm";
    NSString *dateString = [timeFormatter stringFromDate: localDate];
    
    
    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc]initWithString:peerDisplayName];
    //[headerText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@""]];
    
    NSMutableAttributedString *formattedDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" @ %@ ~\n",dateString]];
    
    //[headerText appendAttributedString:[[NSAttributedString alloc] initWithString:@"Me:\n"]];
    
    [headerText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,[[headerText mutableString]length])];
    [headerText addAttribute:NSForegroundColorAttributeName value:colorOther range:NSMakeRange(0,[[headerText mutableString]length])];
    
    [formattedDate addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,[[formattedDate mutableString]length])];
    [formattedDate addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[[formattedDate mutableString]length])];
    
    [headerText appendAttributedString:formattedDate];
    
    [headerText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:receivedText attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:20]}]];
    
    [headerText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"\n\n"]];
    
    
    
    NSMutableAttributedString *historyText = [[NSMutableAttributedString alloc] initWithAttributedString:_tvChat.attributedText];
    
    [historyText appendAttributedString:headerText];
    
    //NSMutableAttributedString *textSee = [[[NSAttributedString alloc] initWithAttributedString:_tvChat.attributedText];
    
    //[_tvChat setAttributedText:historyText];
     
     [_tvChat performSelectorOnMainThread:@selector(setAttributedText:) withObject:historyText waitUntilDone:NO];
     
     [_tvChat layoutIfNeeded];
     NSRange range = NSMakeRange(_tvChat.text.length - 2, 1); //I ignore the final carriage return, to avoid a blank line at the bottom
     [_tvChat scrollRangeToVisible:range];
     
    
    
    
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    
    
    
}
@end
