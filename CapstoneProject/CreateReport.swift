import SwiftUI

enum ReportCategory: String, CaseIterable, Identifiable {
    case found = "Found Animal"
    case lost  = "Lost Animal"
    case injured = "Injured Animal"
    case wild = "Wild Animal"
    var id: String { rawValue }
}

struct ReportCategoryView: View {
    /// Callback when a category is chosen
    var onSelect: (ReportCategory) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 24) {
            // Back Button
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height:30)
                        .font(.title)
                        
                    Text("Back")
                        .font(.body)
                        .foregroundColor(.black)

                }
                Spacer()
            }
            .padding()
            
            Spacer(minLength: 40)

            VStack(spacing: 8) {
                
                Text("Create Report:")
                    .font(.custom("Helvetica-Bold", size: 27))
                    .padding(.top, 100)
                    .foregroundColor(Color("PrimaryText"))
                    .kerning(0.2)
                    .lineSpacing(30)
                    .padding(.top, 0)

                Text("Give more information to help better")
                    .font(.body)
                    .foregroundColor(Color("SecondaryText"))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 8) {
                categoryButton(.found)
                categoryButton(.lost)
                categoryButton(.injured)
                categoryButton(.wild)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, 150)
        .background(Color(.systemBackground))
        .padding()
        .edgesIgnoringSafeArea(.top)
    }

    @ViewBuilder
    private func categoryButton(_ category: ReportCategory) -> some View {
        Button {
            onSelect(category)
        } label: {
            Text(category.rawValue)
                .font(.custom("Helvetica-Bold", size: 18))
                .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(PillOutlineButtonStyle())
        .accessibilityIdentifier("category_\(category.rawValue)")
    }
}

/// A simple rounded “pill” outline style to match the mock
struct PillOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .foregroundColor(.gray)
            .font(.custom("Helvetica-Bold", size: 19))
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(.secondary.opacity(0.35), lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(configuration.isPressed ? Color.secondary.opacity(0.08) : .clear)
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct RReportCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { ReportCategoryView { _ in } }
    }
}



