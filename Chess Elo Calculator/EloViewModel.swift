//
//  EloViewModel.swift
//  Chess Elo Calculator
//
//  Created by IvanL on 7/15/24.
//

import Foundation
import Combine
import SwiftUI

class EloViewModel: ObservableObject {
    @Published private var user1Elo: Int?
    @Published private var user2Elo: Int?
    
    @Published private(set) var expectedScores: (Double, Double) = (0, 0)
    
    @Published private(set) var user1Color: Color = .black
    @Published private(set) var user2Color: Color = .black
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupPublishers()
    }
    
    private func setupPublishers() {
        Publishers.CombineLatest($user1Elo, $user2Elo)
            .sink { [weak self] elo1, elo2 in
                self?.updateExpectedScores(elo1: elo1, elo2: elo2)
            }
            .store(in: &cancellables)
    }
    
    func expectedScore(playerAElo: Int?, playerBElo: Int?) -> (Double, Double) {
        if playerAElo != nil && playerBElo == nil {
            return (1.0, 0)
        }
        
        if playerAElo == nil && playerBElo != nil {
            return (0, 1.0)
        }
        
        if playerAElo == nil && playerBElo == nil {
            return (0.5, 0.5)
        }
        
        let playerAElo = playerAElo ?? 0
        let playerBElo = playerBElo ?? 0
        
        let expectedA = 1.0 / (1.0 + pow(10, Double(playerBElo - playerAElo) / 400))
        let expectedB = 1.0 / (1.0 + pow(10, Double(playerAElo - playerBElo) / 400))
        
        return (expectedA, expectedB)
    }
    
    func colorForProbability(_ probability: Double) -> Color {
        var color: Color = .black
        
        if probability > 0.5 {
            color = Color(red: 112.0/255.0, green: 199.0/255, blue: 84.0/255)
        } else if probability < 0.5 {
            color = Color(red: 237.0/255.0, green: 62.0/255, blue: 62.0/255)
        }
        
        return color
    }
    
    private func updateExpectedScores(elo1: Int?, elo2: Int?) {
        expectedScores = expectedScore(playerAElo: elo1, playerBElo: elo2)
        user1Color = colorForProbability(expectedScores.0)
        user2Color = colorForProbability(expectedScores.1)
    }
    
    func setUser1Elo(_ elo: Int?) {
        user1Elo = elo
    }
    
    func setUser2Elo(_ elo: Int?) {
        user2Elo = elo
    }
    
    
}
