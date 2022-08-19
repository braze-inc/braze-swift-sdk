import BrazeKit
import Foundation

class AuthenticationManager {

  struct User {
    let id: String
    let email: String
    let birthday: Date
  }

  func userDidLogin(_ user: User) {
    AppDelegate.braze?.changeUser(userId: user.id)
    let brazeUser = AppDelegate.braze?.user
    brazeUser?.set(email: user.email)
    brazeUser?.set(dateOfBirth: user.birthday)
    brazeUser?.setCustomAttribute(key: "last_login_date", value: Date())
  }

}
