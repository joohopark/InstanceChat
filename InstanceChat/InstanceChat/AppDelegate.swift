//
//  AppDelegate.swift
//  InstanceChat
//
//  Created by 주호박 on 2018. 8. 6..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit
// google Login import
import Firebase
import GoogleSignIn

var Usertoken:String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Firebase 초기화
        FirebaseApp.configure()
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID//"YOUR_CLIENT_ID"
        GIDSignIn.sharedInstance().delegate = self as! GIDSignInDelegate
        
        print(Usertoken ?? "아직 토큰 값 없음")
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if  user == nil {
                // 로그인 다시 해야됨.
                print("아직 로긴 안됨요")
                let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let next = storboard.instantiateViewController(withIdentifier: "ChooseLoginViewController") as! ChooseLoginViewController
                let navi = UINavigationController(rootViewController: next)
                self.window?.rootViewController = navi
                self.window?.makeKeyAndVisible()
            } else {
                // 로그인 되었을때.
                Usertoken = user?.uid
                print(Usertoken ?? "아직 토큰 값 없음?")
                let storboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var mainVc = storboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navi = UINavigationController(rootViewController: mainVc)
                self.window?.rootViewController = navi
                self.window?.makeKeyAndVisible()
            }
        }

        return true
    }
    
    // firebase
    // 인증 이후 받는 URL 자동으로 처리
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
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


}

extension AppDelegate: GIDSignInDelegate{
    // Login Process(구글)
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("Token 생성전 err")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        // credential에 token 값이 담기고 이걸 signIn으로 넘겨주면 인증됨.
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print("Token 생성후 err")
                return
            }
            // User is signed in
            // ...
        }
    
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

