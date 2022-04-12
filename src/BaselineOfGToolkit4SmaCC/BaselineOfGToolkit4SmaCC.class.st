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
				spec repository: 'github://j-brant/SmaCC:78e971969657279e275ee4129c12c4cbd7a90f13/src' ].

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
