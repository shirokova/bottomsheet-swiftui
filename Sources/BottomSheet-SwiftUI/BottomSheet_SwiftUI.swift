import SwiftUI

public struct BottomSheetConfig {
    let minHeight: CGFloat
    let maxHeight: CGFloat
    let radius: CGFloat
    let indicatorSize: CGSize
    let snapRatio: CGFloat
    let indicatorColor: Color
    let indicatorBackgroundColor: Color
    
    var offset: CGFloat {
        maxHeight - minHeight
    }
    
    public init(
        minHeightRatio: CGFloat = 0.2,
        maxHeight: CGFloat = 300,
        radius: CGFloat = 20,
        indicatorSize: CGSize = CGSize(width: 100, height: 5),
        snapRatio: CGFloat = 0.1,
        indicatorColor: Color = .black,
        indicatorBackgroundColor: Color = .white
    ) {
        self.minHeight = minHeightRatio * maxHeight
        self.maxHeight = maxHeight
        self.radius = radius
        self.indicatorSize = indicatorSize
        self.snapRatio = snapRatio
        self.indicatorColor = indicatorColor
        self.indicatorBackgroundColor = indicatorBackgroundColor
    }
}

public struct BottomSheet<Content: View>: View {
    @Binding var isOpen: Bool {
        didSet {
            self.sheetOffset = isOpen ? 0 : self.config.offset
        }
    }
    @State var sheetOffset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0

    let config: BottomSheetConfig
    let content: Content

    public init(isOpen: Binding<Bool>, config: BottomSheetConfig = BottomSheetConfig(), @ViewBuilder content: () -> Content) {
        self.config = config
        self.content = content()
        self._isOpen = isOpen
        self._sheetOffset = State(initialValue: isOpen.wrappedValue ? 0 : self.config.offset)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.config.maxHeight, alignment: .top)
            .background(self.config.indicatorBackgroundColor)
            .cornerRadius(self.config.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: self.sheetOffset)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onChanged { value in
                    let newOffset = (self.isOpen ? 0 : self.config.offset) + value.translation.height
                    self.sheetOffset = min(max(0, newOffset), self.config.offset)
                }.onEnded { value in
                    let snapDistance = self.config.maxHeight * self.config.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: self.config.radius)
            .fill(self.config.indicatorColor)
            .frame(
                width: self.config.indicatorSize.width,
                height: self.config.indicatorSize.height
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }
}
