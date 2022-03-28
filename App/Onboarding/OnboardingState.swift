//
//  OnboardingState.swift
//  VFPoC
//
//  Created by Sergey Gorin on 13/03/2019.
//  Copyright © 2019 Sergey Gorin. All rights reserved.
//

import Foundation

class OnboardingState {
    var gender: Gender = UserDefaults.gender {
        didSet {
            UserDefaults.gender = gender
            change?(.changedData)
        }
    }
    
    var birthYear: Int? = UserDefaults.birthYear {
        didSet {
            UserDefaults.birthYear = birthYear
            change?(.changedData)
        }
    }
    
    var selectedInterests: [Int] = [] {
        didSet {
            UserDefaults.userInterests = selectedInterests.compactMap { interests[$0] }
            change?(.changedData)
        }
    }
    
    var interests: [Interest] = []
    
    var isValidGender: Bool {
        return gender != .unknown
    }
    
    var isValidBirthYear: Bool {
        return birthYear > 1899
    }
    
    var isValidToFinish: Bool {
        return isValidGender && isValidBirthYear && selectedInterests.count > 2
    }
    
    private var change: ((Change) -> ())?
    
    func onChange(_ closure: ((Change) -> ())?) {
        change = closure
    }
    
    func fetchInterests() {
        guard interests.isEmpty else { return }
        
        change?(.startedLoading)
        TAPI.Interests.fetchAll { [weak self] result in
            switch result {
            case let .success(response):
                self?.interests = response.interests
                self?.change?(.finishedLoading(.success(())))
            case let .failure(error):
                self?.change?(.finishedLoading(.failure(error)))
            }
        }
    }
}
