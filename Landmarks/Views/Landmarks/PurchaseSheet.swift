import SwiftUI

struct PurchaseSheet: View {
    
    @Binding var showingSheet: Bool
    
    var park: Landmark
    @State var name: String = ""
    @State var creditCardNumber: String = ""
    @State var isAgreed = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(alignment: .center) {
                VStack {
                    Text("Purchase NFT")
                        .font(.largeTitle)
                        .bold()
                        .padding([.top], 30)
                    Text("Buy a unique NFT on this national park and get rich beyond believe!")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(20)
                    
                }
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NFT")
                                .font(.headline)
                            Text(park.name)
                                .font(.title2)
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Only")
                                .font(.headline)
                            
                            Text("$6900")
                                .font(.title2)
                        }
                    }
                    Divider()
                    Text("This NFT grants free entrance to this park and can only rise in value!")
                        .font(.footnote)
                    
                }
                .padding()
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 4)
                
                Spacer()
                
                Divider()
                
                
                Form {
                    TextField("Name", text: $name)
                    
                    Section(header:
                                Text("Payment Details")
                        .bold()
                        .padding(.top)
                    ) {
                        TextField("Credit Card Number", text: $creditCardNumber)
                        TextField("Expiry Date", text: $creditCardNumber)
                        TextField("Verification", text: $creditCardNumber)
                    }
                    
                    
                    Toggle(isOn: $isAgreed) {
                        Text("I agree to all terms")
                    }
                    .textFieldStyle(.squareBorder)
                    .padding(.top)
                }
                .padding(.top)
                
                Spacer()
                
                
                HStack {
                    Button {
                            showingSheet.toggle()
                    } label: {
                        Text("Later")
                    }
                    .keyboardShortcut(.cancelAction)
                    Spacer()
                    Button {
                            self.submitPaymentDetails()
                            showingSheet.toggle()
                    } label: {
                        Text("Buy Now")
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding()
            
            // Badge
            HStack(alignment: .top) {
                Spacer()
                ZStack {
                    
                    BadgeView(color: .purple)
                        .frame(width: 100, height: 100, alignment: .trailing)
                    Text("100%\nNo Scam")
                        .foregroundColor(.white)
                        .bold()
                        .multilineTextAlignment(.center)
                        .rotationEffect(.degrees(15))
                }
            }
            .padding(4)
        }
    }
    
    func submitPaymentDetails() {
        
        // TODO: Send credit card details to our server
        
    
        
    }
    
}

struct PurchaseSheet_Previews: PreviewProvider {
    static var previews: some View {
        let park = ModelData().landmarks.first!
        PurchaseSheet(showingSheet: .constant(true), park: park)
            .frame(width: 400, height: 600, alignment: .leading)
    }
}
