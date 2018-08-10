//
//  CapitalCalendar.m
//  Ciptadana
//
//  Created by Reyhan on 11/3/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "CapitalCalendar.h"

#import "VRGCalendarView.h"
#import "NSDate+convenience.h"
#import "ObjectBuilder.h"

#define URL_CAPITAL_MARKET_CALENDAR @"http://ot.ciptadana.com:8400/WebserviceMarketinfo/core.jsp?param=CORE/ciptami/corpact/webservice/calendar?csv=1"

NSArray *DataEventCalendar;
NSMutableArray *RangeIndexDateEventCalendarMonth;
NSInteger indexmonthCalendar;
NSInteger indexAwalCalendarMonth;
NSInteger indexAkhirCalendarMonth;
NSInteger yearNow;
NSInteger prevMonth;

@interface CapitalCalendar() <VRGCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet VRGCalendarView *calendar;


@end

@implementation CapitalCalendar

- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(callback) withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.calendar = [[VRGCalendarView alloc] init];
    self.calendar.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 100);
    self.calendar.delegate = self;
    
    [self.view addSubview:self.calendar];
    
    //[self calendarView:self.calendar switchedToMonth:[self.calendar.currentMonth month] targetHeight:self.calendar.calendarHeight animated:NO];
    [self calendarView:self.calendar switchedToMonth:[self.calendar.currentMonth month] targetHeight:self.calendar.calendarHeight animated:YES];
    
    //inisialiasi variable global RangeIndexDateEventCalendarMonth
    RangeIndexDateEventCalendarMonth = [[NSMutableArray alloc] init];
    
    //menentukaan Tahun saat ini
    NSDate *DateNow = [NSDate date];
    yearNow = [DateNow year];
    prevMonth = 0;
    
    //get data calendar dari url
    NSString *url_string = [NSString stringWithFormat: URL_CAPITAL_MARKET_CALENDAR];
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:url_string]];
    NSString *DataString = [NSString stringWithUTF8String:[data bytes]];
    DataEventCalendar = [DataString componentsSeparatedByString:@"\n"];
    
    //untuk menengambil range Index
    NSString *prevDataEventCalendarYearMonthDetail = [NSString stringWithFormat:@"%@%@",[DataEventCalendar[0] substringWithRange:NSMakeRange(0,4)],[ DataEventCalendar[0] substringWithRange:NSMakeRange(4,2) ]];
    NSInteger indexAwal = 0;
    
//    NSLog(@"currentDataEventCalendarYearMonthDetail = %@",DataEventCalendar[0]);

    for(int i=1;i<[DataEventCalendar count];i++){
        if([DataEventCalendar[i] length] > 0){
            NSString *currentDataEventCalendarYearMonthDetail = [NSString stringWithFormat:@"%@%@",[DataEventCalendar[i] substringWithRange:NSMakeRange(0,4)],[ DataEventCalendar[i] substringWithRange:NSMakeRange(4,2) ]];
            NSLog(@"currentDataEventCalendarYearMonthDetail = %@",DataEventCalendar[i]);
            if( [prevDataEventCalendarYearMonthDetail isEqualToString:currentDataEventCalendarYearMonthDetail] ){
                continue;
            }
            else {
                [RangeIndexDateEventCalendarMonth addObject:[NSString stringWithFormat:@"%@|%d|%d",prevDataEventCalendarYearMonthDetail,indexAwal,i-1]];
                prevDataEventCalendarYearMonthDetail = currentDataEventCalendarYearMonthDetail;
                indexAwal = i;
            }
        }
        else{
            break;
        }
        
    }
    
}

#pragma mark - protected

- (void)callback
{
    //__weak typeof(self) theSelf = self;
    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}

#pragma mark
#pragma VRGCalendarViewDelegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month  targetHeight:(float)targetHeight animated:(BOOL)animated
{
    if(prevMonth == 1 && month == 12){
        yearNow -= 1;
    }
    else if (prevMonth == 12 && month == 1){
        yearNow += 1;
    }
    prevMonth = month;
    
    NSString *yearMonthCalendar = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld",(long)yearNow],[NSString stringWithFormat:@"%02ld",(long)month]];
    indexmonthCalendar = -1;
    indexAwalCalendarMonth = 0;
    indexAkhirCalendarMonth = 0;
    
    
    for(int i=0;i<[RangeIndexDateEventCalendarMonth count];i++){
        if([yearMonthCalendar isEqualToString:[[RangeIndexDateEventCalendarMonth objectAtIndex:i] substringWithRange:NSMakeRange(0,6)]]){
            indexmonthCalendar = i;
            break;
        }
    }
    
    if(indexmonthCalendar >= 0){
        NSArray *temp = [RangeIndexDateEventCalendarMonth[indexmonthCalendar] componentsSeparatedByString:@"|"];
        indexAwalCalendarMonth = [temp[1] integerValue];
        indexAkhirCalendarMonth = [temp[2] integerValue];
        NSMutableArray *tempTanggalCalendar = [[NSMutableArray alloc] init];
        NSMutableArray *tempcolorCalendar = [[NSMutableArray alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];

        
        
        
        for(int i=indexAwalCalendarMonth;i<=indexAkhirCalendarMonth;i++){
            NSDate *dateFromString = [dateFormatter dateFromString:[[DataEventCalendar objectAtIndex:i] substringWithRange:NSMakeRange(0, 8)]];
            [tempTanggalCalendar addObject:dateFromString];
            [tempcolorCalendar addObject:[ObjectBuilder colorWithHexString:@"93885A"]];
        }

        [self.calendar markDates:tempTanggalCalendar withColors:tempcolorCalendar];
    }
    
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyyMMdd"];
    
      NSString *stringFromDate = [formatter stringFromDate:date];
      NSLog(@"stringFromDate = %@",stringFromDate);
      NSArray *penampung;
      NSString *message = [NSString stringWithFormat:@""];
    
      for(int i=indexAwalCalendarMonth;i<=indexAkhirCalendarMonth;i++){
          penampung = [DataEventCalendar[i] componentsSeparatedByString:@"|"];
          NSString *dateFormatYear = [penampung[0] substringWithRange:NSMakeRange(0, 4)];
          NSString *dateFormatMonth = [penampung[0] substringWithRange:NSMakeRange(4, 2)];
          NSString *dateFormatDay = [penampung[0] substringWithRange:NSMakeRange(6, 2)];
          NSString *dateFormat = [NSString stringWithFormat:@"%@ - %@ - %@",dateFormatYear,dateFormatMonth,dateFormatYear];
          
          if([stringFromDate isEqualToString:penampung[0]]){
              
              if([message length] <= 0){
                  message = [NSString stringWithFormat:@"Date %@\n",dateFormat];
              }
              
              if([penampung count] > 3){
                  message = [NSString stringWithFormat:@"%@Type %@\nSecurities %@\n%@\n\n",message,penampung[1],penampung[2],penampung[3]];
              }
              else{
                  message = [NSString stringWithFormat:@"%@Type %@\nSecurities %@\n\n",message,penampung[1],penampung[2]];
              }
          }
          
      }
    
    if([message length] > 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:false message:message delegate:self cancelButtonTitle:false otherButtonTitles:@"OK", nil];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        [alert setValue:v forKey:@"accessoryView"];
        v.backgroundColor = [UIColor yellowColor];
        [alert addSubview:v];
        //        NSArray *subViewArray = alert.subviews;
//        for(int x = 0; x < [subViewArray count]; x++){
//            
//            //If the current subview is a UILabel...
//            if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
//                UILabel *label = [subViewArray objectAtIndex:x];
//                label.textAlignment = NSTextAlignmentLeft;
//            }
//        }
//        
//        [alert addSubview:subViewArray];
        [alert show];
    }
    
    
//      [sample addObject:@"20180521|RUPS|ERTX|Hotel Manhattan - Jakarta"];
//      [sample addObject:@"20180521|RUPS|ERTX|Hotel Manhattan - Jakarta2"];
//      NSLog(@"index of object = %d",[DataEventCalendar indexOfObject:@"20180521|RUPS|ERTX|Hotel Manhattan - Jakarta"]);
//    NSLog(@"date 0  dateSelected %@",EventDate[0]);
}

@end
