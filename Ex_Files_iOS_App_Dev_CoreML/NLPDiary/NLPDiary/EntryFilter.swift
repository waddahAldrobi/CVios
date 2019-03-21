//
//  EntryFilter.swift
//  NLPDiary
//
//  Created by Brian Advent on 29.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import Foundation


class EntryFilter {
   
    
    let entryCollection: EntryCollection?
    
    var filteredEntries = [String]()

    var wordSets = [String: Set<String>]()
    var languages = [String: String]()
    
    var searchString = "" {
        didSet {
            
            if searchString == "" {
                filteredEntries = self.entryCollection!.entries!
            }else{
                extractWordSetsAndLanguages()
                filterEntries()
            }
            
        }
    }

    
    init(entryCollection: EntryCollection?) {
        self.entryCollection = entryCollection
        
    }
    

    fileprivate func setOfWords(string: String, language: inout String?) -> Set<String> {
        var wordSet = Set<String>()
        
        let tagger = NSLinguisticTagger(tagSchemes: [.lemma, .language], options: 0)
        let range = NSRange(location: 0, length: string.utf16.count)
        
        tagger.string  = string
        
        if let language = language {
            let orthography = NSOrthography.defaultOrthography(forLanguage: language)
            tagger.setOrthography(orthography, range: range)
        }else{
            language = tagger.dominantLanguage
        }
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitPunctuation]){
            tag, tokenRange, _ in
            
            let token = (string as NSString).substring(with: tokenRange)
            wordSet.insert(token.lowercased())
            
            if let lemma = tag?.rawValue {
                wordSet.insert(lemma.lowercased())
            }
            
        }
        
        
        return wordSet
    }
    
    fileprivate func extractWordSetsAndLanguages() {
        var newWordSets = [String: Set<String>]()
        var newLanguages = [String: String]()
        
       
        if let entries = entryCollection?.entries {
            for entry in entries {
                if let wordSet = wordSets[entry] {
       
                    newWordSets[entry] = wordSet
                    newLanguages[entry] = languages[entry]
                } else {
       
                    var language: String?
                    let wordSet = setOfWords(string: entry, language: &language)
                    newWordSets[entry] = wordSet
                    newLanguages[entry] = language
                }
            }
        }
        
        wordSets = newWordSets
        languages = newLanguages
    }
    
    fileprivate func filterEntries() {
        var language: String?
        var filterSet = setOfWords(string: searchString, language: &language)
        
        for existingLanguage in Set<String>(languages.values) {
            
            language = existingLanguage
            filterSet = filterSet.union(setOfWords(string: searchString, language: &language))
        }
        
        filteredEntries.removeAll()
        
        if let entries = entryCollection?.entries {
            if filterSet.isEmpty {
                filteredEntries.append(contentsOf: entries)
            } else {
                for entry in entries {
                    
                    guard let wordSet = wordSets[entry], !wordSet.intersection(filterSet).isEmpty else { continue }
                    filteredEntries.append(entry)
                }
            }
        }
        

    }
    
}

