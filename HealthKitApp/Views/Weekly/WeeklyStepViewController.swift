//
//  WeeklyStepViewController.swift
//  HealthKitApp
//
//  Created by S-wayMock2 on 2021/11/10.
//

import UIKit
import HealthKit

class WeeklyStepViewController: UIViewController {
    
    var stepWeeklyCount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nowDate = Date()
        let startOfNowDate = Calendar.current.startOfDay(for: nowDate)
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: startOfNowDate)!
        
        HealthData.getStepCountSumPerDay(withStart: startDate, end: nowDate) { results in
            print("実行完了")
            results.forEach { print("step", $0.sumQuantity()!) }
        }
    }
}
