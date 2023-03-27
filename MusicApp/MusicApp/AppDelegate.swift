//
//  AppDelegate.swift
//  MusicApp
//
//  Created by Markus Flandorfer on 27.03.23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        Task {
            await registerForRemoteNotification()
        }

        return true
    }

    func application(
        _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print ("deviceToken (store on BE): \(deviceToken.map { String(format: "%02.2hhx", $0) }.joined())")
    }

    func application(
        _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print ("Error: \(error)")
    }

    private func registerForRemoteNotification() async  {
        _ = try? await  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])

        let settings = await UNUserNotificationCenter.current().notificationSettings()
        print("Settings \((settings.authorizationStatus))")

        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
