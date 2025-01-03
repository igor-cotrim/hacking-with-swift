//
//  SevenSwifyWordsModel.swift
//  06-7SwiftyWords
//
//  Created by Igor Cotrim on 03/01/25.
//

struct Word {       
    let answer: String
    let clue: String
}

struct Level {
    let number: Int
    let words: [Word]
}
