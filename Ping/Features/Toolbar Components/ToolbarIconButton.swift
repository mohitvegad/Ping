import SwiftUI

struct ToolbarIconButton: View {
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .clipShape(Circle())
        }
    }
}
