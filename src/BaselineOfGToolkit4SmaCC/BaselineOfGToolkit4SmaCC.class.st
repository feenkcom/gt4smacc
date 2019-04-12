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
				spec repository: 'github://j-brant/SmaCC:96a781e0fbf99142704be4fb746e7baeee7cd6f8/src' ].
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
