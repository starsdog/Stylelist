//
//  StyleAppDelegate.m
//  Stylelist
//
//  Created by ling on 13/6/24.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "StyleAppDelegate.h"
#import "Flurry.h"

@implementation StyleAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Set differenct storyboard for iPhone with height and iPhone5
    [Flurry startSession:@"XN9BTJP36KD698C64Y2X"];
    [Flurry setCrashReportingEnabled:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    self.internetReach = [[Reachability reachabilityForInternetConnection]init];
    [self.internetReach startNotifier];
    [self updateInterfaceWithReachability: self.internetReach];
    
    self.FBController=[[FacebookHelper alloc]init];
    [self.FBController initcontroller];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScrennSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScrennSize.height == 568)
        {
            UIStoryboard *iPhone5Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone5" bundle:nil];
            UIViewController *initViewController = [iPhone5Storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = initViewController;
            [self.window makeKeyAndVisible];
        }
        else
        {
            UIStoryboard *iPhone5Storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
            UIViewController *initViewController = [iPhone5Storyboard instantiateInitialViewController];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = initViewController;
            [self.window makeKeyAndVisible];
        }
    }
    
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    
    /*
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"bottom-timeline-pressed.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom-timeline.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"bottom-closet-pressed.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"bottom-closet.png"]];
    */
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL*)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //return [[self.FBController facebook] handleOpenURL:url];
    BOOL ret=[self.FBController handleOpenURL:url];
    return ret;
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
    [self.FBController handleDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)changeTab:(int)Index
{
    [self.tabBarController setSelectedIndex:Index];
    
}

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    self.netStatus = [curReach currentReachabilityStatus];
    NSString* statusString= @"";
    switch (self.netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            NSLog(@"updateInterfaceWithReachability: Access not Available");
            break;
        }
            
        case ReachableViaWWAN:
        {
            statusString = @"Reachable WWAN";
            NSLog(@"updateInterfaceWithReachability: Reachable WWAN");
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            NSLog(@"updateInterfaceWithReachability: Reachable Wifi");
            break;
        }
    }
    
}

-(NetworkStatus)isNetworkConnect
{
    return self.netStatus;
}

@end
