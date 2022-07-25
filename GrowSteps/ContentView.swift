//
//  ContentView.swift
//  GrowSteps
//
//  Created by Sydney Achinger on 1/26/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    @State private var progress = 10.0
    
    @State private var stepCount: Double?
    
    @State private var healthStatus: Color?
    
    private var stepGoal = 5000.00
    
    
    private var healthStore: HealthStore?
    
    init() {
        healthStore = HealthStore()
    }
    
    private func getHealthStatus(steps: Double){
        let ratio = steps/stepGoal
        if(ratio < 0.5){
            healthStatus = Color.red
        }
        if(ratio >= 0.5){
            healthStatus = Color.gray
        }
        if(ratio >= 1.0){
            healthStatus = Color.green
        }
    }
    
    private func updateUIFromStatistics( _ statisticsCollection: HKStatisticsCollection){

        statisticsCollection.enumerateStatistics(from: Date(), to: Date()) { statistics, stop in
            stepCount = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
            getHealthStatus(steps: stepCount ?? 0.0)

        }

    }
    
    var body: some View {
        VStack{
            HStack{
                ProgressView(value: stepCount ?? 0.0, total: stepGoal)
                    .padding(.top, 50)
                    //.rotationEffect(Angle(degrees: -90.0))
            
            }
            Spacer()
            HealthAvatar(healthStatus: healthStatus ?? Color.clear)
            Text(String(stepCount ?? 0.0)+" steps")
                .font(.body)
                .padding()
        }
        .onAppear(perform: {
            if let healthStore = healthStore {
                healthStore.requestAuthorization { (success) in
                    if success {
                        healthStore.calculateSteps { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                updateUIFromStatistics(statisticsCollection)
                            }
                            
                        }
                    }
                }
            }
        })
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
