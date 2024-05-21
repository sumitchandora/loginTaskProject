//
//  loggedInPage.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 20/05/24.
//

import SwiftUI
import CoreData
struct LoggedInPage: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.emailOrNum, ascending: true)]) var fetched: FetchedResults<UserInfo>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Notes.email, ascending: true)]) var fetched2: FetchedResults<Notes>
    @Binding var isAuthenticated: Bool
    @Binding var userCorrespondingInfo: UserInfo
    @State var sheet = false
    @State var title = ""
    @State var descriptions = ""
    @State var fetchedItems:[Notes?] = []
    var body: some View {
        VStack {
            if isAuthenticated {
                List {
                    ForEach(fetchedItems, id: \.self) {
                        item in
                            NavigationLink(destination: {
                                DetailedView(title: item?.title ?? "empty", des: item?.descriptions ?? "empty")
                            }, label: {
                                Text(item?.title ?? "empty")
                                    .padding(.vertical)
                                    .lineLimit(1)
                            })
                    }.onDelete(perform: deleteNotes)
                }
                .onAppear(perform: {
                    fetchedItems = fetchUser(EOrN: userCorrespondingInfo.emailOrNum!, password: userCorrespondingInfo.password!)
                })
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            sheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $sheet, content: {
                    VStack(spacing: 15) {
                        TextField("write title..", text: $title)
                            .font(.title2)
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .background(.cyan)
                            .cornerRadius(25)
                            .padding()
                        if title.count > 100 {
                            Text("title shoud be less than 100 letters").font(.caption).foregroundStyle(.red)
                        }
                        TextField("write description..", text: $descriptions)
                            .font(.title2)
                            .frame(maxWidth: .infinity, maxHeight: 80)
                            .background(.cyan)
                            .cornerRadius(25)
                            .padding()
                        if descriptions.count > 1000 {
                            Text("description shoud be less than 1000 letters").font(.caption).foregroundStyle(.red)
                        }
                        if (title.count > 5 && title.count < 100) && (descriptions.count > 100 && descriptions.count < 1000) {
                            Button("Add") {
                                addItem(email: userCorrespondingInfo.emailOrNum!, password: userCorrespondingInfo.password!, title: title, descriptions: descriptions)
                                fetchedItems = fetchUser(EOrN: userCorrespondingInfo.emailOrNum!, password: userCorrespondingInfo.password!)
                                sheet.toggle()
                            }
                        }
                    }
                })
            }
            else {
                ZStack {
                    Image(systemName: "multiply")
                        .resizable()
                        .scaledToFit()
                        .fontWeight(.ultraLight)
                    VStack {
                        Text("Incorrect Email or Password")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: 150)
                            .background(.red)
                            .cornerRadius(20)
                    }
                }.navigationTitle("Notes")
            }
        }.toolbar {
            ToolbarItem(placement: .principal, content: {
                Text("Notes").font(.largeTitle)
            })
        }
    }
    func fetchUser(EOrN: String, password: String) -> [Notes?] {
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        // Creating a predicate to filter the fetch request
        let predicate = NSPredicate(format: "email == %@ AND password == %@", EOrN, password)
        fetchRequest.predicate = predicate
        do {
            let users = try viewContext.fetch(fetchRequest)
            return users
        } catch {
            print("Failed to fetch user: \(error)")
            return [nil]
        }
    }
    private func addItem(email: String, password: String, title: String, descriptions: String) {
        withAnimation {
            let addingInfo = Notes(context: viewContext)
            addingInfo.email = email
            addingInfo.password = password
            addingInfo.title = title
            addingInfo.descriptions = descriptions
            do {
                try viewContext.save()
            } catch {
                fatalError("Error while adding new data!")
            }
        }
    }
    private func deleteNotes(offsets: IndexSet) {
        
        withAnimation {
            offsets.map { fetched2[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                fatalError("Error while deleting an data!")
            }
        }
    }
}

