//
//  OfferViewController.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 10.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Categories.h"
#import "Offers.h"

@protocol ServerManagerDelegate;

@interface OfferViewController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, ServerManagerDelegate>

@property (strong, nonatomic)NSMutableArray* offerArray;
@property (strong, nonatomic) Offers* offer;
@property (strong, nonatomic) Categories *currentCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
