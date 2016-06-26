import UIKit
import SwaggerClient

class PostWotViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var wotField: UITextField!
    @IBOutlet weak var postWotButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.hidden = true
    }
    
    @IBAction func postWot() {
        if let login = loginField.text,
            let password = passwordField.text,
            let wot = wotField.text {

            activityView.startAnimating()

            let theWot = WotDTO()
            theWot.text = wot
            
            setAuthHeader(username: login, password: password)
            PublicAPI.postNewWotWithRequestBuilder(body: theWot).execute(postCompleted)
        }
    }

    func postCompleted(response: Response<WotDTO>?, error: ErrorType?) {
        dispatch_async(dispatch_get_main_queue(), { [weak self] () in
            self!.activityView.stopAnimating()
            
            let alert: UIAlertController
            if (error != nil) || (response?.statusCode >= 300) {
                alert = self!.createErrorPopup(response)
            } else {
                alert = self!.createSuccessPopup(response)
            }
            self?.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    private func createErrorPopup<T>(response: Response<T>?) -> UIAlertController {
        let alert = UIAlertController(title: "Error",
                                  message: "An error occurred (status \(response?.statusCode))",
                                  preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Too bad", style: UIAlertActionStyle.Default, handler: nil))
        return alert
    }
    
    private func createSuccessPopup(response: Response<WotDTO>?) -> UIAlertController {
        let data = response?.body
        let message: String
        if let postTime = data?.postTime {
            message = "Your wot was posted at \(postTime)."
        } else {
            message = "Your wot was posted."
        }
        
        let alert = UIAlertController(title: "Success",
                                  message: message,
                                  preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.Default) { [weak self] action in
            self?.performSegueWithIdentifier("return", sender: self)
            })
        
        return alert
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func setAuthHeader(username username: String, password: String) {
        let dataValue = (username + ":" + password).dataUsingEncoding(NSUTF8StringEncoding)
        let authHeaderValue = dataValue?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        SwaggerClientAPI.customHeaders["Authorization"] = "Basic \(authHeaderValue!)"
    }
    
}
