Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'SmaCC' with: [
				spec repository: 'github://j-brant/SmaCC:8c1dd09d00f6cbdd0bc37e3722291056c851fabf/src' ].
		spec
			baseline: 'RemoteRunner' with: [
				spec repository: 'github://feenkcom/gtoolkit-remoterunner:v0.7.206/src' ].

		spec package: 'GT4SmaCC-Inspector' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Stylers' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Development-UI' with: [
			spec requires: #(#SmaCC #'GT4SmaCC-Stylers') ].
		spec package: 'GT4SmaCC-Debugger' with: [
			spec requires: #(#'GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Queries' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Examples' with: [
			spec requires: #(#SmaCC) ].
		spec package: 'GT4SmaCC-Documentation' with: [
			spec requires: #(#'GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Rewrite-Engine-UI' with: [
			spec requires: #(#SmaCC #RemoteRunner) ].
		spec package: 'GT4SmaCC-Completer' with: [
			spec requires: #(#SmaCC) ].
	]
]
