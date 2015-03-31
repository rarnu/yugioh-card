import UIKit

@objc
protocol CardAttributePickerDelegate: NSObjectProtocol {
    optional func pickDone(picked: String, textField: UITextField?)
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeUI()
    }
    
    func makeUI() {
        // self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
    
        self.toolbar = UIToolbar(frame: CGRectMake(0, 0, self.frame.size.width, 50))
        self.toolbar!.tintColor = UIColor.whiteColor()
        self.toolbar!.setBackgroundImage(UIImage(named: "popbg"), forToolbarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)

        toolTitle = UILabel(frame: CGRectMake(8, 0, self.toolbar!.frame.size.width-50, self.toolbar!.frame.size.height))
        toolTitle!.textColor = UIColor.whiteColor()
        var splitLine = UIView(frame: CGRectMake(0, self.toolbar!.frame.size.height, self.toolbar!.frame.size.width, 1))
        splitLine.backgroundColor = UIColor.grayColor()
        
        self.toolbar!.addSubview(toolTitle!)
        self.toolbar!.addSubview(splitLine)
    
        toolButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        toolButton!.backgroundColor = UIColor.clearColor()
        toolButton!.frame = (CGRectMake(self.toolbar!.frame.size.width-50, 0, 50, self.toolbar!.frame.size.height))
        toolButton!.setTitle(COMMON_DONE, forState:UIControlState.Normal)
        toolButton!.addTarget(self, action:"doneClick:", forControlEvents:UIControlEvents.TouchDown)
        self.toolbar!.addSubview(toolButton!)
    
        self.picker = UIPickerView(frame: CGRectMake(0, 51, self.frame.size.width, 0))
        self.picker!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.picker!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.picker!.showsSelectionIndicator = true
        self.picker!.dataSource = self
        self.picker!.delegate = self
    
        self.addSubview(self.toolbar!)
        self.addSubview(self.picker!)
    }
    
    func setTitle(title: String) {
        toolTitle!.text = title
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 65535
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.height / 4
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var title = self.pickObjects![row % self.pickObjects!.count] as String
        var lblView: UILabel?
        if (view == nil) {
            lblView = UILabel()
            lblView!.backgroundColor = UIColor.clearColor()
            lblView!.textColor = UIColor.whiteColor()
            lblView!.textAlignment = NSTextAlignment.Center
            lblView!.font = UIFont.boldSystemFontOfSize(24)
        } else {
            lblView = view as? UILabel
        }
        lblView!.text = title
        return lblView!
    }
    
    func doneClick(sender: AnyObject) {
        var picked = self.pickObjects![self.picker!.selectedRowInComponent(0) % self.pickObjects!.count] as String
        self.delegate?.pickDone?(picked, textField: self.txtResult)
    }
    
    func selectFirst() {
        var selected = (65536 / 2) - (65536 % self.pickObjects!.count) - 1
        self.picker!.selectRow(selected, inComponent: 0, animated: false)
    }
    
    func selectCurrent(text: String) {
        var selected = (65536 / 2) - (65536 % self.pickObjects!.count) - 1
        for (var i = selected; i < selected + self.pickObjects!.count; i++) {
            if ((self.pickObjects![i % self.pickObjects!.count] as String) == text) {
                self.picker!.selectRow(i, inComponent:0, animated:false)
                break
            }
        }
    }

}
