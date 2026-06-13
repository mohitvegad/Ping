import Foundation

protocol ChatUserStateServiceProtocol {
    
    func createInitialChatState(currentUser: UserModel, otherUser: UserModel)
    
    func fetchChatUserStates(currentUser: UserModel, completion: @escaping ([ChatUserState]) -> Void)
        
    func markChatAsRead(currentUser: UserModel, otherUser: UserModel)
    
    func incrementUnread(currentUser: UserModel, otherUser: UserModel) 
}
