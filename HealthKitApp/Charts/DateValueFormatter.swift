//
//  DateValueFormatter.swift
//  HealthKitApp
//
//  Created by S-wayMock2 on 2021/11/15.
//

import Foundation
import Charts

class DateValueFormatter: IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    var startDate:Date
    
    init(startDate:Date) {
        self.startDate = startDate
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 一週間前から設定
        let modifiedDate = Calendar.current.date(byAdding: .day, value: Int(value - 7), to: startDate)!
        dateFormatter.dateFormat = "M/d"
        
        return dateFormatter.string(from: modifiedDate)
    }
}
