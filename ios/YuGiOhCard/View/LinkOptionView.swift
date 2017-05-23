//
//  LinkOptionView.swift
//  YuGiOhCard
//
//  Created by rarnu on 5/22/17.
//  Copyright © 2017 rarnu. All rights reserved.
//

import UIKit

@objc protocol LinkOptionViewDelegate: NSObjectProtocol {
    @objc optional func onLinkOption(view: LinkOptionView, isOK: Bool, linkCount: String, linkArrow: String)
}

class LinkOptionView: UIView {

    @IBOutlet var btnOK: UIButton?
    @IBOutlet var btnCancel: UIButton?
    
    @IBOutlet var cnt1: UIButton?
    @IBOutlet var cnt2: UIButton?
    @IBOutlet var cnt3: UIButton?
    @IBOutlet var cnt4: UIButton?
    @IBOutlet var cnt5: UIButton?
    @IBOutlet var cnt6: UIButton?
    @IBOutlet var cnt7: UIButton?
    @IBOutlet var cnt8: UIButton?
    
    @IBOutlet var arr7: UIButton?
    @IBOutlet var arr8: UIButton?
    @IBOutlet var arr9: UIButton?
    @IBOutlet var arr4: UIButton?
    @IBOutlet var arr6: UIButton?
    @IBOutlet var arr1: UIButton?
    @IBOutlet var arr2: UIButton?
    @IBOutlet var arr3: UIButton?
    
    var linkCount = ""
    var linkArrow = ""
    
    var picker: CardAttributePicker?
    var delegate: LinkOptionViewDelegate?
    
    class func initWithNib() -> LinkOptionView? {
        let nib = UINib(nibName: "LinkOptionView", bundle: Bundle.main)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as? LinkOptionView
        view!.makeUI()
        return view
    }
    
    func makeUI() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        let size = ApplicationUtils.getApplicationSize()
        let cx: CGFloat = size.width / 2
        let cy: CGFloat = size.height / 2
        self.center = CGPoint(x: cx, y: cy)
        self.isUserInteractionEnabled = true
    }
    
    func initData(count: String, arrow: String) {
        linkCount = count
        linkArrow = arrow
        setCountColor()
        setArrowColor()
    }
    
    func setCountColor() {
        cnt1?.setTitleColor(linkCount == "1" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt2?.setTitleColor(linkCount == "2" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt3?.setTitleColor(linkCount == "3" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt4?.setTitleColor(linkCount == "4" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt5?.setTitleColor(linkCount == "5" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt6?.setTitleColor(linkCount == "6" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt7?.setTitleColor(linkCount == "7" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        cnt8?.setTitleColor(linkCount == "8" ? UIColor.orange : UIColor.white, for: UIControlState.normal)
    }
    
    func setArrowColor() {
        arr1?.setTitleColor(linkArrow.contains("1") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr2?.setTitleColor(linkArrow.contains("2") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr3?.setTitleColor(linkArrow.contains("3") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr4?.setTitleColor(linkArrow.contains("4") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr6?.setTitleColor(linkArrow.contains("6") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr7?.setTitleColor(linkArrow.contains("7") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr8?.setTitleColor(linkArrow.contains("8") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
        arr9?.setTitleColor(linkArrow.contains("9") ? UIColor.orange : UIColor.white, for: UIControlState.normal)
    }
    
    func buildArrowStr() {
        linkArrow = ""
        if (arr1?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "1,"
        }
        if (arr2?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "2,"
        }
        if (arr3?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "3,"
        }
        if (arr4?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "4,"
        }
        if (arr6?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "6,"
        }
        if (arr7?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "7,"
        }
        if (arr8?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "8,"
        }
        if (arr9?.titleColor(for: UIControlState.normal) == UIColor.orange) {
            linkArrow += "9,"
        }
        linkArrow = linkArrow.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
    }
    
    @IBAction func btnClicked(sender: Any?) {
        let btn = sender as? UIButton
        if (btn == btnOK) {
            delegate?.onLinkOption?(view: self, isOK: true, linkCount: linkCount, linkArrow: linkArrow)
        } else if (btn == btnCancel) {
            delegate?.onLinkOption?(view: self, isOK: false, linkCount: "0", linkArrow: "")
        } else if (btn == cnt1) {
            if (linkCount == "1") { linkCount = "" } else { linkCount = "1" }
            setCountColor()
        } else if (btn == cnt2) {
            if (linkCount == "2") { linkCount = "" } else { linkCount = "2" }
            setCountColor()
        } else if (btn == cnt3) {
            if (linkCount == "3") { linkCount = "" } else { linkCount = "3" }
            setCountColor()
        } else if (btn == cnt4) {
            if (linkCount == "4") { linkCount = "" } else { linkCount = "4" }
            setCountColor()
        } else if (btn == cnt5) {
            if (linkCount == "5") { linkCount = "" } else { linkCount = "5" }
            setCountColor()
        } else if (btn == cnt6) {
            if (linkCount == "6") { linkCount = "" } else { linkCount = "6" }
            setCountColor()
        } else if (btn == cnt7) {
            if (linkCount == "7") { linkCount = "" } else { linkCount = "7" }
            setCountColor()
        } else if (btn == cnt8) {
            if (linkCount == "8") { linkCount = "" } else { linkCount = "8" }
            setCountColor()
        } else {
            if (btn?.titleColor(for: UIControlState.normal) == UIColor.orange) {
                btn?.setTitleColor(UIColor.white, for: UIControlState.normal)
            } else {
                btn?.setTitleColor(UIColor.orange, for: UIControlState.normal)
            }
            buildArrowStr()
        }
    }
}
