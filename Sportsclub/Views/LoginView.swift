//
//  LoginView.swift
//  Sportsclub
//
//  Created by Sebastian Fox on 30.09.22.
//

import SwiftUI

enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @StateObject var viewModel = LoginViewModel()
  @EnvironmentObject var authenticationService: AuthenticationService
  @Environment(\.dismiss) var dismiss
  
  @FocusState private var focus: FocusableField?
    
    @Binding var showMenu: Bool
  
  private func signInWithEmailPassword() {
    Task {
      if await viewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }
    
    private func signUpWithEmailPassword() {
      Task {
        if await viewModel.signUpWithEmailPassword() == true {
          dismiss()
        }
      }
    }
  
  var body: some View {
    VStack {
//      Image("Login")
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .frame(minHeight: 0)
      Text("Login")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
      
      HStack {
        TextField("Email", text: $viewModel.email)
              .font(.system(size: 24))
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)
      
      HStack {
        SecureField("Password", text: $viewModel.password)
        .font(.system(size: 24))
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)
        
//        Spacer()
      
      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }
      
      Button(action: signInWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          Text("Login")
            .frame(maxWidth: .infinity)
        }
        else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
      .padding(.bottom)
      
      HStack {
        VStack { Divider() }
        Text("or")
        VStack { Divider() }
      }
      
      Button(action: { }) {
        Image(systemName: "applelogo")
          .frame(maxWidth: .infinity)
      }
      .foregroundColor(.black)
      .buttonStyle(.bordered)
      .controlSize(.large)
      
      HStack {
        Text("Don't have an account yet?")
        Button(action: {}) {
          Text("Sign up")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)
    }
    .onAppear {
      viewModel.connect(authenticationService: authenticationService)
    }
    .listStyle(.plain)
    .padding()
    .background(Color.white)
    .cornerRadius(25)
  }
}

//struct LoginView_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      LoginView()
//        .environmentObject(AuthenticationService())
//      LoginView()
//        .preferredColorScheme(.dark)
//        .environmentObject(AuthenticationService())
//    }
//  }
//}
