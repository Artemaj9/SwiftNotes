import UIKit

var array = [[[1,2],[3,4]],[[8,9],[1,0]],[[1,2],[30,23]]]

//print(Array(array.joined()))
//print(Array(array.flatMap(print("Hi"))))

let stringNumber: String? = "5"
let intNumber = stringNumber.map { Int($0) }
let flatMapNumber = stringNumber.flatMap { Int($0) }
//прикол функции map в себе исходный опционал и из функции
//As with map(), the order items are filtered is out of our control – Swift is free to apply any optimizations it wants to make filtering go faster.
let names = ["Taylor", "Paul", "Adele"]
var count = names.reduce(0) { $0 + $1.count }
print(count)

//Reducing to a boolean
let names2 = ["Taylor", "Paul", "Adele"]
let longEnough = names2.reduce(true) { $0 && $1.count > 4 }
print(longEnough)

//Better solution
let longEnough2 = names2.allSatisfy { $0.count > 3 }

let longest2 = names.max { $1.count > $0.count }



let longest = names.reduce("") { $1.count > $0.count ? $1 : $0 }

let numbers = [[
   [1, 1, 2],
   [3, 5, 8],
[13, 21, 34] ], [   [1, 1, 2],
                    [3, 5, 8],
                 [13, 21, 34] ]]
//let flattened: [Int] = numbers.reduce([]) { $0 + $1 }
//print(flattened)
let flattened2 = numbers.flatMap { $0 }
print(flattened2)

let london = (name: "London", continent: "Europe", population:
8_539_000)
let paris = (name: "Paris", continent: "Europe", population:
2_244_000)
let lisbon = (name: "Lisbon", continent: "Europe", population:
530_000)
let rome = (name: "Rome", continent: "Europe", population:
2_627_000)
let tokyo = (name: "Tokyo", continent: "Asia", population:
13_350_000)
let cities = [london, paris, lisbon, rome, tokyo]

let totalPopulation = cities.reduce(0) { $0 + $1.population }
let europePopulation = cities.filter { $0.continent ==
"Europe" }.reduce(0) { $0 + $1.population }

let biggestCities = cities.filter { $0.population >
2_000_000 }.sorted { $0.population >
$1.population }.prefix(upTo: 3).map { "\($0.name) is a big city, with a population of \($0.population)" }.joined(separator: "\n")
print(biggestCities)

extension Int {
    // iterates the closure body a specified number of times
    func times(closure: (Int) -> Void) {
        for i in 0 ..< self {
            closure(i)
        }
    }
}

5.times { item in
    print(item + 3)
}

extension BinaryInteger {
    func myDef() -> Self {
        return (1...10).contains(self) ? self :
        self > 10 ? 10 : 1
    }
}

(-9).myDef()


extension BinaryInteger {
   func clamp(low: Self, high: Self) -> Self {
      return min(max(self, low), high)
   }
}
-9.clamp(low: 0, high: 10)

//extension Equatable {
//    func matches(array items: [Self]) -> Bool {
//        for item in items {
//            if item != self {
//                return false
//            }
//        }
//    }
//}
        
extension Comparable {
    func lessThan(array items: [Self]) -> Bool {
        for item in items {
            if item <= self {
                return false
            }
        }
        return true
    }
}

5.lessThan(array: [6, 7, 8])
5.lessThan(array: [5, 6, 7])
"cat".lessThan(array: ["dog", "fish", "gorilla"])


extension Collection where Iterator.Element: Equatable {
   func myContains(element: Iterator.Element) -> Bool {
       for item in self {
           if item == element {
               return true }
       }
             return false
          }
       }

extension Collection where Iterator.Element: Comparable {
   func fuzzyMatches(_ other: Self) -> Bool {
      let usSorted = self.sorted()
      let otherSorted = other.sorted()
      return usSorted == otherSorted
   }
}


extension Collection where Iterator.Element == String {
   func averageLength() -> Double {
      var sum = 0
      var count = 0
      self.forEach {
         sum += $0.count
         count += 1
}
      return Double(sum) / Double(count)
   }
}

extension Array where Element: Comparable {
    func isSorted() -> Bool {
        return self == self.sorted()
    }
}

[1, 4, 16, 90].isSorted()
    
var a = 3
var b = 5
var c = 8
var d = 19
var e = 34
var f = 90
var l = 87
var m = 80
var q = 55
var w = 24
(a,b,c,d,e,f,l,m,q,w) = (d,c,a,b,f,e,m,l,w,q)
print("a:\(a)")
print("b:\(b)")
print("c:\(c)")
print("d:\(d)")
print("f:\(f)")
print("e:\(e)")
print("l:\(l)")
print("m:\(m)")
print("q:\(q)")
print("w:\(w)")

let set1: Set = [1, 2, 3, 2]
set1.
