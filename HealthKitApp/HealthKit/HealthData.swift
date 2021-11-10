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
    
    static func getHealthKitStepCount(withStart: Date, end: Date, completion: @escaping(_ results : [HKSample]) -> Void) {
        
        print(withStart,"~", end,"までの歩数データを取得します")
        
        let predicate = HKQuery.predicateForSamples(withStart: withStart, end: end, options: [])
        // 歩数カウント
        let queryDescriptor: [HKQueryDescriptor] = [HKQueryDescriptor(sampleType: HKQuantityType(.stepCount), predicate: predicate)]
                                                
        let query = HKSampleQuery(queryDescriptors: queryDescriptor, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]) { query, results, error in
            if let error = error {
                fatalError("HKSampleQuery error:\(error.localizedDescription)")
            }
            
            if let results = results {
                completion(results)
            } else {
                fatalError("HKSampleQuery results was nil")
            }
            
        }
        
        healthStore.execute(query)
        
    }
}
