//
//  TableViewController.m
//  Pull2
//
//  Created by Pavel Akhrameev on 31.01.13.
//  Copyright (c) 2013 Pavel Akhrameev. All rights reserved.
//

#import "TableViewController.h"

#define NEWS_URL @"https://api.tcsbank.ru/v1/news"              //from this link I will get data
#define LINK_TO @"https://api.tcsbank.ru/v1/news_content?id="   //open this link on cell click
#define AUTOLOAD_ON_START                                       //download or not data immediately on startup


@interface TableViewController ()
@property (strong, nonatomic) NSURLConnection *urlconnection;    //unused variable, whether we will use different connections
@end

@implementation TableViewController


@synthesize responseData;
@synthesize tableData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //refreshView method will be used on pulling-to-refresh our table
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
#ifdef AUTOLOAD_ON_START
    [self.refreshControl beginRefreshing];
    [self refreshView: self.refreshControl];
#endif
}

- (IBAction)refreshView:(UIRefreshControl *)refresh;
{
    //styling refreshView
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    [refresh setAttributedTitle: [[NSAttributedString alloc] initWithString:lastUpdated]];
    
    //get request to get data
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:NEWS_URL]];
    self.urlconnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //clear responseData on response
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //append new data to responseData
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //alert view to show error to user, and stop visualizing refreshing on error
    [self.refreshControl endRefreshing];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Network error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //data is in responseData, so parse it
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    if (myError)
    {
        //alert user about parse error and stop visualizing refreshing
        [self.refreshControl endRefreshing];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Parse error" message:[myError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSArray *payload = [res objectForKey:@"payload"];
    //enter root element, then make a loop of its elements
    NSMutableArray *newsArray = [NSMutableArray array];
    for (NSDictionary *item in payload)
    {
        //get data from individual news and place them in array
        NewsData *news = [NewsData initWithDictianary:item];
        [newsArray addObject:news];
    }
    //sork array
    [self setTableData:[newsArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]]];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //only one section is used in this task
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //elements of tableData are visualized in one section, so their count is the number of strings
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //moderate individual cell
    static NSString *simpleTableIdentifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //reach text parametr from tableData newa array, get text.
    NewsData *news = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = [news text];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //open native browser on click
    NewsData *news = [self.tableData objectAtIndex: indexPath.row];
    NSString *url = LINK_TO;
    url = [url stringByAppendingString:[news identificator]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
