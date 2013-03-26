//
//  NewsData.m
//  Pull2
//
//  Created by Pavel Akhrameev on 31.01.13.
//  Copyright (c) 2013 Pavel Akhrameev. All rights reserved.
//

#import "NewsData.h"

@implementation NewsData
@synthesize text;
@synthesize identificator;
@synthesize date;

+ (NewsData *) initWithDictianary: (NSDictionary *) dictianary
{
    NewsData *news = [[NewsData alloc] init];
    id temp = [dictianary objectForKey:@"text"];
    if (temp)
        [news setText:temp];
    temp = [dictianary objectForKey:@"id"];
    if (temp)
        [news setIdentificator:temp];
    temp = [[dictianary objectForKey:@"publicationDate"]objectForKey:@"milliseconds"];
    if (temp)
        [news setDate:temp];
    return news;
}

@end
