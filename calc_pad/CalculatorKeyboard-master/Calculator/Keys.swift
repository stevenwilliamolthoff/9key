import Foundation

//Information stored for each key
struct Keys {
    struct NineKeys {
        static let mapping = [
            "alphabets": [
                "1":["@","/","."],
                "2":["a","b","c"],
                "3":["d","e","f"],
                "4":["g","h","i"],
                "5":["j","k","l"],
                "6":["m","n","o"],
                "7":["p","q","r","s"],
                "8":["t","u","v"],
                "9":["w","x","y","z"],
                "10":[" "]
            ],
            "numbers": [
                "1":["1"],
                "2":["2"],
                "3":["3"],
                "4":["4"],
                "5":["5"],
                "6":["6"],
                "7":["7"],
                "8":["8"],
                "9":["9"],
                "10":["0"]
            ]
        ]
    }
}

//Control how 9 keys will input, {CONTROL DATA}
class KeysControl: NSObject {
    var pointerAddress = 0
    var previousTag = -1
    var currentInput = ""
    var storedInputs: String
    var lastKeyControlTime: Date
    var inputsDelay: TimeInterval {
        get{
            return Date().timeIntervalSince(lastKeyControlTime)
        }
    }
    override init() {
        lastKeyControlTime = Date()
        storedInputs = "Input will appear here..."
        super.init()
    }
    // Display proper text in display
    func toggle(mode: String, tag: Int) -> String {
        if tag == previousTag {
            if inputsDelay >= 0.8 {
                pointerAddress = 0
                previousTag = tag
                storedInputs = storedInputs + currentInput
                currentInput = Keys.NineKeys.mapping[mode]![String(tag)]![pointerAddress]
                lastKeyControlTime = Date()
                return storedInputs + Keys.NineKeys.mapping[mode]![String(tag)]![0]
            }else{
                pointerAddress += 1
                if !(Keys.NineKeys.mapping[mode]?[String(tag)]?.indices.contains(pointerAddress))! {
                    pointerAddress = 0
                }
                currentInput = Keys.NineKeys.mapping[mode]![String(tag)]![pointerAddress]
                lastKeyControlTime = Date()
                return storedInputs + currentInput
            }
        }else{
            pointerAddress = 0
            previousTag = tag
            storedInputs = storedInputs + currentInput
            currentInput = Keys.NineKeys.mapping[mode]![String(tag)]![pointerAddress]
            lastKeyControlTime = Date()
            return storedInputs + Keys.NineKeys.mapping[mode]![String(tag)]![0]
        }
    }

    func backspace() -> String {
        if storedInputs.characters.count > 0 {
            storedInputs.characters.removeLast()
            currentInput = ""
            pointerAddress = 0
            previousTag = -1
            lastKeyControlTime = Date()
            return storedInputs
        }
        return ""
    }
    func removeLastWord() {
        if let lastWordRange = storedInputs.range(of: " ") {
            currentInput = ""
            storedInputs.removeSubrange(lastWordRange.lowerBound..<storedInputs.endIndex)
            pointerAddress = 0
            previousTag = -1
            lastKeyControlTime = Date()
        }else{
            clear()
        }
    }
    func clear() {
        currentInput = ""
        storedInputs = ""
        pointerAddress = 0
        previousTag = -1
        lastKeyControlTime = Date()
    }
}
