//
//  CategoryTableViewCell.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryHead;

@end
