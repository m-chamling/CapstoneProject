import SwiftUI

enum ReportCategory: String, CaseIterable, Identifiable, Hashable {
    case found = "Found Animal"
    case lost  = "Lost Animal"
    case injured = "Injured Animal"
    case wild = "Wild Animal"
    var id: String { rawValue }
}

struct ReportCategoryView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Back Button (optional)
            HStack {
                Button(action: {}) {
                    // Use an SF Symbol for now to avoid asset issues while testing
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                    Text("Back")
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                Spacer()
            }
            .padding()

            Spacer(minLength: 40)

            VStack(spacing: 8) {
                Text("Create Report:")
                    .font(.custom("Helvetica-Bold", size: 27))
                    // TEMP: use system color while debugging asset crashes
                    .foregroundStyle(.primary)
                    .kerning(0.2)
                    .lineSpacing(30)

                Text("Give more information to help better")
                    .font(.body)
                    .foregroundStyle(.secondary) // TEMP safe color
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 8) {
                ForEach(ReportCategory.allCases) { cat in
                    NavigationLink(value: cat) {
                        Text(cat.rawValue)
                            .font(.custom("Helvetica-Bold", size: 18))
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .buttonStyle(PillOutlineButtonStyle())
                    .accessibilityIdentifier("category_\(cat.id.replacingOccurrences(of: " ", with: "_"))")
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, 150)
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top)
        .padding()
    }
}

/// Same style as before (kept simple)
struct PillOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
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
