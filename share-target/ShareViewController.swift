import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            
                            let nextcloudInstanceUrl = UserDefaults(suiteName: Constants().GROUP_ID)!.string(forKey: "nextcloudInstanceURL") ?? ""
                            
                            let hasCredentials = UserDefaults(suiteName: Constants().GROUP_ID)!.bool(forKey: "hasCredentials")
                            
                            if (hasCredentials && nextcloudInstanceUrl != "") {
                                do {
                                    let credentials = try KeychainManager().getCredentials(server: nextcloudInstanceUrl)
                                    
                                    Network(username: credentials.username, password: credentials.password, serverURL: nextcloudInstanceUrl).createBookmark(url: shareURL.absoluteString!)
                                } catch {
                                    print("error retrieving credentials in share extension")
                                }
                            }
                        }
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
                    })
                }
            }
        }
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
