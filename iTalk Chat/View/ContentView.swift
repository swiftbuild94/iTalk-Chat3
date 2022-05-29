//
//  MainView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 21/02/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vmLogin = LogInSignInVM()
    @ObservedObject private var vmContacts = ContactsVM()
    @ObservedObject private var vmAlerts = Alerts()
//    @ObservedObject private var vmChats = ChatsVM(chatUser: nil)
//    @State var isUserLoggedOut = false
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection){
            iTalkView()
                .tabItem {
                    VStack {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("iTalk")
                    }
            }
            .tag(0)
            HistoryView()
                .tabItem {
                    VStack {
                        Image(systemName: "clock.fill")
                        Text("History")
                    }
            }
            .tag(1)
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            .tag(2)
        }
        .fullScreenCover(isPresented: $vmLogin.isUserLoggedOut) {
            LogInView(didCompleateLoginProcess: {
                self.vmLogin.isUserLoggedOut = true
                self.vmLogin.getCurrentUser()
                self.vmContacts.getRecentMessagges()
                self.vmContacts.getAllUsers()
            })
        }
        .fullScreenCover(isPresented: $vmContacts.isShowChat) {
            ChatView(chatUser: vmContacts.currentUser!)
        }
        .alert(isPresented: $vmAlerts.isAlert) {
            if vmAlerts.showCancel {
                let defaultButton = Alert.Button.default(Text(vmAlerts.defaultText)) {
                    vmAlerts.okHandler!()
                }
                return Alert(title: Text(vmAlerts.title), message: Text(vmAlerts.message), primaryButton: vmAlerts.buttonCancel, secondaryButton: defaultButton)
                
            } else if vmAlerts.showDestructive {
                let destructiveButton = Alert.Button.destructive(Text(vmAlerts.defaultText)) {
                    vmAlerts.destructiveHandler!()
                }
                return Alert(title: Text(vmAlerts.title), message: Text(vmAlerts.message), primaryButton: vmAlerts.buttonCancel, secondaryButton: destructiveButton)
            } else {
                return Alert(title: Text(vmAlerts.title), message: Text(vmAlerts.message), dismissButton: vmAlerts.buttonDefault)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
