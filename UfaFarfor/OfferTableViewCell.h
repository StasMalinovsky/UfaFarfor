//
//  OfferTableViewCell.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 10.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;

@end
