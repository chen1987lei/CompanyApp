//
//  AppDelegate.m
//  CompanyApp
//
//  Created by chenlei on 15/12/2.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "AppDelegate.h"
#import "NCTabBarController.h"

#import "NCLoginViewController.h"

#import "NCInitial.h"
#import "NCUserConfig.h"
@interface AppDelegate ()
{
    UINavigationController *_tdNav;
}

@property(nonatomic,strong) NCTabBarController *tabBarController;

@end

@implementation AppDelegate

#define isLogin 1

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
  
    UIViewController *launchview = [[UIViewController alloc] init];
    self.window.rootViewController = launchview;
    
    WS(weakself)
    [[NCInitial sharedInstance] initialWithComplate:^(BOOL succeed, NSError *error) {
       
        [weakself showMainView];
    }];


    return YES;
}

-(void)showMainView
{
    self.tabBarController = [[NCTabBarController alloc] initWithNibName:nil bundle:nil];
    _tdNav = [[UINavigationController alloc] initWithRootViewController:self.tabBarController];
    _tdNav.navigationBarHidden = YES;
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = _tdNav;
    
    if (![NCUserConfig haslogin]) {
        [self showLoginViewController];
    }
    else
    {
        //先展示loadingview
        [self refreshHomeView];
    }
}

-(void)refreshHomeView
{
    [[NCInitial sharedInstance] requestHomeBannerWithComplate:^(NSDictionary *result, NSError *error) {
        
        
    }];
}

-(void)showLoginViewController
{
    NCLoginViewController *loginview=  [[NCLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginview];
    [_tdNav presentViewController:nav animated:YES completion:^{
        
        
    }];
    
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
