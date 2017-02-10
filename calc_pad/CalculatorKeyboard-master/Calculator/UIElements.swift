import Foundation
import UIKit

class RoundButton: UIButton {
    @IBInspectable var _cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = _cornerRadius
        }
    }
    
    @IBInspectable var _borderColor: UIColor = UIColor.darkGray {
        didSet {
            layer.borderWidth = 1.0
            layer.masksToBounds = true
            layer.borderColor = _borderColor.cgColor
        }
    }
    var mode:String = "alphabets"
    func switchMode() {
        switch mode {
        case "alphabets":
            if tag == 10 {
                setTitle("0", for: .normal)
            }else{
                setTitle(String(tag), for: .normal)
            }
            mode = "numbers"
        case "numbers":
            switch tag {
            case 1:
                setTitle("@/.", for: .normal)
            case 2:
                setTitle("ABC", for: .normal)
            case 3:
                setTitle("DEF", for: .normal)
            case 4:
                setTitle("GHI", for: .normal)
            case 5:
                setTitle("JKL", for: .normal)
            case 6:
                setTitle("MNO", for: .normal)
            case 7:
                setTitle("PQRS", for: .normal)
            case 8:
                setTitle("TUV", for: .normal)
            case 9:
                setTitle("WXYZ", for: .normal)
            case 10:
                setTitle("", for: .normal)
            default:
                break
            }
            mode = "alphabets"
        default:
            break
        }
    }
}

class RoundLabel: UILabel {
    @IBInspectable var _cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = _cornerRadius
        }
    }
}
