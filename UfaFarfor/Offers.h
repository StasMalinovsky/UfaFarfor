//
//  Offers.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offers : NSObject

@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *offerUrl;
@property (nonatomic, strong) NSString *offerName;
@property (nonatomic, strong) NSString *offerPrice;
@property (nonatomic, strong) NSString *offerDescription;
@property (nonatomic, strong) NSString *offerPicture;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSMutableDictionary *params;

- (id) initWithOfferId:(NSString *) offerId;

@end
