//
//  EditViewController.m
//  NotificationQuicklyReplyDemo
//
//  Created by yyp on 15/5/15.
//  Copyright (c) 2015年 Mingdao. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *replyArr;
@property (assign, nonatomic) BOOL isEditing;

@end

@implementation EditViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"自定义通知快捷回复";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
    [self loadData];
}

- (void)editAction
{
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self.tableView reloadData];
        [self.tableView setEditing:self.isEditing animated:YES];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editAction)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addReplyAction)];
    } else {
        [self.tableView reloadData];
        [self.tableView setEditing:self.isEditing animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction)];
        self.navigationItem.leftBarButtonItem = nil;
        
    }

}

- (void)finishEdit
{
    [[NSUserDefaults standardUserDefaults] setObject:self.replyArr forKey:@"reply"];
    [self registerPushServiceWithSetting];
}

- (void)registerPushServiceWithSetting
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        NSArray *replyArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"reply"];
        NSMutableArray *actionsArr = [NSMutableArray array];
        for (NSInteger i = 0; i < replyArr.count ; i ++) {
            NSDictionary *dic = replyArr[i];
            if ([dic[@"status"] isEqualToString:@"selected"]) {
                UIMutableUserNotificationAction *quickReply = [[UIMutableUserNotificationAction alloc]init];
                quickReply.identifier = [NSString stringWithFormat:@"quickReply%ld",i];
                quickReply.title = dic[@"reply"];
                quickReply.activationMode = UIUserNotificationActivationModeBackground;
                quickReply.authenticationRequired = NO;
                [actionsArr addObject:quickReply];
            }
        }
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
        category.identifier = @"detail-reply";
        [category setActions:actionsArr forContext:UIUserNotificationActionContextMinimal];
        [category setActions:actionsArr forContext:UIUserNotificationActionContextDefault];
        
        UIUserNotificationSettings *set = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:category,nil]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:set];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}


- (void)loadData
{
    self.replyArr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"reply"] mutableCopy];
    if (self.replyArr.count == 0) {
        [self.replyArr addObject:@"OK"];
        [self.replyArr addObject:@"收到"];
    }
    [self.tableView reloadData];
}

- (void)addReplyAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入您自定义的回复", @"输入您自定义的回复") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", @"确定") style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                UITextField *tf = alert.textFields.firstObject;
                                                if (tf.text.length > 0) {
                                                    [self.replyArr addObject:tf.text];
                                                    [self.tableView reloadData];
                                                }
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", @"取消")  style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.replyArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.replyArr[indexPath.row];
    return cell;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.replyArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *str = self.replyArr[fromIndexPath.row];
    [self.replyArr removeObject:str];
    [self.replyArr insertObject:str atIndex:toIndexPath.row];
    
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
