//
//  HealthKitManager.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/29/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import HealthKit

class HealthKitManager {
    
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success:Bool, error: NSError!) -> Void)!) {
        let readTypes: Set<HKObjectType> =
            [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!]
        
        
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "care.dovetail.pregnansi", code: 2,
                userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this Device"])
            if (completion != nil) {
                completion(success: false, error: error)
            }
            return;
        }
        
        healthKitStore.requestAuthorizationToShareTypes([], readTypes: readTypes) {
            (success, error) -> Void in
            
            if (completion != nil) {
                completion(success: success, error: error)
            }
        }
    }

    func query(sampleType: HKSampleType, from: NSDate, to: NSDate, completion: (([AnyObject]!, NSError!)-> Void)!) {
        let allPredicate = HKQuery.predicateForSamplesWithStartDate(from, endDate:to, options: .None)
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: allPredicate, limit: 5000, sortDescriptors: [sortDescriptor]) {
            (sampleQuery, results, error ) -> Void in

                if completion != nil {
                    completion(results, error)
                }
        }
        self.healthKitStore.executeQuery(sampleQuery)
    }
}