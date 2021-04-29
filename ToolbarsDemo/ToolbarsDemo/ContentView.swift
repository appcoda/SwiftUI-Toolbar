//
//  ContentView.swift
//  ToolbarsDemo
//
//  Created by Gabriel Theodoropoulos.
//

import SwiftUI

struct ContentView: View {
    @State private var imageData: [ImageModel] = [ImageModel(with: "image1"),
                                                  ImageModel(with: "image2"),
                                                  ImageModel(with: "image3")]
    
    @State private var current: Int = 0
    @State private var showSheet = false
    @State private var description = ""
    @State private var showActionSheet = false
    @State private var showDescription = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Image(uiImage: imageData[current].image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                if showDescription {
                    Text("\(imageData[current].description)")
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .navigationTitle("Photo Memories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showDescription.toggle()
                    }, label: {
                        Image(systemName: "doc.plaintext")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        current = current + 1 == 3 ? 0 : current + 1
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                    })
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        description = imageData[current].description
                        showSheet = true
                    }, label: {
                        Image(systemName: "pencil.circle")
                    })
                }
                
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        showActionSheet = true
                    }, label: {
                        Image(systemName: "camera.filters")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        guard let data = imageData[current].image.jpegData(compressionQuality: 0.9) else { return }
                        presentActivityController(with: data)
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                    })
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            NavigationView {
                TextField("Say something about the photo...", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .toolbar {
                        SheetToolbar {
                            imageData[current].description = description
                            showSheet = false
                        } cancelAction: {
                            showSheet = false
                        } destructAction: {
                            description = ""
                            imageData[current].description = description
                            showSheet = false
                        }
                    }
            }
        })
        .actionSheet(isPresented: $showActionSheet, content: {
            let sepia = ActionSheet.Button.default(Text("Sepia")) {
                imageData[current].filter = .sepia
            }
            let mono = ActionSheet.Button.default(Text("Mono")) {
                imageData[current].filter = .mono
            }
            let blur = ActionSheet.Button.default(Text("Blur")) {
                imageData[current].filter = .blur
            }
            let remove = ActionSheet.Button.destructive(Text("Remove filter")) {
                imageData[current].filter = .none
            }
            let cancel = ActionSheet.Button.cancel(Text("Cancel")) {
                showActionSheet = false
            }

            return ActionSheet(title: Text("Filters"), message: nil, buttons: [sepia, mono, blur, remove, cancel])
        })
    }
    
    
    func presentActivityController(with data: Data) {
        let controller = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: - SheetToolbar

struct SheetToolbar: ToolbarContent {
    var confirmAction: () -> Void
    var cancelAction: () -> Void
    var destructAction: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .destructiveAction) {
            Button(action: {
                destructAction()
            }, label: {
                Image(systemName: "trash.circle")
            })
        }

        ToolbarItem(placement: .confirmationAction) {
            Button(action: {
                confirmAction()
            }, label: {
                Image(systemName: "checkmark.circle")
            })
        }

        ToolbarItem(placement: .cancellationAction) {
            Button(action: {
                cancelAction()
            }, label: {
                Image(systemName: "xmark.circle")
            })
        }
    }
}
