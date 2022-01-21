//
//  UserCredentialsView.swift
//  next-star
//
//  Created by jay on 20.01.22.
//

import SwiftUI

struct UserCredentialsView: View {
    @Binding var network: Network
    @Binding var hasCredentials: Bool
    
    @State private var username = ""
    @State private var password = ""
    @State private var nextcloudInstanceURL = UserDefaults.standard.string(forKey: "nextcloudInstanceURL") ?? ""
    
    var body: some View {
        Text("User credentials").font(.title)
        
        Form {
            Text("Username").font(.title3)
            TextField("Enter your username",
                      text: $username
            ).disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            
            Text("Password").font(.title3)
            TextField("Enter your password",
                      text: $password
            ).disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            
            Text("Nextcloud instance URL").font(.title3)
            TextField("https://my.nextcloud.instance",
                     text: $nextcloudInstanceURL
           ).disableAutocorrection(true)
                .autocapitalization(UITextAutocapitalizationType.none)
            Button("Save", action: {
//                print(username)
//                print(password)
//                print(nextcloudInstanceURL)
                let credentials = Credentials(username: username, password: password)
                do {
                    try KeychainManager().setCredentials(credentials: credentials, server: nextcloudInstanceURL)
                    network.updateCredentials(username: username, password: password, serverURL: nextcloudInstanceURL)
                    UserDefaults.standard.set(nextcloudInstanceURL, forKey: "nextcloudInstanceURL")
                    UserDefaults.standard.set(true, forKey: "hasCredentials")
                    hasCredentials = true
                } catch {
                    print("error saving credentials to keychain")
                    print(error)
                }
                
            })
        }
        
    }
}

struct UserCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        UserCredentialsView(network: .constant(Network()), hasCredentials: .constant(false))
    }
}
