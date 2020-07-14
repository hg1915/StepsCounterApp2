
import HealthKit


final class HealthKitManager {
    static let `default` = HealthKitManager()
    
    private init() { }
        
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    func getStepsLast(days: TimeInterval, completion: @escaping (_ steps: [Step]) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let startDate = Date().addingTimeInterval(-3600 * 24 * days)
        let endDate = Date()
        
        let predicate =  HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate])
        
        var interval = DateComponents()
        interval.day = 1
        
        let calendar = Calendar.current
        let anchorDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        
        let stepQuery = HKStatisticsCollectionQuery(quantityType: type , quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval)
        
        stepQuery.initialResultsHandler = { query, results, error in
            guard error == nil, let results = results else {
                return
            }
            var steps: [Step] = []
            
            results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    steps.append(Step(count: Int(quantity.doubleValue(for: HKUnit.count())), date: statistics.startDate.string))
                }
            }
            completion(steps.reversed())
        }
        HKHealthStore().execute(stepQuery)
    }
    
    func getHealthKitPermission(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        healthStore?.requestAuthorization(toShare: [stepsCount], read: [stepsCount], completion: { (success, error) in
            guard success, error == nil else {
                print(error as Any)
                completion(false)
                return
            }
            completion(true)
        })
    }
    
}

extension Date {
    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
