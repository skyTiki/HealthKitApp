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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nowDate = Date()
        let startOfNowDate = Calendar.current.startOfDay(for: nowDate)
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: startOfNowDate)!
        
        HealthData.getStepCountSumPerDay(withStart: startDate, end: nowDate) { results in
            print("実行完了")
            results.forEach { print("step", $0.sumQuantity()!) }
            
            DispatchQueue.main.async {
                
                self.updateChartView(data: results)
            }
        }
    }
    
    // ChartViewの更新
    private func updateChartView(data: [HKStatistics]) {
        // データセットの作成
        let lineChartDataSet = setChartViewData(data: data)
        // ChartViewに設定
        configureChartView(lineChartDataSet: lineChartDataSet)
    }
    
    // データの作成処理
    private func setChartViewData(data: [HKStatistics]) -> LineChartDataSet {
        
        var entries: [ChartDataEntry] = []
        
        for (index, statistic) in data.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: statistic.sumQuantity()!.doubleValue(for: .count())))
        }
        
        // データセットの設定
        let lineChartDataSet = LineChartDataSet(entries: entries, label: "歩数")
        lineChartDataSet.lineWidth = 1.5
        lineChartDataSet.mode = .cubicBezier // グラフを曲線に変更
        lineChartDataSet.drawCirclesEnabled = false // 各データに丸ポチを設定しない
        lineChartDataSet.setColor(.cyan) // 線の色
        
        // 面の設定
        lineChartDataSet.fill = Fill(color: .cyan)
        lineChartDataSet.fillAlpha = 0.2
        lineChartDataSet.drawFilledEnabled = true
        
        
        return lineChartDataSet
    }
    
    // ChartViewの設定処理
    private func configureChartView(lineChartDataSet: LineChartDataSet) {

        
        lineChartView.data = LineChartData(dataSet: lineChartDataSet)
        lineChartView.backgroundColor = .systemGray3
        lineChartView.data?.setValueTextColor(.white)
        lineChartView.data?.setValueFont(.systemFont(ofSize: 14, weight: .bold))
        
        // Y軸
        lineChartView.rightAxis.enabled = false // 右側のy軸の目盛りを削除
        lineChartView.leftAxis.labelTextColor = .gray
        
        // X軸
        lineChartView.xAxis.labelPosition = .bottom //下に目盛りを表示
        lineChartView.xAxis.labelTextColor = .gray
        
        
    }
}
