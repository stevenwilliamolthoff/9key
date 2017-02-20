//
//  KeyboardViewController.swift
//  Calculator
//
//  Created by Shaun O'Reilly on 11/11/2015.
//  Copyright © 2015 Visual Recruit Pty Ltd. All rights reserved.
//

import UIKit
import Material //Find other 3rd-party dependencies here -> cocoapods.org

//{CONTROL UI}
class KeyboardViewController: UIInputViewController {
    //MARK: Outlets
    @IBOutlet var topRegion: UIView!
    @IBOutlet var leftRegion: UIView!
    @IBOutlet var rightRegion: UIView!
    @IBOutlet var nextKeyboardButton: IconButton!
    @IBOutlet var numberPadSwitcher: UIButton!
    @IBOutlet var dismissButton: IconButton!
    @IBOutlet var displayBackspace: IconButton!{
        didSet{
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.shouldClearPreviousWordInDisplay))
            displayBackspace.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet var mainBackspace: RaisedButton!
    @IBOutlet var newlineButton: RaisedButton!
    @IBOutlet var sendButton: RaisedButton!
    @IBOutlet var spaceButton: RoundButton!{
        didSet{
            spaceButton.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)

        }
    }

    @IBOutlet var display: UILabel! {
        didSet{
            display.isUserInteractionEnabled = true
            display.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shouldInsertText)))
        }
    }
    @IBOutlet var syms_1: RaisedButton!
    @IBOutlet var syms_2: RaisedButton!
    @IBOutlet var syms_3: RaisedButton!
    @IBOutlet var syms_4: RaisedButton!
    
    @IBOutlet var predict1: RoundButton!
    @IBOutlet var predict2: RoundButton!
    @IBOutlet var predict3: RoundButton!
    @IBOutlet var predict4: RoundButton!
    
    @IBOutlet var one: RoundButton!{
        didSet{
            one.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            one.titleLabel!.font =  UIFont(name: "one", size: 18)
        }
    }
    @IBOutlet var two: RoundButton!{
        didSet{
            two.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            two.titleLabel!.font =  UIFont(name: "two", size: 18)

        }
    }
    @IBOutlet var three: RoundButton!{
        didSet{
            three.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            three.titleLabel!.font =  UIFont(name: "three", size: 18)
        }
    }
    @IBOutlet var four: RoundButton!{
        didSet{
            four.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            four.titleLabel!.font =  UIFont(name: "four", size: 18)
        }
    }
    @IBOutlet var five: RoundButton!{
        didSet{
            five.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            five.titleLabel!.font =  UIFont(name: "five", size: 18)
        }
    }
    @IBOutlet var six: RoundButton!{
        didSet{
            six.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            six.titleLabel!.font =  UIFont(name: "six", size: 18)

        }
    }
    @IBOutlet var seven: RoundButton!{
        didSet{
            seven.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            seven.titleLabel!.font =  UIFont(name: "seven", size: 18)

        }
    }
    @IBOutlet var eight: RoundButton!{
        didSet{
            eight.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            eight.titleLabel!.font =  UIFont(name: "eight", size: 18)

        }
    }
    @IBOutlet var nine: RoundButton!{
        didSet{
            nine.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
            nine.titleLabel!.font =  UIFont(name: "nine", size: 18)

        }
    }

    //MARK: Variables
    var keyboardView: UIView!
    var shouldClearDisplayBeforeInserting: Bool = true
    var keyscontrol = KeysControl()
    var motherViewsHaveConstrainted: Bool = false
//    var predictionButtons: [RoundButton] = [RoundButton(predictionIndex: 0)]
    
    //MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
        updateViewConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let expandedHeight:CGFloat = 270
        let heightConstraint = NSLayoutConstraint(item:self.view,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 0.0,
                                                  constant: expandedHeight)
        self.view.addConstraint(heightConstraint)
    }
    
    override func updateViewConstraints() {
        if motherViewsHaveConstrainted {
            leftRegion.layout(syms_1)
                .left(Padding().sidePanels.leftRegion.forButton(withIndex: 1).left)
                .top(Padding().sidePanels.leftRegion.forButton(withIndex: 1).top)
                .height(Padding.SidePanels.LeftRegion.buttonDimensions.height)
                .width(Padding.SidePanels.LeftRegion.buttonDimensions.width)
            leftRegion.layout(syms_2)
                .left(Padding().sidePanels.leftRegion.forButton(withIndex: 2).left)
                .top(Padding().sidePanels.leftRegion.forButton(withIndex: 2).top)
                .height(Padding.SidePanels.LeftRegion.buttonDimensions.height)
                .width(Padding.SidePanels.LeftRegion.buttonDimensions.width)
            leftRegion.layout(syms_3)
                .left(Padding().sidePanels.leftRegion.forButton(withIndex: 3).left)
                .top(Padding().sidePanels.leftRegion.forButton(withIndex: 3).top)
                .height(Padding.SidePanels.LeftRegion.buttonDimensions.height)
                .width(Padding.SidePanels.LeftRegion.buttonDimensions.width)
            leftRegion.layout(syms_4)
                .left(Padding().sidePanels.leftRegion.forButton(withIndex: 4).left)
                .top(Padding().sidePanels.leftRegion.forButton(withIndex: 4).top)
                .height(Padding.SidePanels.LeftRegion.buttonDimensions.height)
                .width(Padding.SidePanels.LeftRegion.buttonDimensions.width)
            rightRegion.layout(mainBackspace)
                .left(Padding().sidePanels.rightRegion.forButton(withIndex: 1).left)
                .top(Padding().sidePanels.rightRegion.forButton(withIndex: 1).top)
                .height(Padding.SidePanels.RightRegion.buttonDimensions.height)
                .width(Padding.SidePanels.RightRegion.buttonDimensions.width)
            rightRegion.layout(newlineButton)
                .left(Padding().sidePanels.rightRegion.forButton(withIndex: 2).left)
                .top(Padding().sidePanels.rightRegion.forButton(withIndex: 2).top)
                .height(Padding.SidePanels.RightRegion.buttonDimensions.height)
                .width(Padding.SidePanels.RightRegion.buttonDimensions.width)
            rightRegion.layout(sendButton)
                .left(Padding().sidePanels.rightRegion.forButton(withIndex: 3).left)
                .top(Padding().sidePanels.rightRegion.forButton(withIndex: 3).top)
                .height(Padding.SidePanels.RightRegion.returnButtonDimensions.height)
                .width(Padding.SidePanels.RightRegion.returnButtonDimensions.width)
            topRegion.layout(display)
                .left()
                .top()
                .bottom()
                .width(Padding().sidePanels.topRegion.displayWidth)
                .height(Padding.SidePanels.TopRegion.buttonsDimensions.height)
            topRegion.layout(dismissButton)
                .left(Padding().sidePanels.topRegion.buttonsLayouts(index: 2).left)
                .top(Padding().sidePanels.topRegion.buttonsLayouts(index: 2).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.buttonsDimensions.width)
                .height(Padding.SidePanels.TopRegion.buttonsDimensions.height)           
            topRegion.layout(displayBackspace)
                .left(Padding().sidePanels.topRegion.buttonsLayouts(index: 3).left)
                .top(Padding().sidePanels.topRegion.buttonsLayouts(index: 3).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.buttonsDimensions.width)
                .height(Padding.SidePanels.TopRegion.buttonsDimensions.height) 
            topRegion.layout(predict1)
                .left()
                .top(Padding().sidePanels.topRegion.predictLayouts(index: 4).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.predictDimensions.width)
                .height(Padding.SidePanels.TopRegion.predictDimensions.height)
            topRegion.layout(predict2)
                .left(Padding().sidePanels.topRegion.predictLayouts(index: 5).left)
                .top(Padding().sidePanels.topRegion.predictLayouts(index: 5).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.predictDimensions.width)
                .height(Padding.SidePanels.TopRegion.predictDimensions.height)
            topRegion.layout(predict3)
                .left(Padding().sidePanels.topRegion.predictLayouts(index: 6).left)
                .top(Padding().sidePanels.topRegion.predictLayouts(index: 6).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.predictDimensions.width)
                .height(Padding.SidePanels.TopRegion.predictDimensions.height)
            topRegion.layout(predict4)
                .left(Padding().sidePanels.topRegion.predictLayouts(index: 7).left)
                .top(Padding().sidePanels.topRegion.predictLayouts(index: 7).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.predictDimensions.width)
                .height(Padding.SidePanels.TopRegion.predictDimensions.height)
            super.updateViewConstraints()
        }else{
            keyboardView.layout(one)
                .left(Padding().numberPads.forNumber(num: 1).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 1).top)
            keyboardView.layout(two)
                .left(Padding().numberPads.forNumber(num: 2).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 2).top)
            keyboardView.layout(three)
                .left(Padding().numberPads.forNumber(num: 3).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 3).top)
            keyboardView.layout(four)
                .left(Padding().numberPads.forNumber(num: 4).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 4).top)
            keyboardView.layout(five)
                .left(Padding().numberPads.forNumber(num: 5).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 5).top)
            keyboardView.layout(six)
                .left(Padding().numberPads.forNumber(num: 6).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 6).top)
            keyboardView.layout(seven)
                .left(Padding().numberPads.forNumber(num: 7).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 7).top)
            keyboardView.layout(eight)
                .left(Padding().numberPads.forNumber(num: 8).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 8).top)
            keyboardView.layout(nine)
                .left(Padding().numberPads.forNumber(num: 9).left)
                .width(Padding.NumberPads.buttonWidth)
                .height(Padding.NumberPads.buttonHeight)
                .top(Padding().numberPads.forNumber(num: 9).top)
            keyboardView.layout(spaceButton)
                .left(Padding().spaceRegion.space.left)
                .width(Padding.SpaceRegion.spaceWidth)
                .top(Padding().spaceRegion.space.top)
                .height(Padding.SpaceRegion.globalDimentions.height)
            keyboardView.layout(nextKeyboardButton)
                .left(Padding().spaceRegion.global.left)
                .width(Padding.SpaceRegion.globalDimentions.width)
                .top(Padding().spaceRegion.global.top)
                .height(Padding.SpaceRegion.globalDimentions.height)
            keyboardView.layout(numberPadSwitcher)
                .left(Padding().spaceRegion.switchKey.left)
                .width(Padding.SpaceRegion.switchKeyDimentions.width)
                .top(Padding().spaceRegion.switchKey.top)
                .height(Padding.SpaceRegion.globalDimentions.height)
            keyboardView.layout(topRegion)
                .left(Padding().sidePanels.forRegions(reg: .top).left)
                .right()
                .top(Padding().sidePanels.forRegions(reg: .top).top)
                .height(Padding.SidePanels.topRegionHeight)
            keyboardView.layout(leftRegion)
                .left(Padding().sidePanels.forRegions(reg: .left).left)
                .width(Padding.SidePanels.leftRegionWidth)
                .top(Padding().sidePanels.forRegions(reg: .left).top)
                .bottom()
            keyboardView.layout(rightRegion)
                .left(Padding().sidePanels.forRegions(reg: .right).left)
                .right()
                .top(Padding().sidePanels.forRegions(reg: .right).top)
                .bottom()
            motherViewsHaveConstrainted = true
            super.updateViewConstraints()
            updateViewConstraints()
        }
    }
    
    func loadInterface() {
        let calculatorNib = UINib(nibName: "NinekeyKeyboard", bundle: nil)
        keyboardView = calculatorNib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.addSubview(keyboardView)
        view.backgroundColor = keyboardView.backgroundColor
        
        // This will make the button call advanceToNextInputMode() when tapped
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .touchUpInside)
        nextKeyboardButton.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
    }
}

extension KeyboardViewController {
    //MARK: Actions
    // Control nine main keys
    
    // When a key is pressed, this function is called.
    // If the mode is "numbers" (if it is in number mode where the buttons all show up as numbers),
    // it will call the regular keyscontrol.toggle function. This function will add the number
    // to the working display.text and render it.
    //
    // If the mode is "alphabets", it will call keyscontrol.t9Toggle. This function uses the t9Driver
    // class to getSuggestions of words. Once that function returns, this function will iterate through
    // that array and change the titles of the suggestion buttons on the keyboard to the suggestions.
    @IBAction func proceedNineKeyOperations(_ operation: RoundButton){
        if(operation.mode == "numbers"){
            display.text = keyscontrol.toggle(mode: operation.mode, tag:operation.tag)
            return
        }
        var suggestionsToRender = keyscontrol.t9Toggle(mode: operation.mode, tag: operation.tag)
        let max = 4
        if suggestionsToRender.count > max {
            for _ in 0..<suggestionsToRender.count - max {
                suggestionsToRender.removeLast()
            }
        }

        
//        for i in 0 ..< 3  {
//            NSLog(suggestionsToRender[i])
//            predict1.title = suggestionsToRender[i]
//        }
        if suggestionsToRender.count > 3 {
            predict1.setTitle(suggestionsToRender[0], for: .normal)
            predict1.setTitleColor(Color.black, for: .normal)
            predict2.setTitle(suggestionsToRender[1], for: .normal)
            predict2.setTitleColor(Color.black, for: .normal)
            predict3.setTitle(suggestionsToRender[2], for: .normal)
            predict3.setTitleColor(Color.black, for: .normal)
            predict4.setTitle(suggestionsToRender[3], for: .normal)
            predict4.setTitleColor(Color.black, for: .normal)
            
//            predict1.renderSuggestions(sugg: suggestionsToRender[0])
//            predict2.renderSuggestions(sugg: suggestionsToRender[1])
//            predict3.renderSuggestions(sugg: suggestionsToRender[2])
//            predict4.renderSuggestions(sugg: suggestionsToRender[3])
        } else {
            NSLog("Suggestions came back with less than 3")
            NSLog(String(suggestionsToRender.count))
        }
//        predict1.title = suggestionsToRender[0]
//        predict2.title = suggestionsToRender[1]
//        predict3.title = suggestionsToRender[2]
        // render in scroll area that will show the rest of the suggestions
        
    }
    
    @IBAction func predictionSelect(_ operation: RoundButton){
        //effectively the same as spaceselect, right?
        //pasted below is the same code
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        let input: String? = operation.currentTitle
        
        if input != nil {
            //proxy.insertText(input + " ") //this line inserts the text into the field (with a space)
            
            keyscontrol.wordSelected(word: input!)
            //should we have a function that's like returnKeySequence?
            keyscontrol.storedInputs.append(input! + " ")
            proxy.insertText(input! + " ")
        }
        else {
            return
        }
        keyscontrol.clear()
        
        predict1.setTitle("", for: .normal)
        predict2.setTitle("", for: .normal)
        predict3.setTitle("", for: .normal)
        predict4.setTitle("", for: .normal)
    }
    
    // When space is pressed, the user effectively selects the first suggestion button's suggestion.
    // The input text field will then display that word (and a space), and the working keySequence
    // will be cleared. The function will also call t9Driver's updateWeights function with the correct
    // word and keySequence (TODO: Still need a way to store this and communicate it to that level).
    @IBAction func spaceSelect(_ operation: RoundButton){
        let proxy = textDocumentProxy as UITextDocumentProxy
        if predict1.currentTitle != "" {
            predictionSelect(predict1)
        }
        else {
            proxy.insertText(" ")
        }
    }
    
    // below is the manual entry mode
//    @IBAction func proceedNineKeyOperations(_ operation: RoundButton) {
//        display.text = keyscontrol.toggle(mode: operation.mode, tag: operation.tag)
//    }
    
    
    // Number-Alphabet switcher
    @IBAction func toggleKeypad(_ toggleKey: UIButton) {
        one.switchMode()
        two.switchMode()
        three.switchMode()
        four.switchMode()
        five.switchMode()
        six.switchMode()
        seven.switchMode()
        eight.switchMode()
        nine.switchMode()
        spaceButton.switchMode()
    }
    //Backspace in active textfield
    @IBAction func shouldDeleteText(_ backspaceKey: RaisedButton){
        // Pass textfield controller back to keyboard so keyboard can control active textfield in any apps
         (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    //Dismiss keyboard
    @IBAction func shouldDismissKeyboard() {
        dismissKeyboard()
    }
    //Insert text in active textfield
    func shouldInsertText() {
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        if let input = display?.text as String? {
            proxy.insertText(input)
        }
        
        display.text = ""
        keyscontrol.clear()
    }
    
    //Backspace in display
    // This means that we now need to render suggestions one depth less. Thus, it calls
    // the keyscontrol.t9Backspace function. That function will get new suggestions which
    // will be returned here and rendered on the suggestion buttons.
    @IBAction func shouldDeleteTextInDisplay() {
        var suggestionsUpdate = [String]()
        suggestionsUpdate = keyscontrol.t9Backspace()
//        predict1.renderSuggestions(sugg: suggestionsUpdate[0])
//        predict2.renderSuggestions(sugg: suggestionsUpdate[1])
//        predict3.renderSuggestions(sugg: suggestionsUpdate[2])
//        predict4.renderSuggestions(sugg: suggestionsUpdate[3])
//        predict2.title = suggestionsUpdate[1]
//        predict3.title = suggestionsUpdate[2]
        // render new suggestions in button
    }
    
    func shouldClearPreviousWordInDisplay() {
        if let lastWordRange = display.text?.range(of: " ") {
            display.text?.removeSubrange(lastWordRange.lowerBound..<(display.text?.endIndex)!)
        }else{
            display.text = ""
            keyscontrol.clear()
        }
    }
    
    //Insert symbols
    @IBAction func inputSymbols(_ sender: RaisedButton) {
        display.text = display.text! + (sender.titleLabel?.text)!
    }
    
    //Send key
    @IBAction func returnKeyPressed() {
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        if let input = display?.text as String? {
            proxy.insertText(input + " ")
            keyscontrol.wordSelected(word: input)
            //NOTE: this will add a space by default, or else it gets complicated and confusing
            // update weights because a word has effectively been chosen
        }
        
        display.text = ""
        keyscontrol.clear()
    }
}

extension KeyboardViewController {
    //MARK:  Delegates
    //Control textfield behavior
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: UIControlState())
    }
}
