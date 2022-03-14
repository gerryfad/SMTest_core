//
//  NotificationManager.swift
//
//  Created by Rifat Firdaus on 9/7/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit
import RealmSwift

// Commented Function used in specific project (Comcon)
//

class NotificationManager: NSObject {
    
    static let instance = NotificationManager()
    
    // Used If notif manage in local Realm
    //
//    var notifsCount: Int {
//        let realm = try! Realm()
//        print(realm.configuration.fileURL!.absoluteString)
//        let queryString = "isRead==0 AND eventId==\(PreferenceManager.instance.eventId!)"
//        print(queryString)
//        let notifs = realm.objects(PushNotification.self).filter(queryString)
//        print("count notifs \(notifs.count)")
//        return notifs.count
//    }
    
    // Used If notif manage in local Realm
    //
//    func updateNotifRead(_ notification: PushNotification) {
//        let realm = try! Realm()
//        try! realm.write({
//            let notif = PushNotification(value: notification)
//            notif.isRead = 1
//            realm.create(PushNotification.self, value: notif, update: .all)
//        })
//    }
    
//    func updateNotifShown() {
//        let realm = try! Realm()
//        let notifs = realm.objects(PushNotification.self).filter("isSeen==0")
//        for notif in notifs {
//            try! realm.write({
//                let notif = PushNotification(value: notif)
//                notif.isSeen = 1
//                realm.create(PushNotification.self, value: notif, update: .all)
//            })
//        }
//    }
    
//    func isScheduled(_ schedule: Schedule) -> Bool {
//        guard let _ = schedule.timeSlot else {
//            return false
//        }
//        let identifier = notificationIdentifier(schedule)
//        var isSchedule = false
//        let notifCenter = UNUserNotificationCenter.current()
//        notifCenter.getPendingNotificationRequests { (requests) in
//            for request in requests {
//                let userInfo = request.content.userInfo
//                guard let id = userInfo["identifier"] as? String else {
//                    continue
//                }
//                if identifier == id {
//                    isSchedule = true
//                }
//            }
//        }
//        return isSchedule
//    }
    

    //    func notificationIdentifier(_ schedule: Schedule) -> String {
    //        return "\(schedule.identifier)"
    //    }
    
    func unscheduleLocalNotificationWithSchedule(_ identifier: String = "0") {
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.getPendingNotificationRequests { (requests) in
            for request in requests {
                let userInfo = request.content.userInfo
                guard let id = userInfo["identifier"] as? String else {
                    continue
                }
                if identifier == id {
                    notifCenter.removePendingNotificationRequests(withIdentifiers: [id])
                    return
                }
            }
        }
    }
    
    func setupScheduleNotification(title: String? = "", body: String? = "", type:String? = "", identifier: String = "0", date: Date, testMode: Bool) {
        let notifCenter = UNUserNotificationCenter.current()
        
        // Active mode
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        
        if testMode {
            // Test mode
            let dateTest = Date(timeIntervalSinceNow: 10)
            triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: dateTest)
        }
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.body = body ?? ""
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notifCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
}
