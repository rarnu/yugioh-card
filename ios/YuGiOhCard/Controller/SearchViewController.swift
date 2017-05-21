import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, CardAttributePickerDelegate, AboutViewDelegate {

    @IBOutlet var sv: UIScrollView?
    @IBOutlet var txtCardName: UITextField?
    @IBOutlet var txtCamp: UITextField?
    @IBOutlet var txtCardType: UITextField?
    @IBOutlet var txtSubtype: UITextField?
    @IBOutlet var txtRace: UITextField?
    @IBOutlet var txtAttribute: UITextField?
    @IBOutlet var txtLevel: UITextField?
    @IBOutlet var txtRare: UITextField?
    @IBOutlet var txtLimit: UITextField?
    @IBOutlet var txtAtk: UITextField?
    @IBOutlet var txtDef: UITextField?
    @IBOutlet var txtEffect: UITextField?
    
    var pushView: String? = ""
    
    var picker: CardAttributePicker?
    var searchButton: UIBarButtonItem?
    var cancelButton: UIBarButtonItem?
    var inited = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIUtils.setStatusBar(light: true)
        UIUtils.setNavBar(nav: self.navigationController!.navigationBar)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (!inited) {
            inited = true
            for temp in self.view.subviews {
                if (temp is UILabel) || (temp is UITextField) {
                    UIUtils.scaleComponent(view: temp)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inited = false
        self.navigationItem.title = "YuGiOh"
        
        searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(searchClick(sender:)))
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(cancelClick(sender:)))
        self.navigationItem.rightBarButtonItems = [cancelButton!, searchButton!]
        self.resetData()
        
        if (self.pushView != nil && self.pushView != "") {
            if (self.pushView == "aboutViewController") {
                self.showAboutView()
            } else {
                let singleStory = UIStoryboard(name: "SingleStories", bundle: nil)
                let controller = singleStory.instantiateViewController(withIdentifier: self.pushView!) 
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
    
        self.txtCardName!.layer.borderWidth = 0.5
        self.txtCardName!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtAtk!.layer.borderWidth = 0.5
        self.txtAtk!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtDef!.layer.borderWidth = 0.5
        self.txtDef!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtEffect!.layer.borderWidth = 0.5
        self.txtEffect!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCamp!.layer.borderWidth = 0.5
        self.txtCamp!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtCardType!.layer.borderWidth = 0.5
        self.txtCardType!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSubtype!.layer.borderWidth = 0.5
        self.txtSubtype!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtRace!.layer.borderWidth = 0.5
        self.txtRace!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtAttribute!.layer.borderWidth = 0.5
        self.txtAttribute!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtLevel!.layer.borderWidth = 0.5
        self.txtLevel!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtRare!.layer.borderWidth = 0.5
        self.txtRare!.layer.borderColor = UIColor.lightGray.cgColor
        self.txtLimit!.layer.borderWidth = 0.5
        self.txtLimit!.layer.borderColor = UIColor.lightGray.cgColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAboutView() {
        self.setEditMode(inEditing: true)
        let av = AboutView.initWithNib()
        av!.delegate = self;
        self.view.addSubview(av!)
    }
    
    func aboutview(view: AboutView, tapped dismiss: Bool) {
        view.removeFromSuperview()
        self.setEditMode(inEditing: false)
    }
    
    func resetData() {
        self.txtCardName!.text = ""
        self.txtCamp!.text = CardConsts.campDefault()
        self.txtCardType!.text = CardConsts.cardTypeDefault()
        self.txtSubtype!.text = CardConsts.cardSubTypeDefault()
        self.txtRace!.text = CardConsts.cardRaceDefault()
        self.txtAttribute!.text = CardConsts.cardAttributeDefault()
        self.txtLevel!.text = CardConsts.cardLevelDefault()
        self.txtRare!.text = CardConsts.cardRareDefault()
        self.txtLimit!.text = CardConsts.cardLimitDefault()
        self.txtAtk!.text = ""
        self.txtDef!.text = ""
        self.txtEffect!.text = ""
    
        self.view.endEditing(true)
    }
    
    func setEditMode(inEditing: Bool) {
        searchButton!.isEnabled = !inEditing
        cancelButton!.isEnabled = !inEditing
        self.navigationItem.leftBarButtonItem!.isEnabled = !inEditing
    
        self.txtCardName!.isEnabled = !inEditing
        self.txtCamp!.isEnabled = !inEditing
        self.txtCardType!.isEnabled = !inEditing
        self.txtSubtype!.isEnabled = !inEditing
        self.txtRace!.isEnabled = !inEditing
        self.txtAttribute!.isEnabled = !inEditing
        self.txtLevel!.isEnabled = !inEditing
        self.txtRare!.isEnabled = !inEditing
        self.txtLimit!.isEnabled = !inEditing
        self.txtAtk!.isEnabled = !inEditing
        self.txtDef!.isEnabled = !inEditing
        self.txtEffect!.isEnabled = !inEditing
    
    }
    
    
    func searchClick(sender: AnyObject) {
        self.view.endEditing(true)
        self.pushViewController()
    }
    
    func cancelClick(sender: AnyObject) {
        self.resetData()
    }
    
    func pushViewController() {
        let resultViewController = self.storyboard!.instantiateViewController(withIdentifier: "searchResultViewController") as! SearchResultViewController
        resultViewController.searchCardName = self.txtCardName!.text
        resultViewController.searchCamp = self.txtCamp!.text
        resultViewController.searchCardType = self.txtCardType!.text
        resultViewController.searchSubType = self.txtSubtype!.text
        resultViewController.searchRace = self.txtRace!.text
        resultViewController.searchAttribute = self.txtAttribute!.text
        resultViewController.searchLevel = self.txtLevel!.text
        resultViewController.searchRare = self.txtRare!.text
        resultViewController.searchLimit = self.txtLimit!.text
        resultViewController.searchAtk = self.txtAtk!.text
        resultViewController.searchDef = self.txtDef!.text
        resultViewController.searchEffect = self.txtEffect!.text
        self.navigationController!.pushViewController(resultViewController, animated:true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.tag == 0) {
            return true
        } else {
            self.view.endEditing(true)
            self.setEditMode(inEditing: true)
            if (textField == txtSubtype) {
                if (txtCardType!.text!.contains(MONSTER_LINK)) {
                    // TODO: link
                    self.setEditMode(inEditing: false)
                } else {
                    self.popupPicker(textField: textField)
                }
            } else {
                self.popupPicker(textField: textField)
            }
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func pickDone(picked: String, textField: UITextField?) {
        let rect = UIScreen.main.applicationFrame
        textField!.text = picked
        if (textField == txtCardType) {
            if (txtCardType!.text!.contains(MONSTER_LINK)) {
                txtSubtype?.text = "连接属性"
            } else {
                txtSubtype?.text = "不限"
            }
        }
        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.picker!.frame
            rectSelectDate.origin.y = rect.size.height
            self.picker!.frame = rectSelectDate
            }, completion: { (_) in
                self.picker!.removeFromSuperview()
                self.setEditMode(inEditing: false)
        })
    }
    
    func popupPicker(textField: UITextField) {
        let rect = UIScreen.main.applicationFrame
        let rw = rect.size.width * 0.8
        let left = (rect.size.width - rw) / 2
        picker = CardAttributePicker(frame: CGRect(x: left, y: rect.size.height, width: rw, height: 266))
        picker!.setTitle(title: textField.placeholder!)
        picker!.txtResult = textField
        switch (textField.tag) {
        case 1: // camp
            picker!.pickObjects = CardConsts.campList()
        case 2: // card type
            picker!.pickObjects = CardConsts.cardTypeList()
        case 3: // monster type
            picker!.pickObjects = CardConsts.cardSubTypeList()
        case 4: // race
            picker!.pickObjects = CardConsts.cardRaceList()
        case 5: // attribute
            picker!.pickObjects = CardConsts.cardAttributeList()
        case 6: // level
            picker!.pickObjects = CardConsts.cardLevelList()
        case 7: // rare
            picker!.pickObjects = CardConsts.cardRareList()
        case 8: // limit
            picker!.pickObjects = CardConsts.cardLimitList()
        default:
            break
        }
    
        let current = textField.text
        if (current == "") {
            picker!.selectFirst()
        } else {
            picker!.selectCurrent(text: current!)
        }
        picker!.delegate = self
        self.view.addSubview(picker!)
        UIView.animate(withDuration: 0.5, animations: { () in
            var rectSelectDate = self.picker!.frame
            rectSelectDate.origin.y = (rect.size.height - self.picker!.frame.size.height)/2;
            self.picker!.frame = rectSelectDate
            }, completion: { (_) in
                textField.isEnabled = false
        })
    }



}
