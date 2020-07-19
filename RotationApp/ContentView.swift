//
//  ContentView.swift
//  RotationApp
//
//  Created by Prasanth Gogineni on 7/19/20.
//

import SwiftUI

struct ContentView: View {

	@EnvironmentObject var orientation:Orientation
	@State var isShowingSettingsView:Bool = false

	func AdjustedOrientation()->Bool{
		if self.isShowingSettingsView{
			return false
		}
		return orientation.isLandScape
	}

	var body: some View {
		if AdjustedOrientation() {
			LandscapeView()
		} else {
			MainView(isShowingSettingsView: $isShowingSettingsView)
		}
	}

	struct MainView: View {
		@Binding var isShowingSettingsView:Bool
		var body: some View {
			NavigationView {
				VStack {
					TopView(isShowingSettingsView: $isShowingSettingsView)
					DetailView()
				}
				.navigationBarTitle("Rotation Test")
			}
		}
	}

	struct TopView: View {
		@Binding var isShowingSettingsView:Bool
		var body: some View {
			VStack() {
				TabBarView(isShowingSettingsView: $isShowingSettingsView)
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
			Text("Detail").padding()
		}
	}

	struct TabBarView: View {
		@Binding var isShowingSettingsView:Bool

		var settingsButton:some View{
			Button(action: {
				isShowingSettingsView = true
			}) {
				Image(systemName: "slider.horizontal.3")
					.font(Font.system(.title))
			}.sheet(isPresented: $isShowingSettingsView)
			{
				SettingsView(isPresented: $isShowingSettingsView)
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
		@Binding var isPresented: Bool

		var doneButton: some View {
			Button("Done"){
				isPresented = false
				//presentationMode.wrappedValue.dismiss()
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
			}

		}
	}
}


