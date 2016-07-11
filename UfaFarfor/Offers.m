//
//  Offers.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "Offers.h"

@implementation Offers

- (id) init {
    self = [super init];
    if (self) {
        self.params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id) initWithOfferId: (NSString*) offerId {
    
    self = [super init];
    
    if (self) {
        self.offerId = offerId;
    }
    return self;
}

@end
