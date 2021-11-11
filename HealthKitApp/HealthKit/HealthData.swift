//
//  HealthData.swift
//  HealthKitApp
//
//  Created by S-wayMock2 on 2021/11/10.
//

import Foundation
import HealthKit

class HealthData {
    
    static let healthStore = HKHealthStore()
    
    static var readHealthDataTypes: Set<HKSampleType> {
        [
            // 必要に応じて追加
            HKQuantityType(.stepCount)
        ]
    }
    
    
    static func requestAuthorization(completion: @escaping(_ success: Bool) -> Void) {
        
        // デバイスが使用可能かどうか
        // TODO: fatalErrorではなくダイアログとかにする
        if !HKHealthStore.isHealthDataAvailable() { fatalError("デバイスが対応していません") }
        
        // ユーザーに許可を得る
        healthStore.requestAuthorization(toShare: [], read: readHealthDataTypes) { success, error in
            if let error = error {
                print("requestAuthorization error:", error.localizedDescription)
            }
            
            print(success ? "requestAuthorization was success" : "requestAuthorization was not success")
            
            completion(success)
            
        }
        
    }
    
    // 指定した期間の歩数の合計を取得
    static func getStepCountSum(withStart: Date, end: Date, completion: @escaping(_ results : HKStatistics) -> Void) {
        
        print(withStart,"~", end,"までの歩数データを取得します")
        
        let predicate = HKQuery.predicateForSamples(withStart: withStart, end: end, options: [])
        
        let query = HKStatisticsQuery(quantityType: HKQuantityType(.stepCount), quantitySamplePredicate: predicate, options: .cumulativeSum) { query, results, error in
            guard let results = results, error == nil else {
                fatalError("HKStatisticsQuery error:\(error!.localizedDescription)")
            }
            
            completion(results)
        }
        healthStore.execute(query)
    }
    
    // 指定した期間の1日ごとの歩数を取得
    static func getStepCountSumPerDay(withStart: Date, end: Date, completion: @escaping(_ results: [HKStatistics]) -> Void) {
        print(withStart,"~", end, "までの歩数データを1日ごとに取得します")
        
        let predicate = HKQuery.predicateForSamples(withStart: withStart, end: end)
        
        // 間隔を定義
        let interval = DateComponents(day: 1)
        
        // 合計値を取得
        let query = HKStatisticsCollectionQuery(quantityType: HKQuantityType(.stepCount), quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: withStart, intervalComponents: interval)
        
        // ハンドラー定義
        query.initialResultsHandler = { query, collection, error in
            guard let collection = collection, error == nil else { return }
            
            // 配列を取得
            let statisticArray: [HKStatistics] = collection.statistics()
            completion(statisticArray)
        }
        
        healthStore.execute(query)
    }
}
