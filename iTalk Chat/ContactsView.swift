//
//  ContactsView.swift
//  iTalk
//
//  Created by Patricio Benavente on 26/03/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import SwiftUI	

struct ContactsView: View {
	@ObservedObject private var viewModel = ContactsVM()
	@Environment(\.presentationMode) var presentationMode
	let didSelectNewUser: (User) -> ()
	
    var body: some View {
		Text("List of Contacts")
		NavigationView {
			ScrollView {
				#warning("TODO: get only users in contacts app")
				ForEach(viewModel.users) { contact in
					Button {
						presentationMode.wrappedValue.dismiss()
						didSelectNewUser(contact)
					} label: {
						ContactCell(contact: contact)
					}
				}
			}
		}
		.navigationBarTitle(Text("iTalk"), displayMode: .inline)
		.toolbar {
			ToolbarItemGroup(placement: .navigationBarLeading) {
				Button {
					presentationMode.wrappedValue.dismiss()
				} label: {
					Text("Cancel")
				}
			}
		}
	}
}



struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
		iTalkView()
//		HistoryView()
//		ContactsView()
    }
}
