//
//  CapitalMarketCalendarViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/9/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//


#import "CapitalMarketCalendarViewController.h"
#import "ImageResources.h"
#import "VRGCalendarView.h"
#import "CalendarDetailViewController.h"
#import "NSDate+convenience.h"

#define URL_CAPITAL_MARKET_CALENDAR @"http://ot.ciptadana.com:8400/WebserviceMarketinfo/core.jsp?param=CORE/ciptami/corpact/webservice/calendar?csv=1"

@interface CapitalMarketCalendarViewController() <NSURLConnectionDataDelegate, VRGCalendarViewDelegate>

@property VRGCalendarView *calendar;
@property NSDate *currentDate;

@end


static NSMutableData * _responseData;
static NSArray *allKeys;
static NSMutableDictionary *marketDictionary;
static NSMutableDictionary *dateDictionary;
static BOOL finish;


@implementation CapitalMarketCalendarViewController
{
    NSDateFormatter *newsDateFormatter, *datesFormatter;}

@synthesize homeBarItem, backBarItem;


- (void)backBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];

}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    if(nil == marketDictionary || marketDictionary.allValues.count <= 0)
        finish = NO;
    
    newsDateFormatter = [[NSDateFormatter alloc] init];
    [newsDateFormatter setDateFormat:@"yyyyMMdd"];
    
    datesFormatter = [[NSDateFormatter alloc] init];
    [datesFormatter setDateFormat:@"yyyyMM"];
    
    _currentDate = [NSDate date];
    
    [self requestMarketCapitalCalendar];
    
    @try {
        _calendar = [[VRGCalendarView alloc] init];
        
        _calendar.frame = CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 100);
        _calendar.delegate=self;
        
        [self.view addSubview:_calendar];
        [self.view addSubview:_animationView];
        
        if(!finish) {
            _calendar.userInteractionEnabled = NO;
            [_animationView startAnimating];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"calendar exception %@", exception);
    }
    
}

- (void)requestMarketCapitalCalendar
{
    if(!finish) {
        // Create the request.
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CAPITAL_MARKET_CALENDAR]
//                                                 cachePolicy:NSURLCacheStorageNotAllowed
//                                            timeoutInterval:120.0];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CAPITAL_MARKET_CALENDAR]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:120.0];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_CAPITAL_MARKET_CALENDAR]
//                                                 cachePolicy:NSURLRequestReturnCacheDataDontLoad
//                                             timeoutInterval:120.0];
        
        // Clear Cache
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setAnimationView:nil];
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    finish = YES;
}

- (NSTimeInterval)intervalBetweenDate:(NSDate *)dt1 andDate:(NSDate *)dt2
{
    NSTimeInterval interval = [dt2 timeIntervalSinceDate:dt1];
    return interval;
}



#pragma mark
#pragma NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"connection didReceiveResponse:");
    _responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"connection didReceiveData:");
    [_responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"CapitalMarketCalendarViewController::connectionDidFinishLoading");
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        @try {
            NSString *rawString = [NSString stringWithUTF8String:_responseData.bytes];
            NSArray *chunks = [rawString componentsSeparatedByString:@"\n"];
            
            if(nil == marketDictionary) {
                marketDictionary = [NSMutableDictionary dictionary];
                dateDictionary = [NSMutableDictionary dictionary];
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy"];
            int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            [dateFormatter setDateFormat:@"MM"];
            int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
            int total = (year * 365) + (month * 30);
            
            
            for(NSString *row in chunks) {
                NSArray *array = [row componentsSeparatedByString:@"|"];
                NSString *news;
                
                if(nil != array && 4 == array.count) {
                    NSString *key = [array objectAtIndex:0];
                    news = [array objectAtIndex:3];
                    
                    if (nil != news) {
                    
                        if(nil != key && key.length > 6) {
                            @try {
                                NSString *dateKey = [key substringToIndex:6];
                                NSNumber *dateObject = [NSNumber numberWithInt:[[key substringFromIndex:6] intValue]];
                                NSMutableArray *arrayDate = [dateDictionary objectForKey:dateKey];
                                
                                int calYear = [[dateKey substringToIndex:4] intValue];
                                int calMonth = [[dateKey substringFromIndex:4] intValue];
                                int calTotal = (calYear * 365) + (calMonth * 30);
                                int diff = ABS(total - calTotal);
                                                            
                                //90 = 90 hari
                                if(diff < 90) {
                                    if(nil == arrayDate) {
                                        arrayDate = [NSMutableArray array];
                                        [dateDictionary setObject:arrayDate forKey:dateKey];
                                    }
                                    
                                    [arrayDate addObject:dateObject];
                                }
                            }
                            @catch (NSException *exception) {
                                NSLog(@"PARSE Exception = %@", exception);
                            }
                        }
                        
                        finish = YES;
                        
                        
                        NSMutableArray *arrayNews = [marketDictionary objectForKey:key];
                        
                        if(nil == arrayNews) {
                            arrayNews = [NSMutableArray array];
                            [marketDictionary setObject:arrayNews forKey:key];
                        }
                        
                        [arrayNews addObject:array];
                    }
                }
                else {
                    NSLog(@"---- %@", row);
                }
            }
            
            if(!finish) {
                [self requestMarketCapitalCalendar];
            }
            else {
                _calendar.userInteractionEnabled = YES;
                [_animationView stopAnimating];
                
                [self calendarView:_calendar switchedToMonth:[_calendar.currentMonth month] targetHeight:_calendar.calendarHeight animated:NO];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"http error %@", exception);
        }
        
    });
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection didFailWithError:");
    
    if(!finish)
        [self requestMarketCapitalCalendar];
}




#pragma mark
#pragma VRGCalendarViewDelegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    if (nil != _calendar.currentMonth) {
        NSString *dateKey = [datesFormatter stringFromDate:calendarView.currentMonth];
        
        NSMutableArray* myArray = [dateDictionary objectForKey:dateKey];
        
        if(nil != myArray) {
            dispatch_async( dispatch_get_main_queue(), ^{
                NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:myArray];
                NSArray *array = [[NSMutableArray alloc] initWithArray:[mySet array]];
                [calendarView markDates:array];
            });
        }
        
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSLog(@"cal dateSelected");
    NSString *key = [newsDateFormatter stringFromDate:date];
    
    if(nil != marketDictionary) {
        NSArray *arrayNews = [marketDictionary objectForKey:key];
        if (nil != arrayNews) {
            
            @try {
                CalendarDetailViewController *vc = [[CalendarDetailViewController alloc] initWithArray:arrayNews];
                [vc setPreviouseController:self.previouseController];
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                vc.modalPresentationStyle = UIModalPresentationCurrentContext;
                
                [self presentViewController:vc animated:YES completion:nil];
            }
            @catch (NSException *exception) {
                NSLog(@"calendar detail error %@", exception);
            }
            
        }
    }
    
}

@end

