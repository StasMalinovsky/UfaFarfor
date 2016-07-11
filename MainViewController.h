//
//  MainViewController.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServerManagerDelegate;

@interface MainViewController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, ServerManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end
