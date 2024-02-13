//
//  lasLukasApp.swift
//  lasLukas
//
//  Created by Geovanny Valdes on 13/06/23.
//

import SwiftUI
import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct lasLukasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .login:
                    LoginView()
                    
                case .home:
                    ContentView()
                }
            }
            .environmentObject(appRootManager)
            .onAppear(){
                if Auth.auth().currentUser != nil{
                    appRootManager.currentRoot = .home
                }
            }
        }
    }
}
