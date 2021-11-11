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
        
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)!
        
//        HealthData.getHealthKitStepCount(withStart: startDate, end: endDate) { results in
//        
//            guard let results = results as? [HKQuantitySample] else { return }
//            print(results)
//            
//            var stepCountSum = 0.0
//            for num in 0..<results.count {
//                stepCountSum += results[num].quantity.doubleValue(for: .count())
//            }
//            
//            self.stepWeeklyCount = stepCountSum
//            
//            print(self.stepWeeklyCount)
//            
//        }
        
    }
    
    
    
}
