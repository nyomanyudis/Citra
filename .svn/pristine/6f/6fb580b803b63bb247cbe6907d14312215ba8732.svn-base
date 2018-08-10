//
//  ChannelViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "ChannelViewController.h"
#import "Protocol.pb.h"
#import "AgentFeed.h"
#import "AppDelegate.h"

@interface ChannelViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ChannelViewController
{
//    AppDelegate *app;
    NSArray *array;
    
    NSInteger channel;
}

@synthesize delegate;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[AgentFeed sharedInstance] agentCallback:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    table.dataSource = self;
    table.delegate = self;
    table.separatorColor = [UIColor colorWithPatternImage:[self separatorImage]];
    
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [[AgentFeed sharedInstance] agentCallback:^(KiRecord *ki) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (RecordTypeKiIndicesData == ki.recordType ||
                RecordTypeKiRegionalIndices == ki.recordType ||
                RecordTypeFutures == ki.recordType) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [table reloadData];
                });
            }
        });
    }];
    
}

- (void)subchannel:(NSInteger)c
{
    channel = c;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
    if ([AgentTrade sharedInstance].loginMI) {
        if(ChannelIndices == channel) {
            array = [DBLite sharedInstance].getIndicesDatas;
            return array.count;
        }
        else if(ChannelRegionalIndices == channel) {
            array = [DBLite sharedInstance].getRegionalIndices;
            return array.count;
        }
        else if(ChannelFuture == channel) {
            array = [DBLite sharedInstance].getFutures;
            return array.count;
        }
    }
    else {
        if(ChannelIndices == channel) {
            if (nil != ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.indicesDictionary) {
                array = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.indicesDictionary.allValues;
                return array.count;
            }
        }
        else if(ChannelRegionalIndices == channel) {
            if (nil != ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.regionalDictionary) {
                array = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.regionalDictionary.allValues;
                return array.count;
            }
        }
        else if(ChannelFuture == channel) {
            if (nil != ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.futureDictionary) {
                array = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController.futureDictionary.allValues;
                return array.count;
            }
        }
    }
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(ChannelIndices == channel) {
        ChannelIndicesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if(nil == cell) {
            cell = [[ChannelIndicesViewCell alloc] init];
        }

//        if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
        if ([AgentTrade sharedInstance].loginMI) {
            KiIndicesData *p = [array objectAtIndex:indexPath.row];
            
            NSString *code = p.code;
            if([code isEqualToString:@"COMPOSITE"])
                code = @"IHSG";
            
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            cell.codeLabel.text = code;
        }
        else {
            //Indices
            //time - IdxCode - IdxLast - IdxOpen - IdxHighest - IdxLowest - IdxPrev - IdxChg - IdxChgPct
            
            NSArray *fields = [array objectAtIndex:indexPath.row];
            
//            NSString *code = [[fields objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *code = [fields objectAtIndex:1];
            if([@"COMPOSITE" isEqualToString:code])
                code = @"IHSG";
            
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            cell.codeLabel.text = code;
        }
        
        
        return cell;
    }
    
    else if(ChannelRegionalIndices == channel) {
        ChannelIndicesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(nil == cell) {
            cell = [[ChannelIndicesViewCell alloc] init];
        }
        
//        if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
        if ([AgentTrade sharedInstance].loginMI) {
            KiRegionalIndices *regIndices = [array objectAtIndex:indexPath.row];
            KiRegionalIndicesData *p = [[DBLite sharedInstance] getRegionalIndicesDataById:regIndices.codeId];
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            NSString *fullname = [p.fullname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            cell.codeLabel.text = [@"" isEqualToString:fullname] ? p.name : fullname;
        }
        else {
            //Regional
            //key - name - close - chg - chgPct
            
            NSArray *fields = [array objectAtIndex:indexPath.row];
            
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            cell.codeLabel.text = [fields objectAtIndex:1];
        }
        
        return cell;
    }
    else if(ChannelFuture == channel) {
        ChannelIndicesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(nil == cell) {
            cell = [[ChannelIndicesViewCell alloc] init];
        }
        
//        if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
        if ([AgentTrade sharedInstance].loginMI) {
            KiFuture *future = [array objectAtIndex:indexPath.row];
            KiRegionalIndicesData *p = [[DBLite sharedInstance] getRegionalIndicesDataById:future.codeId];
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            cell.codeLabel.text = [@"" isEqualToString:p.fullname] ? p.name : p.fullname;
        }
        else {
            //Future
            //key - name - close - chg - chgPct
            
            NSArray *fields = [array objectAtIndex:indexPath.row];
            
            cell.noLabel.text = [NSString stringWithFormat:@"%i. ", (int)(indexPath.row + 1)];
            cell.codeLabel.text = [fields objectAtIndex:1];
        }
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(ChannelIndices == channel) {
        ChannelIndicesViewCell *cell = [[ChannelIndicesViewCell alloc] init];
        return cell;
    }
    else if(ChannelRegionalIndices == channel) {
        ChannelIndicesViewCell *cell = [[ChannelIndicesViewCell alloc] init];
        return cell;
    }
    else if(ChannelFuture == channel) {
        ChannelIndicesViewCell *cell = [[ChannelIndicesViewCell alloc] init];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
    if ([AgentTrade sharedInstance].loginMI) {
        if(ChannelIndices == channel) {
            KiIndicesData *p = [array objectAtIndex:indexPath.row];
            [delegate onChannelIndicesData:p];
        }
        else if(ChannelRegionalIndices == channel) {
            KiRegionalIndices *regIndices = [array objectAtIndex:indexPath.row];
            KiRegionalIndicesData *p = [[DBLite sharedInstance] getRegionalIndicesDataById:regIndices.codeId];;
            [delegate onChannelRegionalIndicesData:p];
        }
        else if(ChannelFuture == channel) {
            KiFuture *future = [array objectAtIndex:indexPath.row];
            [delegate onChannelFuture:future];
        }
        
        
    }
    else {
        if(ChannelIndices == channel) {
            [delegate onHttpChannelIndices:[array objectAtIndex:indexPath.row]];
        }
        else if(ChannelRegionalIndices == channel) {
            [delegate onHttpChannelRegional:[array objectAtIndex:indexPath.row]];
        }
        else if(ChannelFuture == channel) {
            [delegate onHttpChannelFuture:[array objectAtIndex:indexPath.row]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark
#pragma separatorImage

- (UIImage *)separatorImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 4.0));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:28/255.0 green:28/255.0 blue:27/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1.0, 2.0));
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:79/255.0 green:79/255.0 blue:77/255.0 alpha:1.0].CGColor);
    CGContextFillRect(context, CGRectMake(0, 3.0, 1.0, 2.0));
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:outputImage.CGImage scale:2.0 orientation:UIImageOrientationUp];
}

@end




@implementation ChannelCurrencyViewCell

@synthesize noLabel, codeLabel, nameLabel;

- (id) init
{
    if(self = [super init]) {
        int width = self.frame.size.width * .1;
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width, 20)];
        codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + width, 0, self.frame.size.width * .2, 20)];
        width += codeLabel.frame.size.width;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + width, 0, self.frame.size.width * .6, 20)];
        
        noLabel.text = @"No";
        codeLabel.text = @"Code";
        nameLabel.text = @"Against";
        
        noLabel.textAlignment = NSTextAlignmentRight;
        
        [noLabel setFont:[UIFont systemFontOfSize:14]];
        [codeLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        
        noLabel.backgroundColor = [UIColor blackColor];
        codeLabel.backgroundColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor blackColor];
        
        noLabel.textColor = [UIColor whiteColor];
        codeLabel.textColor = [UIColor whiteColor];
        nameLabel.textColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:noLabel];
        [self addSubview:codeLabel];
        [self addSubview:nameLabel];
        
    }
    
    return self;
}

@end

@implementation ChannelIndicesViewCell

@synthesize noLabel, codeLabel;

- (id) init
{
    if(self = [super init]) {
        int width = self.frame.size.width * .1;
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width, 20)];
        codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + width, 0, self.frame.size.width * .9, 20)];
        width += codeLabel.frame.size.width;
        
        noLabel.text = @"No";
        codeLabel.text = @"Name";
        
        noLabel.textAlignment = NSTextAlignmentRight;
        
        [noLabel setFont:[UIFont systemFontOfSize:14]];
        [codeLabel setFont:[UIFont systemFontOfSize:14]];
        
        noLabel.backgroundColor = [UIColor blackColor];
        codeLabel.backgroundColor = [UIColor blackColor];
        
        noLabel.textColor = [UIColor whiteColor];
        codeLabel.textColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:noLabel];
        [self addSubview:codeLabel];
        
    }
    
    return self;
}

@end

@implementation ChannelRegionalIndicesViewCell

@synthesize noLabel, codeLabel, nameLabel;

- (id) init
{
    if(self = [super init]) {
        int width = self.frame.size.width * .1;
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width, 20)];
        codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + width, 0, self.frame.size.width * .3, 20)];
        width += codeLabel.frame.size.width;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + width, 0, self.frame.size.width * .6, 20)];
        
        noLabel.text = @"No";
        codeLabel.text = @"Code";
        nameLabel.text = @"Name";
        
        noLabel.textAlignment = NSTextAlignmentRight;
        
        [noLabel setFont:[UIFont systemFontOfSize:14]];
        [codeLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        
        noLabel.backgroundColor = [UIColor blackColor];
        codeLabel.backgroundColor = [UIColor blackColor];
        nameLabel.backgroundColor = [UIColor blackColor];
        
        noLabel.textColor = [UIColor whiteColor];
        codeLabel.textColor = [UIColor whiteColor];
        nameLabel.textColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:noLabel];
        [self addSubview:codeLabel];
        [self addSubview:nameLabel];
        
    }
    
    return self;
}

@end
