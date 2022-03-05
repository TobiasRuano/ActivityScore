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
        // 1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        // 2. Prepare the data types that will interact with HealthKit
        guard   let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount),
            let minutesOfExercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
            let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        let activitySummaryType = HKObjectType.activitySummaryType()
        // 3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = []
        let healthKitTypesToRead: Set<HKObjectType> = [stepCount,
                                                       minutesOfExercise,
                                                       distanceWalkingRunning,
                                                       activeEnergy,
                                                       activitySummaryType]
        // 4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }

    func getUserGoal(completed: @escaping(Result<(Int, Int), Error>) -> Void) {
        let calendar = NSCalendar.current
        let endDate = Date()

        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
            fatalError("*** Unable to create the start date ***")
        }

        let units: Set<Calendar.Component> = [.day, .month, .year, .era]

        var startDateComponents = calendar.dateComponents(units, from: startDate)
        startDateComponents.calendar = calendar

        var endDateComponents = calendar.dateComponents(units, from: endDate)
        endDateComponents.calendar = calendar

        // Create the predicate for the query
        let summariesWithinRange = HKQuery.predicate(forActivitySummariesBetweenStart: startDateComponents,
                                                     end: endDateComponents)
        let query = HKActivitySummaryQuery(predicate: summariesWithinRange) { (_, summariesOrNil, errorOrNil) -> Void in
            guard let summaries = summariesOrNil else {
                completed(.failure(errorOrNil!))
                return
            }
            let activityGoal = Int((summaries.last?.activeEnergyBurnedGoal.doubleValue(for: .kilocalorie())) ?? 0)
            let exerciseGoal = Int((summaries.last?.appleExerciseTimeGoal.doubleValue(for: .minute())) ?? 0)
            completed(.success((activityGoal, exerciseGoal)))
        }
        healthStore.execute(query)
    }

    func getData(type: HKQuantityTypeIdentifier, unit: HKUnit, days: Int, completed: @escaping (Result<[Date: Int],
																								Error>) -> Void) {
        let calendar = NSCalendar.current
        let interval = NSDateComponents()
        interval.day = 1

        let quantityType = HKQuantityType.quantityType(forIdentifier: type)!

        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)

        // Define 1-day intervals starting from 0:00
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate!,
                                                intervalComponents: interval as DateComponents)
        query.initialResultsHandler = {_, results, error in
            if let error = error {
                completed(.failure(error))
                return
            }

            let endDate = NSDate()
            let startDate = calendar.date(byAdding: .day,
										  value: -(days - 1),
										  to: endDate as Date,
										  wrappingComponents: false)
            var completeDataArray: [Date: Int] = [:]
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        let date = statistics.startDate
                        let dayData = quantity.doubleValue(for: unit)
                        completeDataArray[date] = Int(dayData)
                    }
                }
            }
            completed(.success(completeDataArray))
        }
        healthStore.execute(query)
    }
}
