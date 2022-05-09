//
//  HighScore.swift
//  Kids Joy Center
//
//  Created by Spencer Kinsey-Korzym on 3/29/22.
//

import Foundation

class Score: Codable{
    var gameName: String
    var score: Int
    var difficulty: String
    
    init(name: String, score: Int, difficulty: Int){
        self.gameName = name
        self.score = score
        switch(difficulty){
        case 0:
            self.difficulty = "Easy"
        case 1:
            self.difficulty = "Medium"
        case 2:
            self.difficulty = "Hard"
        default:
            self.difficulty = "Easy"
        }
    }
    static func saveData(data: [Score]){
        let encodedData = try! JSONEncoder().encode(data)
        UserDefaults.standard.set(encodedData, forKey: "high-score")
    }
    static func getData()->[Score]{
        if(UserDefaults.standard.data(forKey: "high-score") != nil){
            let data = UserDefaults.standard.data(forKey: "high-score")
            let decodedData = try? JSONDecoder().decode([Score].self, from: data!)
            return decodedData!
        }else{
            return []
        }
        
    }
}
