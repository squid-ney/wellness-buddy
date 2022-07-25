//
//  HealthStore.swift
//  GrowSteps
//
//  Created by Sydney Achinger on 2/5/22.
//

import Foundation
import HealthKit


class HealthStore {
    
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable(){
            healthStore = HKHealthStore()
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        }
    }
    
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
                
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(
             quantityType: stepType,
             quantitySamplePredicate: nil,
             options: .cumulativeSum,
             anchorDate: startOfDay,
             intervalComponents: interval)
        
        query.initialResultsHandler =  { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void){
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
        }
    }
}
