import UIKit

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    var controllerNames = NSArray()
    var titles: NSArray = [RIGHT_MENU_SETTING, RIGHT_MENU_UPDATE, RIGHT_MENU_FEEDBACK, RIGHT_MENU_ABOUT]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerNames = ["settingViewController", "updateViewController", "feedbackViewController", "aboutViewController"]
        
        var tableView = UITableView(frame: CGRectMake(0, (self.view.frame.size.height - 54 * 4) / 2.0, self.view.frame.size.width, 54 * 4), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
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
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
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
        cell!.textLabel!.textAlignment = NSTextAlignment.Right
        return cell!

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        var mainStory = UIStoryboard(name: "Main", bundle: nil)
        var controller: SearchViewController? = mainStory.instantiateViewControllerWithIdentifier("searchViewController") as? SearchViewController
        var pushViewName = self.controllerNames[indexPath.row] as! String;
        controller!.pushView = pushViewName
        var nav = UINavigationController(rootViewController: controller!)
        self.sideMenuViewController!.setContentViewController(nav, animated:false)
        self.sideMenuViewController!.hideMenuViewController()

    }

}
