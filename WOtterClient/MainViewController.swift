import UIKit
import SwaggerClient

class MainViewController: UIViewController {

    @IBOutlet weak var postWotButton: UIButton!
    @IBOutlet weak var showWotsButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    var loadedWotList: [WotDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showWots() {
        PublicAPI.listWots(timeOrder: nil, offset: nil, limit: nil) { (data, error) in
            dispatch_async(dispatch_get_main_queue(), { [weak self] () in
                if let data = data {
                    self!.loadedWotList = data
                    self!.performSegueWithIdentifier("showWots", sender: self)
                }
            })
        }
    }

    @IBAction func unwindFromChild(segue: UIStoryboardSegue) {
        // nothing to do
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ShowWotsTableViewController {
            destination.wots = loadedWotList
        }
    }

}
