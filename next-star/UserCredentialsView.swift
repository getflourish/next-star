import SwiftUI

struct UserCredentialsView: View {
    @Binding var network: Network
    @Binding var hasCredentials: Bool
    @Binding var displayNotification: (String, Bool) -> ()
    
    @State private var username = ""
    @State private var password = ""
    @State private var nextcloudInstanceURL = ""
    
    var body: some View {
      NavigationView {
        
        
        Form {
          
          Section(header: Text("Nextcloud instance URL"))  {
            TextField("https://my.nextcloud.instance",
                     text: $nextcloudInstanceURL
           ).disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
          }
        
          Section(header: Text("Username"))  {
            
            TextField("Enter your username",
                      text: $username
            ).disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
          }
          
          Section(header: Text("Password"))  {
            
            SecureField("Enter your password",
                      text: $password
            ).disableAutocorrection(true)
              .autocapitalization(UITextAutocapitalizationType.none)
          }
          
          Section {
            Button(action: saveCredentials) {
              Text("Continue").multilineTextAlignment(.center)
          }
          }
          

            
       }
        .navigationTitle("Connect")
        
          
   
      }
        
    }
}

struct UserCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        UserCredentialsView(network: .constant(Network()), hasCredentials: .constant(false), displayNotification: .constant({_,_ in }))
    }
}

extension UserCredentialsView {
    func saveCredentials() {
        let credentials = Credentials(username: username, password: password)
        network.updateCredentials(username: username, password: password, serverURL: nextcloudInstanceURL)
        
        // Verify credentials
        network.getTags { (result) in
            switch result {
            case.success(_):
                    displayNotification("Success verifying credentials!", false)
                    // Store credentials
                    do {
                        try KeychainManager().setCredentials(credentials: credentials, server: nextcloudInstanceURL)
                        UserDefaults(suiteName: Constants().GROUP_ID)!.set(nextcloudInstanceURL, forKey: "nextcloudInstanceURL")
                        UserDefaults(suiteName: Constants().GROUP_ID)!.set(true, forKey: "hasCredentials")
                        // Update view
                        hasCredentials = true
                    }
                    catch {
                        displayNotification("error saving credentials to keychain", true)
                        print("error saving credentials to keychain")
                        print(error)
                    }
                case.failure(let error):
                    displayNotification(error.localizedDescription, true)
                    print(error.localizedDescription)
            }
        }
    }
}
