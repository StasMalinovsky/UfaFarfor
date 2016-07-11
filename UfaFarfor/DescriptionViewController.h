//
//  DescriptionViewController.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 11.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offers.h"

@protocol ServerManagerDelegate;

@interface DescriptionViewController : UIViewController <NSXMLParserDelegate, ServerManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescriptionLabel;

@property (strong, nonatomic) Offers* offer;

@end
