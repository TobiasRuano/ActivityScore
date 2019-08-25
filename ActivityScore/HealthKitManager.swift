//
//  HealthKitManager.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 15/07/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    public static let shared = HealthKitManager()
    
    var indiceSteps = 0
    var indiceCal = 0
    var indiceExe = 0
    var indiceDis = 0
    
    var arrayCal = [Int]()
    var arraySteps = [Int]()
    var arrayExe = [Int]()
    var arrayDis = [Double]()
    
//    public static func getInstance () -> HealthKitManager {
//        if shared == nil {
//            shared = HealthKitManager()
//            print("Creo instancia")
//            return shared
//        } else {
//            print("NO Creo instancia")
//            return shared
//        }
//    }
    
//    private init() {
//    }
    
    //MARK: - Authorize HealthKit
    func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        //2. Prepare the data types that will interact with HealthKit
        guard let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let minutesOfExercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
            let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = []
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount, minutesOfExercise, distanceWalkingRunning, activeEnergy]
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    //MARK: - Get functions
    func getLast7daysSteps() -> [Double]{
        return getData(type: .stepCount, unit: .count(), indicator: 0)
    }
    
    func getLast7daysCalories() -> [Double]{
        return getData(type: .activeEnergyBurned, unit: .kilocalorie(), indicator: 1)
    }
    
    func getLast7daysExercise() -> [Double]{
        return getData(type: .appleExerciseTime, unit: .minute(), indicator: 2)
    }
    
    func getLast7daysDistance() -> [Double]{
        return getData(type: .distanceWalkingRunning, unit: .meter(), indicator: 3)
    }
    
    private func getData(type: HKQuantityTypeIdentifier, unit: HKUnit, indicator: Int) -> [Double]{
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        var array = [Double]()
        interval.day = 1
        
        let data = HKQuantityType.quantityType(forIdentifier: type)!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        // Define 1-day intervals starting from 0:00
        let dataQuery = HKStatisticsCollectionQuery(quantityType: data, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
        
        // Set the results handler
        dataQuery.initialResultsHandler = {query, results, error in
            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate as Date, wrappingComponents: false)
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let dataObtained = quantity.doubleValue(for: unit)
                        print("\(date): \(unit) = \(dataObtained)")
                        self.addToArray(item: dataObtained, indicator: indicator)
                        array.append(dataObtained)
                    }
                }
            }
        }
        healthKitStore.execute(dataQuery)
        return array
    }
    
    func addToArray(item: Double, indicator: Int) {
        switch indicator {
        case 0:
            arraySteps.append(Int(item))
            indiceSteps += 1
            print("Added to the Step Array")
        case 1:
            arrayCal.append(Int(item))
            indiceCal += 1
            print("Added to the Calories Array")
        case 2:
            arrayExe.append(Int(item))
            indiceExe += 1
            print("Added to the Exercise Array")
        case 3:
            arrayDis.append(item)
            indiceDis += 1
            print("Added to the Distance Array")
        default:
            break
        }
    }
}
