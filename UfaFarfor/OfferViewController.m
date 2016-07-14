//
//  OfferViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 10.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "OfferViewController.h"
#import "OfferTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DescriptionViewController.h"

static NSString *kOfferCellIdentifier = @"OfferCellIdentifier";

@interface OfferViewController ()

@property (nonatomic, strong) NSArray *offersForCategoryArray;
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation OfferViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNib];
    
    self.navigationItem.title = _currentCategory.categoryName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.offersForCategoryArray = [self filterOffers:self.offerArray byCategoryId:self.currentCategory.categoryId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) registerNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"OfferTableViewCell" bundle:nil] forCellReuseIdentifier:kOfferCellIdentifier];
}

- (NSArray *)filterOffers:(NSArray *)offers byCategoryId:(NSString *)categoryId {
    NSMutableArray *array = [NSMutableArray array];
    
    for (Offers *offer in offers) {
        if ([offer.categoryId isEqualToString:categoryId]) {
            [array addObject:offer];
        }
    }
    
    return array;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.offersForCategoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OfferTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kOfferCellIdentifier];
    
    if (cell == nil) {
        cell = [[OfferTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kOfferCellIdentifier];
    }

    
    Offers *offer = self.offersForCategoryArray[indexPath.row];
    
    NSURL *url = [NSURL URLWithString:offer.offerPicture];
    [cell.offerImageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.offerImageView sd_setImageWithURL:url];

    cell.offerWeightLabel.text = [NSString stringWithFormat:@"%@", offer.offerWeight];
    cell.offerNameLabel.text = [NSString stringWithFormat:@"%@", offer.offerName];
    cell.offerPriceLabel.text = [NSString stringWithFormat:@"%@ ₽", offer.offerPrice];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDescriptionSegue" sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"showDescriptionSegue"]) {
        DescriptionViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.offer = self.offersForCategoryArray[indexPath.row];
    }
}

#pragma mark - Utils

@end
