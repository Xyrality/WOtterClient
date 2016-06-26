import UIKit
import SwaggerClient

class ShowWotsTableViewController: UITableViewController {

    var wots: [WotDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wots.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wotCell")!

        let wot = wots[indexPath.row]
        cell.textLabel?.text = wot.text!
        cell.detailTextLabel?.text = "Posted at \(wot.postTime!) by \(wot.author!)"

        return cell
    }
}
