//
//  SecondViewController.h
//  SimpleMCChat
//
//  Created by Othmane Benchekroun on 16/08/2015.
//  Copyright (c) 2015 BO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblFiles;
@property (nonatomic, strong) NSString *selectedFile;
@property (nonatomic) NSInteger selectedRow;


@end

