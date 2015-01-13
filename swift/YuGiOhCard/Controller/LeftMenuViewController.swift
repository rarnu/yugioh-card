import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate {

    var tableView = UITableView()
    var controllerNames = NSArray()
    var titles: NSArray = [LEFT_MENU_SEARCH, LEFT_MENU_LIMIT, LEFT_MENU_LATEST, LEFT_MENU_PACKAGE, LEFT_MENU_FAV, LEFT_MENU_TOOL]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerNames = ["searchViewController", "limitViewController", "latestViewController","packViewController", "favViewController", "toolViewController"]
        
        var tableView = UITableView(frame: CGRectMake(0, (self.view.frame.size.height - 54 * 6) / 2.0, self.view.frame.size.width, 54 * 6), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
        tableView.scrollsToTop = false
        
        self.tableView = tableView
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel!.font = UIFont(name: "HelveticaNeue", size:21)
            cell!.textLabel!.textColor = UIColor.whiteColor()
            cell!.textLabel!.highlightedTextColor = UIColor.lightGrayColor()
            cell!.selectedBackgroundView = UIView()
        }
        cell!.textLabel!.text = self.titles[indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        var mainStory = UIStoryboard(name: "Main", bundle: nil)
        var navController = UINavigationController(rootViewController: mainStory.instantiateViewControllerWithIdentifier(self.controllerNames[indexPath.row] as String) as UIViewController)
        self.sideMenuViewController!.setContentViewController(navController, animated: true)
        self.sideMenuViewController!.hideMenuViewController()
    }
}
