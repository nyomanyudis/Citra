//
//  SettingV3.m
//  Ciptadana
//
//  Created by Reyhan on 12/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SettingV3.h"
#import "Agent.h"
#import "SystemAlert.h"
#import "UITextField+Addons.h"


@interface SettingV3 () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonnull) SettingApp *settingApp;

@end

@implementation SettingV3

//- (void)viewWillDisappear:(BOOL)animated
//{
//    UITableViewCell *cellHost = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    UITableViewCell *cellPort = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    UITableViewCell *cellOrderStatus = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    UITableViewCell *cellOrderConfirm = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//
//    NSString *host, *port;
//    BOOL popupStatus, popupConfirm;
//    
//    host = ((UITextField *)[cellHost.contentView.subviews objectAtIndex:1]).text;
//    port = ((UITextField *)[cellPort.contentView.subviews objectAtIndex:1]).text;
//    popupStatus = ((UISwitch *)[cellOrderStatus.contentView.subviews objectAtIndex:1]).on;
//    popupConfirm = ((UISwitch *)[cellOrderConfirm.contentView.subviews objectAtIndex:1]).on;
//    
//    if(port.length > 0 && host.length > 0) {
//        //port = @"1234";
//        
//        SettingApp *set = [[SettingApp alloc] init];
//        set.host = host;
//        set.port = [port intValue];
//        set.popstatus = popupStatus;
//        set.popsconfirm = popupConfirm;
//        
//        [SettingV3 saveSetting:set];
//    }
//    else {
//        SettingApp *set = [[SettingApp alloc] init];
//        set.host = @"";
//        set.port = -1;
//        set.popstatus = NO;
//        set.popsconfirm = YES;
//        
//        [SettingV3 saveSetting:set];
//    }
//    
//}

-(void) actionbuttonSave:(id)sender {
    NSLog(@"actionbuttonSave");
    UITableViewCell *cellHost = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cellPort = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITableViewCell *cellOrderStatus = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    UITableViewCell *cellOrderConfirm = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *host, *port;
    BOOL popupStatus;
    
    host = ((UITextField *)[cellHost.contentView.subviews objectAtIndex:1]).text;
    port = ((UITextField *)[cellPort.contentView.subviews objectAtIndex:1]).text;
    popupStatus = ((UISwitch *)[cellOrderStatus.contentView.subviews objectAtIndex:1]).on;
//    popupConfirm = ((UISwitch *)[cellOrderConfirm.contentView.subviews objectAtIndex:1]).on;
    
    SettingApp *set = [[SettingApp alloc] init];
    
    if(port.length > 0 && host.length > 0) {
        //port = @"1234";
        set.host = host;
        set.port = [port intValue];
        set.popstatus = popupStatus;
//        set.popsconfirm = popupConfirm;
    }
    else {
        set.host = @"";
        set.port = -1;
        set.popstatus = NO;
//        set.popsconfirm = YES;
    }
    
    NSString *message = @"";
    
    if([SettingV3 saveSetting:set]){
        message = @"Save success";
    }
    else{
        message = @"Save failed";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:false message:message delegate:self cancelButtonTitle:false otherButtonTitles:@"OK", nil];
    
    [alert show];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table.dataSource = self;
    self.table.separatorColor = [UIColor clearColor];
//
    self.settingApp = [SettingV3 loadSetting];
    
    
    
    NSLog(@"settingApp = %@",self.settingApp);

//    NSString *json = [[NSUserDefaults standardUserDefaults] stringForKey:STORAGESETTINGKEY];
//    NSError *error;
//    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//    NSMutableDictionary *dictSetting = [jsonObject objectForKey:@"setting"];
//
//    
//    NSString *host = [dictSetting objectForKey:@"HOST"];
//    NSNumber *port = [dictSetting objectForKey:@"PORT"];
//    BOOL popupStatus = [[dictSetting objectForKey:@"POPUPSTATUS"] isEqualToString:@"YES"] ? YES : NO;
//    BOOL popupConfirm = [[dictSetting objectForKey:@"POPUPCONFIRM"] isEqualToString:@"YES"] ? YES : NO;
//    
//    NSLog(@"viewdidLoadSetting ");
//    NSLog(@"host = %@",host);
//    NSLog(@"port = %@",port);
//    NSLog(@"popUpStatus = %hhd",popupStatus);
//    NSLog(@"popupConfirm = %hhd",popupConfirm);
//    
//    
//    [self performSelector:@selector(loadSettings:) withObject:nil];
//    SettingApp *setting = [SettingV3 loadSetting];
//    if(setting && setting.port >  0) {
//        [self performSelector:@selector(loadSettings:) withObject:setting];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private

- (IBAction)resetTapped:(id)sender
{
    SettingApp *set = [[SettingApp alloc] init];
    set.host = @"";
    set.port = -1;
    set.popstatus = NO;
    set.popsconfirm = YES;
    self.settingApp = set;
    [self.table reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"IP = %@",self.settingApp.host);
    NSLog(@"Port = %u",self.settingApp.port);
    NSLog(@"PopStatus = %hhd",self.settingApp.popstatus);
//    NSLog(@"PopConfirm = %hhd",self.settingApp.popsconfirm);
    
    UITableViewCell *cell;
    if(!cell) {
        NSLog(@"indexPath.row = %d",indexPath.row);
        int32_t index = 0;
        if(indexPath.row == 0 | indexPath.row == 1 )
            index = 0;
        else if(indexPath.row == 2)
            index = 1;
        else if(indexPath.row == 3)
            index = 3;
//        int32_t index = indexPath.row < 2 ? 0 : 1;
        NSLog(@"index = %d",index);
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil] objectAtIndex:index];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for(id tmp in cell.contentView.subviews) {
            if([tmp isMemberOfClass:[UILabel class]]) {
                UILabel *label = tmp;
                if(indexPath.row == 0)
                    label.text = @"HOST";
                else if(indexPath.row == 1)
                    label.text = @"PORT";
                else if(indexPath.row == 2)
                    label.text = @"Popup Order Status";
//                else if(indexPath.row == 3)
//                    label.text = @"Popup Order Confirm";
            }
            else if([tmp isMemberOfClass:[UISwitch class]]) {
                UISwitch *sw = tmp;
                if(self.settingApp && self.settingApp.host.length > 0) {
                    if(indexPath.row == 2)
                        sw .on = self.settingApp.popstatus;
//                    else if(indexPath.row == 3) {
//                        sw .on = self.settingApp.popsconfirm;
//                        sw.enabled = NO;
//                    }
                    
                }
                else  {
                    if(indexPath.row == 2)
                        sw .on = NO;
//                    else if(indexPath.row == 3)
//                        sw .on = YES;
                }
            }
            else if([tmp isMemberOfClass:[UITextField class]]) {
                UITextField *text = tmp;
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 10, 15)];
                text.leftView = paddingView;
                text.leftViewMode = UITextFieldViewModeAlways;
//                text.enabled = NO;
                if(indexPath.row == 1)
                    text.keyboardType = UIKeyboardTypeNumberPad;
                
                if(self.settingApp && self.settingApp.host.length > 0) {
                    if(indexPath.row == 0)
                        text.text = self.settingApp.host;
                    else if(indexPath.row == 1)
                        text.text = [NSString stringWithFormat:@"%d", self.settingApp.port];
                }
                
                [text initLeftRightButtonKeyboardToolbar:@"Hide" labelRight:@"Save" target:self selectorLeft:@selector(hideStep:) selectorRight:@selector(actionbuttonSave:)];
            }
            else if([tmp isMemberOfClass:[UIButton class]]) {
                UIButton *button = tmp;
                [button addTarget:self
                           action:@selector(actionbuttonSave)
                 forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:@"Save" forState:UIControlStateNormal];
                
            }
        }
    }
    
    return cell;
}

#pragma public static

+ (BOOL)saveSetting:(SettingApp *)setting
{
    /**
     {
     "setting":{
     "host":"10.10.1.1",
     "port":1234,
     "popstatus":"NO",
     "popconfirm":"YES"
     }
     }
     **/
    if(setting) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:setting.host forKey:@"HOST"];
        [dictionary setValue:[NSNumber numberWithInt:setting.port] forKey:@"PORT"];
        [dictionary setValue:(setting.popstatus ? @"YES" :@"NO") forKey:@"POPUPSTATUS"];
//        [dictionary setValue:(setting.popsconfirm ? @"YES" :@"NO") forKey:@"POPUPCONFIRM"];
        
        NSDictionary *dictSet = [NSDictionary dictionaryWithObject:dictionary forKey:@"setting"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictSet
                                                           options:0 // Pass 0 if you don't care about the readability of the generated string
                                                             error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:STORAGESETTINGKEY];
        return [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (void)hideStep:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

+ (SettingApp *)loadSetting
{
    NSString *json = [[NSUserDefaults standardUserDefaults] stringForKey:STORAGESETTINGKEY];
    NSLog(@"json = %@",json);
    if(json) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSError *error;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSMutableDictionary *dictSetting = [jsonObject objectForKey:@"setting"];
        
        if(dictSetting) {
            
                
            NSString *host = [dictSetting objectForKey:@"HOST"];
            NSNumber *port = [dictSetting objectForKey:@"PORT"];
            BOOL popupStatus = [[dictSetting objectForKey:@"POPUPSTATUS"] isEqualToString:@"YES"] ? YES : NO;
    
            
            SettingApp *app = [[SettingApp alloc] init];
            app.host = host;
            app.port = [port intValue];
            app.popstatus = popupStatus;
                        
            return app;
            
        }
    }
    
    return nil;
}

@end

@implementation SettingApp

@end
