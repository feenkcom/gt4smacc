Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'SmaCC' with: [
				spec repository: 'github://j-brant/SmaCC:0907e56c471cdf82b025bfc994a9324b6218b508/src' ].
		spec 
			package: 'GT4SmaCC-Development-UI' with: [
				spec requires: #(#SmaCC ). ];
			package: 'GT4SmaCC-Stylers' with: [
				spec requires: #(#SmaCC ). ];
			package: 'GT4SmaCC-Examples' with: [
				spec requires: #(#SmaCC ). ];
			package: 'GT4SmaCC-Rewrite-Engine-UI' with: [
				spec requires: #(#SmaCC ). ]. ].

]
