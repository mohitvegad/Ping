struct UserModel: Identifiable, Codable, Hashable {
    let id: String
    let userName: String
}

extension UserModel {

    func toPingCellModel() -> PingCellModel {
        PingCellModel(
            id: id,
            title: userName,
            subtitle: "Tap to start chat",
            imageName: "person.fill"
        )
    }
}
