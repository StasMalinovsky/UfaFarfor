//
//  MainViewController.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "MainViewController.h"

#import "ServerManager.h"
#import "Categories.h"
#import "Offers.h"
#import "OfferViewController.h"

#import "CategoryTableViewCell.h"

#import "AppDelegate.h"

#import "MBProgressHUD.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "SWRevealViewController.h"

static NSString *kCategoryCellIdentifier = @"CategoryCellIdentifier";

@interface MainViewController ()

@property(nonatomic, strong) NSMutableArray* foodArray;
@property(nonatomic, strong) NSMutableArray* offerArray;

@property (retain, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation MainViewController 

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNib];
    
    self.sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [ServerManager sharedInstance].delegate = self;
    self.foodArray = [NSMutableArray new];
    self.offerArray = [NSMutableArray new];
    [[ServerManager sharedInstance] parseXMLFile];
    
    [self.tableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foodArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   CategoryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellIdentifier];
    
        if (cell == nil) {
            cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCategoryCellIdentifier];
        }
    
    Categories *food = self.foodArray[indexPath.row];
    
    cell.categoryHead.text = [NSString stringWithFormat:@"%@", food.categoryName];

//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//    });
    
    cell.categoryImage.image = [self getImageForCategoryId:food.categoryId];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showOfferSegue" sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"showOfferSegue"]) {
        ((OfferViewController *)segue.destinationViewController).offerArray = self.offerArray;
        ((OfferViewController *)segue.destinationViewController).currentCategory = [self.foodArray objectAtIndex:indexPath.row];
    }
}

#pragma mark - Utils

- (void) registerNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryTableViewCell" bundle:nil] forCellReuseIdentifier:kCategoryCellIdentifier];
}

- (void)categoriesDidLoad:(NSMutableArray *)categories {
    [self.foodArray addObjectsFromArray: categories];
    [self.tableView reloadData];
}

- (void) offersDidLoad:(NSMutableArray *)offers {
    self.offerArray = offers;
    
//    [self.spinner stopAnimating];
//    [self.spinner setHidden:YES];
//    [self.spinner removeFromSuperview];
    [self.tableView reloadData];
}

- (UIImage *)getImageForCategoryId:(NSString *)categoryId {
    
    UIImage *image = [[UIImage alloc] init];
    
    if ([categoryId isEqualToString:@"10"]) {
        image = [UIImage imageNamed:@"dessert"];
        return image;
    } else if ([categoryId isEqualToString:@"1"]) {
        image = [UIImage imageNamed:@"pizza"];
        return image;
    } else if ([categoryId isEqualToString:@"2"]) {
        image = [UIImage imageNamed:@"sets"];
        return image;
    } else if ([categoryId isEqualToString:@"18"]) {
        image = [UIImage imageNamed:@"roll"];
        return image;
    } else if ([categoryId isEqualToString:@"5"]) {
        image = [UIImage imageNamed:@"sushi"];
        return image;
    } else if ([categoryId isEqualToString:@"23"]) {
        image = [UIImage imageNamed:@"additives"];
        return image;
    } else if ([categoryId isEqualToString:@"8"]) {
        image = [UIImage imageNamed:@"hot"];
        return image;
    } else if ([categoryId isEqualToString:@"20"]) {
        image = [UIImage imageNamed:@"snacks"];
        return image;
    } else if ([categoryId isEqualToString:@"9"]) {
        image = [UIImage imageNamed:@"drinks"];
        return image;
    } else if ([categoryId isEqualToString:@"25"]) {
        image = [UIImage imageNamed:@"pizza"];
        return image;
    } else if ([categoryId isEqualToString:@"24"]) {
        image = [UIImage imageNamed:@"kebab"];
        return image;
    } else if ([categoryId isEqualToString:@"6"]) {
        image = [UIImage imageNamed:@"soup"];
        return image;
    } else if ([categoryId isEqualToString:@"3"]) {
        image = [UIImage imageNamed:@"noodles"];
        return image;
    } else if ([categoryId isEqualToString:@"7"]) {
        image = [UIImage imageNamed:@"salad"];
        return image;
    }
    
    return nil;
}

@end
