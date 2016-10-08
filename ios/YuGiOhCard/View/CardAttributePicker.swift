import UIKit

@objc protocol CardAttributePickerDelegate: NSObjectProtocol {
    @objc optional func pickDone(picked: String, textField: UITextField?)
}

class CardAttributePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    var picker: UIPickerView?
    var toolbar: UIToolbar?
    var txtResult: UITextField?
    var pickObjects: NSArray?
    var delegate: CardAttributePickerDelegate?

    var toolTitle: UILabel?
    var toolButton: UIButton?
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeUI()
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeUI()
    }
    
    func makeUI() {
        // self.backgroundColor = UIColor.blackColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        self.toolbar!.tintColor = UIColor.white
        self.toolbar!.setBackgroundImage(UIImage(named: "popbg"), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)

        toolTitle = UILabel(frame: CGRect(x: 8, y: 0, width: self.toolbar!.frame.size.width-50, height: self.toolbar!.frame.size.height))
        toolTitle!.textColor = UIColor.white
        let splitLine = UIView(frame: CGRect(x: 0, y: self.toolbar!.frame.size.height, width: self.toolbar!.frame.size.width, height: 1))
        splitLine.backgroundColor = UIColor.gray
        
        self.toolbar!.addSubview(toolTitle!)
        self.toolbar!.addSubview(splitLine)
    
        toolButton = UIButton(type: UIButtonType.system)
        toolButton!.backgroundColor = UIColor.clear
        toolButton!.frame = (CGRect(x: self.toolbar!.frame.size.width-50, y: 0, width: 50, height: self.toolbar!.frame.size.height))
        toolButton!.setTitle(COMMON_DONE, for: [])
        toolButton!.addTarget(self, action:#selector(doneClick(sender:)), for:UIControlEvents.touchDown)
        self.toolbar!.addSubview(toolButton!)
    
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 51, width: self.frame.size.width, height: self.frame.size.height - 50))
        self.picker!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.picker!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.picker!.showsSelectionIndicator = true
        self.picker!.dataSource = self
        self.picker!.delegate = self
    
        self.addSubview(self.toolbar!)
        self.addSubview(self.picker!)
    }
    
    func setTitle(title: String) {
        toolTitle!.text = title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 65535
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.height / 4
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title = self.pickObjects![row % self.pickObjects!.count] as! String
        var lblView: UILabel?
        if (view == nil) {
            lblView = UILabel()
            lblView!.backgroundColor = UIColor.clear
            lblView!.textColor = UIColor.white
            lblView!.textAlignment = NSTextAlignment.center
            lblView!.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            lblView = view as? UILabel
        }
        lblView!.text = title
        return lblView!
    }
    
    func doneClick(sender: AnyObject) {
        let picked = self.pickObjects![self.picker!.selectedRow(inComponent: 0) % self.pickObjects!.count] as! String
        self.delegate?.pickDone?(picked: picked, textField: self.txtResult)
    }
    
    func selectFirst() {
        let selected = (65536 / 2) - (65536 % self.pickObjects!.count) - 1
        self.picker!.selectRow(selected, inComponent: 0, animated: false)
    }
    
    func selectCurrent(text: String) {
        let selected = (65536 / 2) - (65536 % self.pickObjects!.count) - 1
        for i in selected ..< selected + self.pickObjects!.count {
            if ((self.pickObjects![i % self.pickObjects!.count] as! String) == text) {
                self.picker!.selectRow(i, inComponent:0, animated:false)
                break
            }
        }
    }

}
