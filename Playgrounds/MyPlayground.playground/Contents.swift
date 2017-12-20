



(0...9)
Array(0...9)
(0...9).map { String(describing: $0) }
Array(0...9).map { String(describing: $0) }

let arrayOfString:  [String] = (0...9).map { String(describing: $0) }


public enum JSONPathKey {
    case String (String)
    case Number (Int)
    case Range(from: Int, to: Int)
}


struct JSONPathKeyIterator: IteratorProtocol {
    
    var currentSlice: ArraySlice<JSONPathKey>
    var index = 0
    var iterator: ClosedRangeIterator<Int>?
    
    mutating func next() -> String? {
        guard index < currentSlice.count else { return nil }
        let resultString: String?
        
        if iterator != nil {
            if let number = iterator?.next() {
                resultString = String(describing:  number )
            } else {
                iterator = nil
                resultString = nil
                index += 1
            }
        } else {
            let current = currentSlice[index]
            
            switch current {
            case .Number(let number):
                resultString = String(describing: number)
                index += 1
                
            case .String(let string):
                resultString = string
                index += 1
                
            case let .Range(from: from, to: to):
                iterator = (from...to).makeIterator()
                if let number = iterator?.next() {
                    resultString = String(describing:  number )
                } else {
                    iterator = nil
                    resultString = nil
                    index += 1
                }
            }
        }
        
//        print ("output: \(String(describing: resultString))")
        return resultString
    }
}

let pathKeySet = [
    JSONPathKey.Range(from: 0, to: 2)
]

let sequence = AnySequence {  JSONPathKeyIterator(currentSlice: ArraySlice(pathKeySet), index: 0, iterator: nil) }

print (sequence.map {$0+" hello" } )
for key in sequence {
    print (key)
}
print (Array(sequence))
