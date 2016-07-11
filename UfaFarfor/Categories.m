//
//  Categories.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "Categories.h"

@implementation Categories

- (id) initWithСategoryId:(NSString *)categoryId {
    
    self = [super init];
    
    if (self) {
        self.categoryId = categoryId;
    }
    return self;
}

@end
