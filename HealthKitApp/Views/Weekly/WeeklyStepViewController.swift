//
//  WeeklyStepViewController.swift
//  HealthKitApp
//
//  Created by S-wayMock2 on 2021/11/10.
//

import UIKit
import Charts
import HealthKit

class WeeklyStepViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var stepWeeklyCount = 0.0
    
    var entries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nowDate = Date()
        let startOfNowDate = Calendar.current.startOfDay(for: nowDate)
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: startOfNowDate)!
        
        HealthData.getStepCountSumPerDay(withStart: startDate, end: nowDate) { results in
            print("実行完了")
            results.forEach { print("step", $0.sumQuantity()!) }
            
            DispatchQueue.main.async {
                
                self.setChartViewData(data: results)
                self.updateCharView()
            }
        }
    }
    
    
    private func setChartViewData(data: [HKStatistics]) {
        
        for (index, statistic) in data.enumerated() {
            self.entries.append(ChartDataEntry(x: Double(index), y: statistic.sumQuantity()!.doubleValue(for: .count())))
        }
    }
    
    
    private func updateCharView() {
        let chartDataSet = LineChartDataSet(entries: entries, label: "歩数")
        
        lineChartView.data = LineChartData(dataSet: chartDataSet)
        
    }
}
