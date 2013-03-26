//
//  TableViewController.h
//  Pull2
//
//  Created by Pavel Akhrameev on 31.01.13.
//  Copyright (c) 2013 Pavel Akhrameev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsData.h"

@interface TableViewController : UITableViewController

@property (strong, nonatomic) NSArray *tableData;               //Table data - there will be news
@property (strong, nonatomic) NSMutableData *responseData;      //responseData to get large answers from server
@end
