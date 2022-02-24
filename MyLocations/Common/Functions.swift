//
//  Functions.swift
//  MyLocations
//
//  Created by Lagash Systems on 22/03/2020.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import Foundation

func afterDelay(_ seconds: Double, run: @escaping () -> Void) { DispatchQueue.main.asyncAfter(deadline: .now() + seconds,
                                  execute: run)
}

let applicationDocumentsDirectory : URL = {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError( _ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}
