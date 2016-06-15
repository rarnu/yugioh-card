import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate {

    var tableView = UITableView()
    var controllerNames = NSArray()
    var titles: NSArray = [LEFT_MENU_SEARCH, LEFT_MENU_LIMIT, LEFT_MENU_LATEST, LEFT_MENU_PACKAGE, LEFT_MENU_FAV, LEFT_MENU_TOOL]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerNames = ["searchViewController", "limitViewController", "latestViewController","packViewController", "favViewController", "toolViewController"]
        
        let tableView = UITableView(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 6) / 2.0, width: self.view.frame.size.width, height: 54 * 6), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        tableView.scrollsToTop = false
        
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.0
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let navController = UINavigationController(rootViewController: mainStory.instantiateViewController(withIdentifier: self.controllerNames[indexPath.row] as! String) )
        self.sideMenuViewController!.setContentViewController(contentViewController: navController, animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
}
