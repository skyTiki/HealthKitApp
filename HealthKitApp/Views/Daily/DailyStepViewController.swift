//
//  DailyStepViewController.swift
//  HealthKitApp
//
//  Created by S-wayMock2 on 2021/11/10.
//

import UIKit
import HealthKit

class DailyStepViewController: UIViewController {
    
    
    @IBOutlet weak var stepCountLabel: UILabel!
    
    var stepDailyCount = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthData.requestAuthorization { success in
            if success {
                print("歩数を取得できます")
            } else {
                print("歩数を取得できます")
            }
        }
    }
    
    
    @IBAction func tappedGetStepCountButton(_ sender: Any) {
        
        let endDate = Date()
        let startOfDate = Calendar.current.startOfDay(for: endDate)
        
        HealthData.getHealthKitStepCount(withStart: startOfDate, end: endDate) { results in
            guard let results = results as? [HKQuantitySample] else { return }
            print("results", results.count , results)
            
            // 歩数の合計
            var stepCountSum = 0.0
            for num in 0..<results.count {
                stepCountSum += results[num].quantity.doubleValue(for: .count())
            }
            
            self.stepDailyCount = stepCountSum
             
            // 画面に反映
            DispatchQueue.main.async {
                self.stepCountLabel.text = "\(self.stepDailyCount)"
            }
        }
        
        
    }
    
}

