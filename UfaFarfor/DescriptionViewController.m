//
//  DescriptionViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 11.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.offer.offerPicture];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    NSString *weightString = [self removeCharactersFromsDict:self.offer.params];
    
    if ([weightString isEqualToString:@"{}"]) {
        self.offerWeightLabel.text = [NSString stringWithFormat:@"0"];
    } else {
        self.offerWeightLabel.text = weightString;
    }
    
    self.imageView.image = image;
    self.offerNameLabel.text = self.offer.offerName;
    self.offerDescriptionLabel.text = self.offer.offerDescription;
    self.offerPriceLabel.text = self.offer.offerPrice;
}

- (NSString *)removeCharactersFromsDict: (NSMutableDictionary *)dict {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"{\"Вес\":\"" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
    return str2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
