//
//  loginView.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 20/05/24.
//

import SwiftUI
import CoreData

struct LoginPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var emailOrNumber = ""
    @State var password = ""
    @State var showPassword = false
    @State var showAlert = false
    @State var isAuthenticated = false
    @State var errorMessage = ""
    @State var userCorrespondingInfo: UserInfo = UserInfo()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.emailOrNum, ascending: true)],
        animation: .default)
    private var fetched: FetchedResults<UserInfo>
    var body: some View {
        VStack(spacing: 20) {
            TextField("Phone Number \\ Email", text: $emailOrNumber)
                .modifier(FieldStyle())
            if showPassword {
                TextField("password", text: $password).modifier(FieldStyle())
                    .overlay {
                        HStack {
                            Spacer().frame(width: 300)
                            Button(action: {showPassword.toggle()}) {
                                Image(systemName: showPassword ? "eye": "eye.slash")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
            } else {
                SecureField("password", text: $password).modifier(FieldStyle())
                    .overlay {
                        HStack {
                            Spacer().frame(width: 300)
                            Button(action: {showPassword.toggle()}) {
                                Image(systemName: showPassword ? "car": "eye.slash")
                                    .font(.title2)
                                    .foregroundStyle(.black)
                            }
                        }
                    }
            }
            NavigationLink(destination: LoggedInPage(isAuthenticated: $isAuthenticated, userCorrespondingInfo: $userCorrespondingInfo)) {
                Text("login")
                    .frame(width: 55, height: 35)
                    .foregroundStyle(.white)
                    .background(.blue.opacity(emailOrNumber.isEmpty || password.isEmpty ? 0.5 : 1))
                    .cornerRadius(30)
            }
            .simultaneousGesture(TapGesture().onEnded( { _ in
                if let auth = fetchUser(EOrN: emailOrNumber, password: password) {
                    userCorrespondingInfo = auth
                    isAuthenticated = true
                } else {
                    isAuthenticated = false
                }
                
            }))
            .disabled(emailOrNumber.isEmpty || password.isEmpty)
            .onDisappear(perform: {
                emailOrNumber = ""
                password = ""
            })
            NavigationLink(destination: NewAccountView()) {
                Text("don't have an account ?").foregroundStyle(.black)
                    .fontWeight(.heavy) + Text("  Sign-up").foregroundStyle(.blue)
            }
        }
    }
    func fetchUser(EOrN: String, password: String) -> UserInfo? {
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        
        // Creating a predicate to filter the fetch request
        let predicate = NSPredicate(format: "emailOrNum == %@ AND password == %@", EOrN, password)
        fetchRequest.predicate = predicate
        do {
            let users = try viewContext.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }
    func authenticate(EOrN: String, password: String) -> Bool {
        if fetchUser(EOrN: EOrN, password: password) != nil {
            print("Authenticated")
            return true
        } else {
            print("Not Authenticated")
            return false
        }
    }
}
    
    

struct FieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .frame(width: 350, height: 45)
            .foregroundStyle(.white.opacity(0.7))
            .padding()
            .background(Color.gray.opacity(0.6))
            .cornerRadius(35)
            .overlay {
                Capsule().stroke(lineWidth: 2)
            }
    }
}

#Preview {
    LoginPage()
}
