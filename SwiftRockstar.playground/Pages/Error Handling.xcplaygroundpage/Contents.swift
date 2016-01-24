//: # Error handling
import Foundation

let numbersArray = [1, 3, 2, 5, 4]

/*:
Implement a simple find element method
*/
func find(array: [Int], key: Int) -> Int{
    return 0
}
/*:
Swift does not allow a nil return result without marking the return result as optional.
This means that it is impossible to miss a nil return result without activly escaping it.
*/
func find2(array: [Int], key: Int) -> Int?{
    var counter = 0
    for element in array {
        if element == key {
            return counter
        }
        counter++
    }
    return nil
}

/*:
Calling find with non-optional return works as normal
*/
let index = find(numbersArray, key: 3)
numbersArray[index]

/*:
Calling with optional requires a force unwrap. Seeing this used in code should be considered
an indication that something is not right! There are however cases when this could be used.
*/
let index2 = find2(numbersArray, key: 3)
numbersArray[index2!]

/*:
The correct way of handling the unwrapping is doing it with a nil check. This way is still
too ugly since it requires a force unwrap so Swift provides a special if for unwrapping.
*/
if index2 != nil {
    numbersArray[index2!]
}

if let i = index2 {
    numbersArray[i]
}

/*:
The first option for try/catch is to handle the exception exactly where it occurs. This is done using catch.
*/
func readDataFromFile() -> [Int]{
    if let filePath = NSBundle.mainBundle().URLForResource("test", withExtension: "json"){
        if let data = NSData(contentsOfURL: filePath){
            do{
                let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                if let intArray = jsonObj as? [Int]{
                    return intArray
                }
            }catch{
                print(error)
            }
        }
    }
    return [Int]()
}

let intArray = readDataFromFile()

/*:
The second option is to propagate the exception upwards. This is done using the throws keyword.
*/
func readDataFromFile2() throws -> [Int]{
    if let filePath = NSBundle.mainBundle().URLForResource("test", withExtension: "json"){
        if let data = NSData(contentsOfURL: filePath){
            let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            if let intArray = jsonObj as? [Int]{
                return intArray
            }
        }
    }
    return [Int]()
}

do{
    try readDataFromFile2()
}catch{
    print(error)
}

/*:
In the previous case we return an empty array when we are unable to find the file we want to read from. We would also do so in the case when we cannot create an NSData object from the contents of the file. It would probabaly be a good idea if we can distinguish between these two errors in order to act upon them. Fortunately we can define our own ErrorTypes to be thrown up to the call site.
*/

enum FileReadCode : ErrorType{
    case NotAnIntArray
    case InvalidFilePath
    case UnableToReadFile
}

/*:
We can use our own error types in combination with the guard statement in order to throw our errors and increase the readability of the code. if statements could be used instead but guard gives more readable code.
*/

func readDataFromFile3() throws -> [Int]{
    guard let filePath = NSBundle.mainBundle().URLForResource("test", withExtension: "json") else {
        throw FileReadCode.InvalidFilePath
    }
    
    guard let data = NSData(contentsOfURL: filePath) else {
        throw FileReadCode.UnableToReadFile
    }
    
    let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
    
    guard let integerArray = jsonObj as? [Int] else {
        throw FileReadCode.NotAnIntArray
    }
    
    return integerArray
}

do{
    try readDataFromFile3()
}catch{
    print(error)
}
//: [Next](@next)
