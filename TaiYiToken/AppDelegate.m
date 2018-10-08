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
#import "LaunchIntroductionView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //启动图延迟
   // [NSThread sleepForTimeInterval:2.0];
    
    CustomizedTabBarController *csVC = [CustomizedTabBarController sharedCustomizedTabBarController];
    self.window.rootViewController = csVC;
    [self.window makeKeyAndVisible];
    
    LaunchIntroductionView *launch = [LaunchIntroductionView sharedWithImages:@[@"launch0",@"launch1",@"launch2",@"launch3"]];
    launch.currentColor = [UIColor backBlueColorA];
    launch.nomalColor = [UIColor textLightGrayColor];
    //查找之后发现苹果在ios7之后提供了一个新的通知类型：UIApplicationUserDidTakeScreenshotNotification，这个通知会告知注册了此通知的对象已经发生了截屏事件，然后我们就可以在这个事件中实现自己的逻辑。
    
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
