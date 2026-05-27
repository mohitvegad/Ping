import SwiftUI

struct ToolbarIconButton: View {
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.white.opacity(0.12))
                .clipShape(Circle())
        }
    }
}
