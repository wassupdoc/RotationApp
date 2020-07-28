//
//  ContentView.swift
//  RotationApp
//
//  Created by Prasanth Gogineni on 7/19/20.
//

import SwiftUI
import Combine

class Orientation: ObservableObject {
	//input
	@Published var isLandScape:Bool = false
	@Published var isModalOpen:Bool = false

	//output
	@Published var filteredLandscape:Bool = false

	private var cancellableSet: Set<AnyCancellable> = []

	private var filteredOrientation: AnyPublisher<Bool, Never> {
		$isLandScape//.CombineLatest($isLandScape, $isModalOpen)
			.filter { _ in !self.isModalOpen }
			.removeDuplicates()
			.eraseToAnyPublisher()
	}

	init() {
		filteredOrientation
			.receive(on: RunLoop.main)
			.assign(to: \.filteredLandscape, on: self)
			.store(in: &cancellableSet)
	}
}


struct ContentView: View {

	@EnvironmentObject var orientation:Orientation
//	@State var isShowingSettingsView:Bool = false

//	func AdjustedOrientation()->Bool{
//		if self.isShowingSettingsView{
//			return false
//		}
//		return orientation.filteredLandscape
//	}

	var body: some View {
		if orientation.filteredLandscape { //} AdjustedOrientation() {
			LandscapeView()
		} else {
			MainView()//isShowingSettingsView: $isShowingSettingsView)
		}
	}

	struct MainView: View {
//		@Binding var isShowingSettingsView:Bool
		var body: some View {
			NavigationView {
				VStack {
					EmptyView()
					DetailView()
					TopView()//isShowingSettingsView: $isShowingSettingsView)

				}
				.navigationBarTitle("Rotation Test")
			}
		}
	}

	struct TopView: View {
//		@Binding var isShowingSettingsView:Bool
		var body: some View {
			VStack() {
				TabBarView()//isShowingSettingsView: $isShowingSettingsView)
			}
		}
	}

	struct LandscapeView: View {
		var body: some View {
			Text("Landscape").padding()
		}
	}

	struct DetailView: View {
		var body: some View {
			VStack{
				List {
					Section() {
						Text("List 1")
						Text("List 2")
					}
				}
				.listStyle(GroupedListStyle())
				.navigationBarTitle(Text("Details"))
				.font(.headline)
				.environment(\.horizontalSizeClass, .regular)
			}
			.onAppear(){
				UITableView.appearance().bounces = false
			}
		}
	}

	struct TabBarView: View {
		@EnvironmentObject var orientation:Orientation
//		@Binding var isShowingSettingsView:Bool

		var settingsButton:some View{
			Button(action: {
				orientation.isModalOpen = true //isShowingSettingsView = true
			}) {
				Image(systemName: "slider.horizontal.3")
					.font(Font.system(.title))
			}.sheet(isPresented: $orientation.isModalOpen)// $isShowingSettingsView)
			{
				SettingsView()//isPresented: orientation.$isShowingSettingsView)
					.environmentObject(orientation)
			}
		}

		var body: some View{
			//	private var TabBarView: some View {
			HStack{
				Spacer()
				settingsButton
				Spacer()
			}
		}
	}

	struct SettingsView: View {
//		@Binding var isPresented: Bool
		@EnvironmentObject var orientation:Orientation
		//@Environment(\.presentationMode) var presentationMode

		var doneButton: some View {
			Button("Done"){
				orientation.isModalOpen = false// isPresented = false
				//presentationMode.wrappedValue.dismiss()
			}
		}

		struct NavBarOrientationModifier: ViewModifier {
			@Binding var isPresented:Bool
			@EnvironmentObject var orientation:Orientation

			func body(content: Content) -> some View {
				if orientation.filteredLandscape {
					return content
						.navigationBarHidden(true)
				} else {
					return content
						.navigationBarHidden(false)

				}
			}
		}

		var body: some View {
			NavigationView {
				List{
					Text("Settings 1")
					Text("Settings 2")
				}
				.navigationBarTitle(Text("Settings"))//, displayMode: .inline)
				.navigationBarItems(trailing: doneButton)
				.modifier(NavBarOrientationModifier(isPresented: $orientation.isModalOpen))// $isPresented))
			}

		}
	}
}


