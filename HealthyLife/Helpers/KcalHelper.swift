//
//  KcalHelper.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 27/6/22.
//

import Foundation

class KcalHelper {
    
    let STANDARDMET: Int = 10
    let STANDARDWEIGHT: Int = 10
    
    // Calculate kcal burnt for cardio fitness
    func calculateCalorieBurn(weight: Int, time: Int) -> Int {
        let kcalM = Double(STANDARDMET) * 0.0175 * Double(weight)
        return Int(kcalM * Double(time))
    }
    
    // Calculate kcal burnt for weight fitness
    func calculateWeightBurn(weight: Int, repts: Int) -> Int {
        let time = Double(repts) / 20;
        let kcamM = (Double(weight) * Double(time)) / Double(STANDARDWEIGHT);
        return Int(kcamM);
    }
}
