//
//  Categories.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *categoryName;

- (id) initWithСategoryId: (NSString*) categoryId;

@end
