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
				spec repository: 'github://j-brant/SmaCC:51c49e99ecb8adc39723b2e854d6e2e027b44d57/src' ].

		spec package: 'GT4SmaCC-Inspector' with: [
			spec requires: #('SmaCC') ].
		spec package: 'GT4SmaCC-Development-UI' with: [
			spec requires: #('SmaCC') ].
		spec package: 'GT4SmaCC-Debugger' with: [
			spec requires: #('GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Stylers' with: [
			spec requires: #('SmaCC') ].
		spec package: 'GT4SmaCC-Queries' with: [
			spec requires: #('SmaCC') ].
		spec package: 'GT4SmaCC-Examples' with: [
			spec requires: #('SmaCC') ].
		spec package: 'GT4SmaCC-Documentation' with: [
			spec requires: #('GT4SmaCC-Development-UI') ].
		spec package: 'GT4SmaCC-Rewrite-Engine-UI' with: [
			spec requires: #('SmaCC') ].
	]
]
