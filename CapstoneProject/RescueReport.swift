import SwiftUI
import PhotosUI
import CoreLocation

// MARK: - Model

struct RescueReport: Identifiable, Codable {
    let id: UUID
    var createdAt: Date
    var animalType: String
    var color: String
    var incidentDate: Date
    var status: AnimalStatus
    var nearestLandmark: String
    var description: String
    var latitude: Double?
    var longitude: Double?
    var media: [AttachedMedia] // images or videos (thumbnails stored here)

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        animalType: String = "",
        color: String = "",
        incidentDate: Date = Date(),
        status: AnimalStatus = .unknown,
        nearestLandmark: String = "",
        description: String = "",
        coordinate: CLLocationCoordinate2D? = nil,
        media: [AttachedMedia] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.animalType = animalType
        self.color = color
        self.incidentDate = incidentDate
        self.status = status
        self.nearestLandmark = nearestLandmark
        self.description = description
        self.latitude = coordinate?.latitude
        self.longitude = coordinate?.longitude
        self.media = media
    }
}

enum AnimalStatus: String, CaseIterable, Codable, Identifiable {
    case unknown = "Unknown"
    case safe = "Safe/Contained"
    case injured = "Injured"
    case aggressive = "Aggressive"
    case deceased = "Deceased"
    case other = "Other"

    var id: String { rawValue }
}

struct AttachedMedia: Identifiable, Codable, Hashable {
    let id: UUID
    let filename: String
    let isVideo: Bool
    // For demo/local use we store thumbnail as PNG data
    let thumbnailPNG: Data?

    init(id: UUID = UUID(), filename: String, isVideo: Bool, thumbnailPNG: Data?) {
        self.id = id
        self.filename = filename
        self.isVideo = isVideo
        self.thumbnailPNG = thumbnailPNG
    }
}

// MARK: - ViewModel

@MainActor
final class ReportFormViewModel: ObservableObject {
    @Published var report = RescueReport()
    @Published var selection: [PhotosPickerItem] = []
    @Published var attachedPreviews: [Image] = []

    // Simple validation for enabling Submit
    var canSubmit: Bool {
        !report.animalType.trimmingCharacters(in: .whitespaces).isEmpty &&
        report.status != .unknown
    }

    func setCoordinate(_ coord: CLLocationCoordinate2D?) {
        report.latitude = coord?.latitude
        report.longitude = coord?.longitude
    }

    func loadPickedMedia() async {
        attachedPreviews = []
        var collected: [AttachedMedia] = []

        for item in selection {
            do {
                let isVideo = (item.supportedContentTypes.first?.preferredMIMEType ?? "").starts(with: "video/")
                // Try to get transferable image for thumbnails
                if let data = try await item.loadTransferable(type: Data.self) {
                    var thumbnail: UIImage?
                    if isVideo {
                        // Try to create a thumbnail from video data (best-effort)
                        // In a simple demo we just leave thumbnail nil for videos loaded as raw data.
                        thumbnail = nil
                    } else if let ui = UIImage(data: data) {
                        thumbnail = ui
                    }

                    let previewImage: Image? = thumbnail.map { Image(uiImage: $0) }
                    if let img = previewImage { attachedPreviews.append(img) }

                    let filename = UUID().uuidString + (isVideo ? ".mov" : ".png")
                    let thumbData = thumbnail?.pngData()
                    collected.append(AttachedMedia(filename: filename, isVideo: isVideo, thumbnailPNG: thumbData))
                }
            } catch {
                // ignore that one item; keep others
            }
        }
        report.media = collected
    }
}

// MARK: - View

struct ReportFormView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ReportFormViewModel()

    /// Pass the coordinate from your Map hazard button when pushing this screen
    let coordinate: CLLocationCoordinate2D?

    /// Caller can receive the new report on submit
    var onSubmit: (RescueReport) -> Void

    init(
        coordinate: CLLocationCoordinate2D? = nil,
        onSubmit: @escaping (RescueReport) -> Void
    ) {
        self.coordinate = coordinate
        self.onSubmit = onSubmit
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    Text("Report what you see:")
                        .font(.custom("Helvetica-Bold", size: 27))
                        .padding(.top, 100)
                        .foregroundColor(Color("PrimaryText"))
                        .kerning(0.2)
                        .lineSpacing(30)
                        .padding(.top, -70)

                    Text("Try to give more information to help us better")
                        .font(.body)
                        .foregroundColor(Color("SecondaryText"))
                        .multilineTextAlignment(.center)

                    capsuleField(title: "Animal Type", placeholder: "e.g., Dog, Cat, Deer", text: $vm.report.animalType)
                        .padding(.top, 20)

                    capsuleField(title: "Color", placeholder: "e.g., Brown with white patch", text: $vm.report.color)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Incident").font(.headline)
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.gray.opacity(0.35), lineWidth: 1)
                            .frame(height: 56)
                            .overlay {
                                DatePicker("", selection: $vm.report.incidentDate, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Animal Status").font(.headline)
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.gray.opacity(0.35), lineWidth: 1)
                            .frame(height: 56)
                            .overlay {
                                Picker("Animal Status", selection: $vm.report.status) {
                                    ForEach(AnimalStatus.allCases) { s in
                                        Text(s.rawValue).tag(s)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                    }

                    capsuleField(title: "Nearest Landmark", placeholder: "e.g., Main St & 5th Ave", text: $vm.report.nearestLandmark)

                    // Description - multiline capsule
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description").font(.headline)
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.gray.opacity(0.35), lineWidth: 1)
                            .frame(minHeight: 140)
                            .overlay(alignment: .topLeading) {
                                TextEditor(text: $vm.report.description)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .overlay(alignment: .topLeading) {
                                        if vm.report.description.isEmpty {
                                            Text("Provide extra information if any.")
                                                .foregroundStyle(.secondary)
                                                .padding(.horizontal, 20)
                                                .padding(.top, 16)
                                        }
                                    }
                            }
                    }

                    // Add Picture/Video
                    VStack(spacing: 10) {
                        PhotosPicker(selection: $vm.selection, maxSelectionCount: 4, matching: .any(of: [.images, .videos])) {
                            ZStack {
                                Circle().strokeBorder(.gray.opacity(0.35), lineWidth: 3)
                                    .frame(width: 84, height: 84)
                                Image(systemName: "plus")
                                    .font(.system(size: 34, weight: .bold))
                            }
                        }
                        .onChange(of: vm.selection) { _ in
                            Task { await vm.loadPickedMedia() }
                        }

                        Text("Add Picture/Video").foregroundStyle(.secondary)
                        if !vm.attachedPreviews.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(Array(vm.attachedPreviews.enumerated()), id: \.offset) { _, img in
                                        img
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 90, height: 90)
                                            .clipped()
                                            .cornerRadius(12)
                                    }
                                }.padding(.vertical, 6)
                            }
                        }
                    }
                    .padding(.top, 6)

                    // Submit
                    Button {
                        var ready = vm.report
                        ready.createdAt = Date()
                        // ensure coordinate is captured from map if provided
                        if let c = coordinate {
                            ready.latitude = c.latitude
                            ready.longitude = c.longitude
                        }
                        onSubmit(ready)
                        dismiss()
                    } label: {
                        Text("Submit Report")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(vm.canSubmit ? .black : .gray.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    }
                    .disabled(!vm.canSubmit)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image("Arrow")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.primary)
                                .scaledToFit()
                                .frame(width: 30, height:30)
                                .font(.title)
                                
                            Text("Back")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .onAppear { vm.setCoordinate(coordinate) }
        }
    }

    // MARK: - Styled capsule textfield
    @ViewBuilder
    private func capsuleField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            RoundedRectangle(cornerRadius: 22)
                .stroke(.gray.opacity(0.35), lineWidth: 1)
                .frame(height: 56)
                .overlay {
                    TextField(placeholder, text: text)
                        .padding(.horizontal)
                }
        }
    }
}

// MARK: - Preview (remove in production)
#Preview {
    ReportFormView(coordinate: CLLocationCoordinate2D(latitude: 40.71, longitude: -74.0)) { _ in }
}
