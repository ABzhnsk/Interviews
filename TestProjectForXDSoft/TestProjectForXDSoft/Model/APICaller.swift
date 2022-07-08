//
//  APICaller.swift
//  TestProjectForXDSoft
//
//  Created by Anna Buzhinskaya on 08.07.2022.
//

import Foundation

class APICaller {
    var isPaginating = false
    func fetchPrimeNumbers(pagination: Bool = false, completion: @escaping (Result<[Int], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 2 : 3), execute: { [weak self] in
            guard let self = self else { return }
            let numbers = self.generateSimpleNumbers(max: 1000)
            let newNumbers = [1, 2, 3]
            completion(.success(pagination ? newNumbers : numbers))
            if pagination {
                self.isPaginating = false
            }
        })
    }
    
    func fetchFibonacciNumbers(pagination: Bool = false, completion: @escaping (Result<[Int], Error>) -> Void) {
        if pagination {
            isPaginating = true
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 2 : 3), execute: { [weak self] in
            guard let self = self else { return }
            let numbers = self.generateFibonacciNumbers(step: 20)
            let newNumbers = [1, 2, 3]
            completion(.success(pagination ? newNumbers : numbers))
            if pagination {
                self.isPaginating = false
            }
        })
    }
    
    private func generateSimpleNumbers(max: Int) -> [Int] {
            guard max > 1 else { return [] }
            
            var sieve = [Bool](repeating: true, count: max + 1)
            
            sieve[0] = false
            sieve[1] = false
            
            for i in 2...max where sieve[i] == true {
                for j in stride(from: i*i, through: max, by: i) {
                    sieve[j] = false
                }
            }
        
            return sieve.enumerated().compactMap { $1 == true ? $0 : nil }
    }
    
    func generateFibonacciNumbers(step: Int) -> [Int] {
            var fibonacciNumbers = [0, 1]
        
            if step <= 1 {
               return fibonacciNumbers
            }
            
            for _ in 0...step - 2 {
                let first = fibonacciNumbers[fibonacciNumbers.count - 2]
                let second = fibonacciNumbers.last!
                fibonacciNumbers.append(first + second)
            }
        
        return fibonacciNumbers
    }
}
