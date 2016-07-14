//
//  DescriptionViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 11.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "DescriptionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offerWeightLabel.text = self.offer.offerWeight;

    self.offerNameLabel.text = self.offer.offerName;

    self.offerDescriptionTextView.text = self.offer.offerDescription;
    
    self.offerPriceLabel.text = [NSString stringWithFormat:@"%@ ₽", self.offer.offerPrice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.offerDescriptionTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    });
    NSURL *url = [NSURL URLWithString:self.offer.offerPicture];
    [self.imageView sd_setImageWithURL:url];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
