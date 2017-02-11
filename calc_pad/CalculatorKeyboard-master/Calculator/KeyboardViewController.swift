//
//  KeyboardViewController.swift
//  Calculator
//
//  Created by Shaun O'Reilly on 11/11/2015.
//  Copyright © 2015 Visual Recruit Pty Ltd. All rights reserved.
//

import UIKit
import Material

class KeyboardViewController: UIInputViewController {
    //MARK: Outlets
    @IBOutlet var topRegion: UIView!
    @IBOutlet var leftRegion: UIView!
    @IBOutlet var rightRegion: UIView!
    @IBOutlet var nextKeyboardButton: IconButton!
    @IBOutlet var numberPadSwitcher: UIButton!
    @IBOutlet var insertButton: IconButton!
    @IBOutlet var dismissButton: IconButton!
    @IBOutlet var displayBackspace: IconButton!
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
    
    @IBOutlet var one: RoundButton!{
        didSet{
            one.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var two: RoundButton!{
        didSet{
            two.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var three: RoundButton!{
        didSet{
            three.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var four: RoundButton!{
        didSet{
            four.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var five: RoundButton!{
        didSet{
            five.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var six: RoundButton!{
        didSet{
            six.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var seven: RoundButton!{
        didSet{
            seven.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var eight: RoundButton!{
        didSet{
            eight.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    @IBOutlet var nine: RoundButton!{
        didSet{
            nine.setBackgroundColor(color: UIColor.lightGray, forState: .highlighted)
        }
    }
    
    //MARK: Variables
    
    var keyboardView: UIView!
    var shouldClearDisplayBeforeInserting = true
    var keyscontrol = KeysControl()
    var motherViewsHaveConstrainted = false
    
    //MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
        updateViewConstraints()
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
            topRegion.layout(insertButton)
                .left(Padding().sidePanels.topRegion.buttonsLayouts(index: 1).left)
                .top(Padding().sidePanels.topRegion.buttonsLayouts(index: 1).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.buttonsDimensions.width)
            topRegion.layout(dismissButton)
                .left(Padding().sidePanels.topRegion.buttonsLayouts(index: 2).left)
                .top(Padding().sidePanels.topRegion.buttonsLayouts(index: 2).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.buttonsDimensions.width)
            topRegion.layout(displayBackspace)
                .left(Padding().sidePanels.topRegion.buttonsLayouts(index: 3).left)
                .top(Padding().sidePanels.topRegion.buttonsLayouts(index: 3).top)
                .bottom()
                .width(Padding.SidePanels.TopRegion.buttonsDimensions.width)
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
    @IBAction func proceedNineKeyOperations(_ operation: RoundButton) {
        if !(Keys.NineKeys.mapping[operation.mode]?[String(operation.tag)]?.indices.contains(3))! {
            syms_1.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![0]
            syms_2.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![1]
            syms_3.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![2]
            syms_4.title = ""
        } else {
            syms_1.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![0]
            syms_2.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![1]
            syms_3.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![2]
            syms_4.title = Keys.NineKeys.mapping[operation.mode]![String(operation.tag)]![3]
        }
        display.text = keyscontrol.toggle(mode: operation.mode, tag: operation.tag)
    }
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
    @IBAction func shouldDeleteText(_ backspaceKey: RaisedButton){
         (textDocumentProxy as UIKeyInput).deleteBackward()
    }
    @IBAction func shouldDismissKeyboard() {
        dismissKeyboard()
    }
    @IBAction func shouldInsertText() {
        let proxy = textDocumentProxy as UITextDocumentProxy
        
        if let input = display?.text as String? {
            proxy.insertText(input)
        }
        
        display.text = ""
        keyscontrol.clear()
    }
    @IBAction func shouldDeleteTextInDisplay() {
        display.text = keyscontrol.backspace()
    }
    @IBAction func inputSymbols(_ sender: RaisedButton) {
        display.text = display.text! + (sender.titleLabel?.text)! //need to change this so it replaces previously typed
    }
    @IBAction func returnKeyPressed() {
        self.dismissKeyboard()
    }
}

extension KeyboardViewController {
    //MARK:  Delegates
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
