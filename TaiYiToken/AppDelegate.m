//
//  AppDelegate.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/13.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomizedTabBarController.h"
#import "SwitchAccountVc.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动图延迟
    [NSThread sleepForTimeInterval:2.0];
    
    CustomizedTabBarController *csVC = [CustomizedTabBarController sharedCustomizedTabBarController];
    self.window.rootViewController = csVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
 
}


@end
