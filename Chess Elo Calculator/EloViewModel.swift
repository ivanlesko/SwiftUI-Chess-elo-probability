//
//  EloViewModel.swift
//  Chess Elo Calculator
//
//  Created by IvanL on 7/15/24.
//

import Foundation
import Combine

class EloViewModel: ObservableObject {
    @Published private var user1Elo: Int?
    @Published private var user2Elo: Int?
    
    @Published private(set) var expectedScores: (Double, Double) = (0, 0)
    
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
    
    private func updateExpectedScores(elo1: Int?, elo2: Int?) {
        expectedScores = expectedScore(playerAElo: elo1, playerBElo: elo2)
    }
    
    func setUser1Elo(_ elo: Int?) {
        user1Elo = elo
    }
    
    func setUser2Elo(_ elo: Int?) {
        user2Elo = elo
    }
    
    
}
