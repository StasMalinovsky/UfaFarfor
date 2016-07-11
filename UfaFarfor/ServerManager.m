//
//  ServerManager.m
//  UfaFarfor
//
//  Created by Stas Malinovsky on 09.07.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import "ServerManager.h"
#import "Categories.h"
#import "Offers.h"

@interface ServerManager ()

@property NSXMLParser *parser;
@property NSString *element;
@property NSString* currentCategoryId;
@property NSString* currentCategoryName;
@property NSString* currentOfferId;

@property (nonatomic, strong) NSString* currentOfferUrl;
@property (nonatomic, strong) NSString* currentOfferName;
@property (nonatomic, strong) NSString* currentOfferPrice;
@property (nonatomic, strong) NSString* currentOfferDescription;
@property (nonatomic, strong) NSString* currentOfferPicture;

@property (nonatomic, strong) NSMutableArray* foodArray;
@property (nonatomic, strong) NSMutableArray* offerArray;

@property (nonatomic, strong) NSString *currentElement;

@property (nonatomic, strong) Offers *currentOffer;
@property (nonatomic, strong) NSMutableArray *offers;
@property (nonatomic, strong) NSString *currentParamKey;
@property (nonatomic, strong) NSMutableString *paramsString;

@end

@implementation ServerManager

+ (ServerManager *)sharedInstance
{
    static ServerManager *_sharedInstance;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ServerManager alloc] init];
    });
    return _sharedInstance;
}

- (id) init {
    
    self = [super init];
    
    if (self) {
        self.foodArray = [NSMutableArray new];
        self.offerArray = [NSMutableArray new];
    }
    return self;
}

- (void) parseXMLFile {
    
    NSLog(@"parseXMLFile");
    NSURL *url = [NSURL URLWithString:@"http://ufa.farfor.ru/getyml/?key=ukAXxeJYZN"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:20.0f];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/xml; Charset=windows-1251" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url.absoluteString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSData *finalData = [[NSData alloc] initWithData:data];
                NSLog(@"block");
                self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
                self.parser = [[NSXMLParser alloc] initWithData:finalData];
                self.parser.delegate = self;
                [self.parser parse];
                
            }] resume];

}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"category"]) {
        _currentCategoryId = [attributeDict objectForKey:@"id"];
    }
    
    _currentElement = elementName;
    
    if ([_currentElement isEqualToString:@"offer"]) {
        
        self.currentOffer = [Offers new];
        self.currentOffer.offerId = [attributeDict objectForKey:@"id"];
        self.currentOfferId = [attributeDict objectForKey:@"id"];
    }
    
    if ([_currentElement isEqualToString:@"param"]) {
        self.currentParamKey = [attributeDict objectForKey:@"name"];
    }
    
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
    
    if (self.currentCategoryId != nil) {
        
        Categories *category = [[Categories alloc] init];
        
        category.categoryId = _currentCategoryId;
        category.categoryName = string;
        
        [self.foodArray addObject:category];
        
    }
    
    if ([_currentElement isEqualToString:@"url"]) {
        if(![string containsString:@"\n   "]) {
            self.currentOffer.offerUrl = string;
        }
    }
    
    if ([_currentElement isEqualToString:@"name"] && [self.currentOfferId isEqualToString:self.currentOffer.offerId]) {
        if(![string containsString:@"\n   "]) {
            
            if (self.currentOffer.offerName) {
                [self.currentOffer.offerName stringByAppendingString:string];
            } else {
                self.currentOffer.offerName = string;
            }
        }
    }
    
    if ([_currentElement isEqualToString:@"price"]) {
        if(![string containsString:@"\n   "]) {
            self.currentOffer.offerPrice = string;
        }
    }
    if ([_currentElement isEqualToString:@"categoryId"]) {
        if(![string containsString:@"\n   "] && [self.currentOfferId isEqualToString:self.currentOffer.offerId]) {
            self.currentOffer.categoryId = string;
        }
    }
    
    if ([_currentElement isEqualToString:@"picture"]) {
        if(![string containsString:@"\n   "]) {
            self.currentOffer.offerPicture = string;
        }
    }
    
    if ([_currentElement isEqualToString:@"description"]) {
        if (![string containsString:@"\n   "]) {
            self.currentOffer.offerDescription = string;
        }
    }
    
    if ([_currentElement isEqualToString:@"param"] && [self.currentOfferId isEqualToString:self.currentOffer.offerId]) {
        if(![string containsString:@"\n   "] && [self.currentParamKey isEqualToString:@"Вес"]) {
            
            if ([self.currentOffer.params valueForKey:self.currentParamKey]) {
                [self.currentOffer.params setValue:[[self.currentOffer.params valueForKey:self.currentParamKey] stringByAppendingString:string] forKey:self.currentParamKey];
                NSLog(@"");
            } else {
                [self.currentOffer.params setValue:string forKey:self.currentParamKey];
            }
        }
    }
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"url"]) {
//        NSLog(@"%@", elementName);
        [self.offerArray addObject:self.currentOffer];
        
        //self.currentOffer = nil;
    }
    
    if (_currentCategoryId != nil) {
        _currentCategoryId = nil;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument");
    
    if (self.foodArray) {
        [self.delegate categoriesDidLoad:self.foodArray];
    }
    
    if (self.offerArray) {
        [self.delegate offersDidLoad:self.offerArray];
    }
}

@end
