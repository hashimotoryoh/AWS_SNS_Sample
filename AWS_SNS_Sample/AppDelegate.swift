//
//  AppDelegate.swift
//  AWS_SNS_Sample
//
//  Created by Ryoh Hashimoto on 2016/12/08.
//  Copyright © 2016年 Ryoh Hashimoto. All rights reserved.
//

import UIKit
import AWSSNS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AWSCredentialsProvider {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ユーザにプッシュ通知の許可を促す(iOS8以降の書き方)
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert,
                                                                                     UIUserNotificationType.sound,
                                                                                     UIUserNotificationType.badge],
                                                                             categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - プッシュ通知許可願いのデリゲート
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let deviceTokenString:String = String(format: "%@", deviceToken as CVarArg)
            .trimmingCharacters(in: CharacterSet.init(charactersIn: "<>"))
            .replacingOccurrences(of: " ", with: "")
        
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceToken");
        
        AWSServiceManager.default().defaultServiceConfiguration = AWSServiceConfiguration(region:AWSRegionType.usWest2, credentialsProvider: self)
        let sns:AWSSNS = AWSSNS.default()
        
        let input = AWSSNSCreatePlatformEndpointInput()
        input?.token                  = deviceTokenString
        input?.platformApplicationArn = AWS_APPLICATION_ARN
        
        sns.createPlatformEndpoint(input!, completionHandler: { (response, error) -> Void in
            if (error == nil) {
                let endpointArn:String! = (response! as AWSSNSCreateEndpointResponse).endpointArn!
                    .trimmingCharacters(in: CharacterSet.init(charactersIn: "\"\""))
                print(endpointArn)
                UserDefaults.standard.set(endpointArn, forKey: "endpointArn")
                
                self.window?.rootViewController?.loadView()
                self.window?.rootViewController?.viewDidLoad()
            }
            else {
                print(error ?? "A")
            }
        })
        
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let alert = UIAlertView(title: "Error", message: "デバイストークン取得失敗", delegate: nil, cancelButtonTitle: "閉じる")
        alert.show()
    }
    
    
    // MARK: - AWSCredentialsProvider Overrides
    public func credentials() -> AWSTask<AWSCredentials>
    {
        return AWSTask.init(result: AWSCredentials.init(accessKey: AWS_ACCESS_KEY,
                                                        secretKey: AWS_SECRET_KEY,
                                                        sessionKey: nil,
                                                        expiration: nil))
    }
    
    public func invalidateCachedTemporaryCredentials()
    {
        // これはようわからん
    }

}

