//
//  HealthKitManager.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 19/02/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import Foundation
import HealthKit

enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
}

class HealthKitManager {
    
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        //2. Prepare the data types that will interact with HealthKit
        guard   let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let minutesOfExercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
            let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = []
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount,
                                                       minutesOfExercise,
                                                       distanceWalkingRunning,
                                                       activeEnergy]
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
    
    func getData(type: HKQuantityTypeIdentifier, unit: HKUnit, days: Int, completed: @escaping (Result<[Int], Error>) -> Void) {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1
        
        let quantityType = HKQuantityType.quantityType(forIdentifier: type)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        query.initialResultsHandler = {query, results, error in
            if let error = error {
                completed(.failure(error))
                return
            }
            
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: endDate as Date, wrappingComponents: false)
            var completeDataArray: [Int] = []
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let dayData = quantity.doubleValue(for: unit)
                        completeDataArray.append(Int(dayData))
                    }
                }
            }
            completed(.success(completeDataArray))
        }
        healthStore.execute(query)
    }
}
