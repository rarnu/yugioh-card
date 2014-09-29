import UIKit

class SearchViewController: UIViewController {

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
    
    var pushView: String = ""
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
