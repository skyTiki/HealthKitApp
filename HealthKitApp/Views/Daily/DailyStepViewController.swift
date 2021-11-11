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
        let startDate = Calendar.current.startOfDay(for: endDate)
        
        HealthData.getStepCountSum(withStart: startDate, end: endDate) { results in
            print("results",  results)
            
            // 歩数の合計(明示的に関数内でcumulativeSumオプションを指定しているため強制アンラップする)
            self.stepDailyCount = results.sumQuantity()!.doubleValue(for: .count())
             
            // 画面に反映
            DispatchQueue.main.async {
                self.stepCountLabel.text = "\(self.stepDailyCount)"
            }
        }
    }
    
}

