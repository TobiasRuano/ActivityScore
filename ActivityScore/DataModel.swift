//
//  DataModel.swift
//  ActivityScore
//
//  Created by Tobias Ruano on 15/07/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation

struct Objectives: Codable {
    var calories = Int()
    let minutesEx = 30
}

class HealthDataModel {
    private var cardSteps: Int
    private var cardCal: Int
    private var cardExe: Int
    private var cardKm: Double
    private var score: Int
    private var motivationText: String
    private var objective: Objectives
    
    let hour = Calendar.current.component(.hour, from: Date())
    
    init(cardSteps: Int, cardCal: Int, cardExe: Int, cardKm: Double, points: Int, motivationText: String, objective: Objectives) {
        self.cardSteps = cardSteps
        self.cardCal = cardCal
        self.cardExe = cardExe
        self.cardKm = cardKm
        self.score = points
        self.motivationText = ""
        self.objective = objective
    }
    
    // MARK: - Getters
    func getSteps() -> Int{
        return cardSteps
    }
    
    func getCalories() -> Int {
        return cardCal
    }
    
    func getExercise() -> Int {
        return cardExe
    }
    
    func getKm() -> Double {
        return cardKm
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getMotivationText() -> String {
        return motivationText
    }
    
    func getObjective() -> Objectives {
        return self.objective
    }
    
    // MARK: - Setters
    func setSteps(steps: Int) {
        self.cardSteps = steps
    }
    
    func setCalories(calories: Int) {
        self.cardCal = calories
    }
    
    func setExercise(exercise: Int) {
        self.cardExe = exercise
    }
    
    func setKm(km: Double) {
        self.cardKm = km
    }
    
    func setScore(points: Int) {
        self.score = points
        updateMotivationText()
    }
    
    private func setMotivationText(motivation: String) {
        self.motivationText = motivation
    }
    
    func setObjective(objective: Objectives) {
        self.objective = objective
    }
    
    private func updateMotivationText() {
        if self.score < 20 {
            if self.hour < 10 {
                self.motivationText = "Let's own the day! 💪"
            } else if self.hour < 17 {
                self.motivationText = "Let's go for a walk! 🚶‍♂️"
            } else {
                self.motivationText = "SO LAZY! 😡"
            }
        } else if self.score > 19 && self.score < 40 {
            if self.hour < 10 {
                self.motivationText = "Let's own the day! 💪"
            } else if self.hour < 17 {
                self.motivationText = "Not bad, but you could do better. 🤷‍♂️"
            } else if self.hour < 19 {
                self.motivationText = "Let's get out there and work out! 😃"
            } else {
                self.motivationText = "You'll do better tomorrow! 😔"
            }
        } else if self.score > 39 && self.score < 70 {
            if self.hour < 10 {
                self.motivationText = "What a way to start the day. 👏"
            } else if self.hour < 17 {
                self.motivationText = "Great Job! 💪"
            } else {
                self.motivationText = "Great Job! 💪"
            }
        } else if self.score > 69 {
            if self.hour < 10 {
                self.motivationText = "Excelent way to start the Day! 👍"
            } else if self.hour < 17 {
                self.motivationText = "KEEP IT UP! 🏆"
            } else {
                self.motivationText = "WOW, WHAT A DAY!! 👏"
            }
        }
    }
}
