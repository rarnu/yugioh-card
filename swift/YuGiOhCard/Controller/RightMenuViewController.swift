import UIKit

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    var controllerNames = NSArray()
    var titles: NSArray = [RIGHT_MENU_SETTING, RIGHT_MENU_UPDATE, RIGHT_MENU_FEEDBACK, RIGHT_MENU_ABOUT]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerNames = ["settingViewController", "updateViewController", "feedbackViewController", "aboutViewController"]
        
        let tableView = UITableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 4) / 2.0, width: self.view.frame.size.width, height: 54 * 4), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        self.tableView = tableView
        self.view.addSubview(self.tableView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell!.backgroundColor = UIColor.clear()
            cell!.textLabel!.font = UIFont(name: "HelveticaNeue", size:21)
            cell!.textLabel!.textColor = UIColor.white()
            cell!.textLabel!.highlightedTextColor = UIColor.lightGray()
            cell!.selectedBackgroundView = UIView()
        }
        cell!.textLabel!.text = self.titles[indexPath.row] as? String
        cell!.textLabel!.textAlignment = NSTextAlignment.right
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let controller: SearchViewController? = mainStory.instantiateViewController(withIdentifier: "searchViewController") as? SearchViewController
        let pushViewName = self.controllerNames[indexPath.row] as! String;
        controller!.pushView = pushViewName
        let nav = UINavigationController(rootViewController: controller!)
        self.sideMenuViewController!.setContentViewController(contentViewController: nav, animated:false)
        self.sideMenuViewController!.hideMenuViewController()
    }

}
