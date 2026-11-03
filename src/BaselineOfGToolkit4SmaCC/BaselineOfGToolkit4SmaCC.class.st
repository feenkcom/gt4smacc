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
				spec repository: 'github://j-brant/SmaCC:6ee6d3ebe1ede1011ca51290d8f828b2b1ddee79/src' ].
		spec
			baseline: 'RemoteRunner' with: [
				spec repository: 'github://feenkcom/gtoolkit-remoterunner:v0.7.199/src' ].

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
