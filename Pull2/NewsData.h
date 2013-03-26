//
//  NewsData.h
//  Pull2
//
//  Created by Pavel Akhrameev on 31.01.13.
//  Copyright (c) 2013 Pavel Akhrameev. All rights reserved.
//

#import <Foundation/Foundation.h>

//class to contain text, id and date in milliseconds got from server

@interface NewsData : NSObject
@property (strong, nonatomic) NSString  *text;
@property (strong, nonatomic) NSString  *identificator;
@property (strong, nonatomic) NSNumber  *date;
+ (NewsData *) initWithDictianary: (NSDictionary *) dictianary;     //method to parse NSDictionary, got from server
@end
