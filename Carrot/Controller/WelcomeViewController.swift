//
//  WelcomeViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 17/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import CryptoKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseFirestore
import AuthenticationServices

class WelcomeViewController: UIViewController {
    
    var currentNonce: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setUpView() {
        let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(appleButton)
        
        let margins = login.layoutMarginsGuide
        let margins2 = registerEmail.layoutMarginsGuide
        // let appleMargins = appleButton.layoutMarginsGuide
//        appleButton.leadingAnchor.constraint(equalTo: appleMargins.leadingAnchor, constant: 60).isActive = true
//        appleButton.trailingAnchor.constraint(equalTo: appleMargins.trailingAnchor, constant: 60).isActive = true
        
        // login.topAnchor.constraint(equalTo: appleMargins.bottomAnchor, constant: 0)
        appleButton.bottomAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        appleButton.topAnchor.constraint(equalTo: margins2.bottomAnchor, constant: 20).isActive = true
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        appleButton.widthAnchor.constraint(equalToConstant: 255).isActive = true
        appleButton.cornerRadius = 10
        
        
//        NSLayoutConstraint.activate([
//
//            appleButton.topAnchor.constraint(equalTo: registerEmail.bottomAnchor.he + 20)
//        ])
    }
    
    @IBOutlet weak var registerEmail: UIButton!
    @IBOutlet weak var login: UIButton!
    
    // @IBOutlet weak var appleButton: ASAuthorizationAppleIDButton!
    
    @objc func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == K.Segues.welcomeToTable {
        let objVC = segue.destination as? TableViewController
        objVC?.navigationItem.hidesBackButton = true
      }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

}

extension WelcomeViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            // Save authorised user ID for future reference
            UserDefaults.standard.set(credentials.user, forKey: "appleAuthorizedUserIdKey")
            
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // Retrieve Apple identity token
            guard let appleIDToken = credentials.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }

            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                if let authData = authResult {
                        // Save profile picture
                    let dict: Dictionary<String, Any> = [
                            K.User.firstName: user.firstName,
                            K.User.email: authData.user.email!,
                            K.User.dateCreated: Date(),
                            K.User.profilePicture: "",
                            K.User.lists: []
                        ]

                        UserDefaults.standard.set(dict[K.User.firstName], forKey: "firstName")
                        UserDefaults.standard.set(dict[K.User.email], forKey: "email")
                        UserDefaults.standard.synchronize()
                        
                        let userRef = Firestore.firestore().collection(K.FStore.users).document(authData.user.uid)
                        
                        Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                            AnalyticsParameterMethod: self?.method
                        ])
                        
                        userRef.setData(dict)
                    }
                    
                    // Redirect user to groceries
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                    UserDefaults.standard.synchronize()
                    
                    self?.performSegue(withIdentifier: K.Segues.welcomeToAddList, sender: self)
                }
            
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    
}

extension WelcomeViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(id)
        First name: \(firstName)
        Last name: \(lastName)
        Email: \(email)
        """
    }
}
