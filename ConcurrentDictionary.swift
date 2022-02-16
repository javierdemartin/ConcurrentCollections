//
//  ConcurrentDictionary.swift
//
//
//  Created by Javier de Martín Gil on 16/2/22.
//

final class ConcurrentDictionary<K: Hashable,T>: Collection {
    
    typealias Index = Dictionary<K, T>.Index
    
    typealias Element = Dictionary<K, T>.Element
    
    private var dictionary: [K: T]

    private let concurrentQueue = DispatchQueue(label: "com.example.thread_safe_dictionary", attributes: .concurrent)
    
    var startIndex: Index {
        concurrentQueue.sync {
            return self.dictionary.startIndex
        }
    }
    
    var endIndex: Index {
        concurrentQueue.sync {
            return self.dictionary.startIndex
        }
    }
    
    init(dictionary: Dictionary<K,T> = .init()) {
        self.dictionary = dictionary
    }
    
    subscript(key: K) -> T? {
        set {
            self.concurrentQueue.async(flags: .barrier) {
                self.dictionary[key] = newValue
            }
        }
        
        get {
            self.concurrentQueue.sync {
                return self.dictionary[key]
            }
        }
    }
    
    subscript(index: Index) -> Element {
        self.concurrentQueue.sync {
            return self.dictionary[index]
        }
    }
    
    func index(after i: Index) -> Index {
        self.concurrentQueue.sync {
            self.dictionary.index(after: i)
        }
    }
    
    func removeValue(forKey key: K) {
        self.concurrentQueue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
    
    func removeAll() {
        self.concurrentQueue.async(flags: .barrier) {
            self.dictionary.removeAll()
        }
    }
}
