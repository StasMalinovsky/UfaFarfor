//
//  ServerManager.h
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerManagerDelegate <NSObject>

- (void)categoriesDidLoad:(NSMutableArray *)categories;
- (void)offersDidLoad:(NSMutableArray *)offers;

@end

@interface ServerManager : NSObject <NSXMLParserDelegate>

@property (nonatomic, weak) id<ServerManagerDelegate> delegate;

+ (ServerManager *)sharedInstance;
- (void)parseXMLFile;

@end
