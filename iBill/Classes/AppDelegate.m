//
//  AppDelegate.m
//  iBill
//
//  Created by WebToGo on 11/13/15.
//  Copyright © 2015 WebToGo GmbH. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // Setup local push notification center
    [self setupLocalNotificationCenter:application launchOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSUInteger localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications].count;
    if (localNotifications > 0) application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - UILocalNotification delegate

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) {
        [[[UIAlertView alloc] initWithTitle:@"iBill" message:notification.alertBody delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil] show];
    }
    application.applicationIconBadgeNumber = 0;
}

# pragma mark - Auxiliary function

/**
 * Auxiliary function that setups the local notification center
 * @param application The application that has just been started
 * @param launchOptions The dictionary with the launching options
 */
- (void)setupLocalNotificationCenter:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    // First, register for user notifications settings
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){ // iOS 8 or later
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    UILocalNotification *locationNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) application.applicationIconBadgeNumber = 0; // Set icon badge number to zero
}

@end
