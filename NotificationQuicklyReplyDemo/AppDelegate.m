//
//  AppDelegate.m
//  NotificationQuicklyReplyDemo
//
//  Created by yyp on 15/5/15.
//  Copyright (c) 2015年 Mingdao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    [self registerPushServiceWithSetting];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    return YES;
}


- (void)registerPushServiceWithSetting
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        NSArray *replyArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"reply"];
        NSMutableArray *actionsArr = [NSMutableArray array];
        for (NSInteger i = 0; i < replyArr.count ; i ++) {
               //Action方法
                UIMutableUserNotificationAction *quickReply = [[UIMutableUserNotificationAction alloc]init];
                quickReply.identifier = [NSString stringWithFormat:@"quickReply%ld",i];
                quickReply.title = replyArr[i];
                quickReply.activationMode = UIUserNotificationActivationModeBackground;
                quickReply.authenticationRequired = NO;
                [actionsArr addObject:quickReply];
        }
        //使用category来标记某一种通知类型，比如说收到消息
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc]init];
        category.identifier = @"detail-reply";
        //把Action方法加入相应的category
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

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //通过identifier来判断点击的是哪个按钮，然后执行对应的操作
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"reply"] copy];
    for (NSInteger i = 0; i < arr.count ; i ++) {
        if ([identifier isEqualToString:[NSString stringWithFormat:@"quickReply%ld",i]]) {
            NSLog(@"quickReply %ld",i);
        }

    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
