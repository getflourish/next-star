import SwiftUI

struct NotificationView: View {
    @Binding var content: String
    @Binding var isError: Bool
    
    var body: some View {
        HStack {
            Text(content)
                .padding(10)
                .foregroundColor(Color.white)
                
            Spacer()
        }.background(isError ? Color.red : Color.green)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(content: .constant("Dummy notification"), isError: .constant(false))
    }
}
