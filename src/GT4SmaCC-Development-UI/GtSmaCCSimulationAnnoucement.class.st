Class {
	#name : #GtSmaCCSimulationAnnoucement,
	#superclass : #Announcement,
	#instVars : [
		'input',
		'index'
	],
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCSimulationAnnoucement class >> input: aString index: anInteger [
	^ self new
		input: aString;
		index: anInteger;
		yourself
]

{ #category : #accessing }
GtSmaCCSimulationAnnoucement >> index [
	^ index
]

{ #category : #accessing }
GtSmaCCSimulationAnnoucement >> index: anInteger [
	index := anInteger
]

{ #category : #accessing }
GtSmaCCSimulationAnnoucement >> input [
	^ input
]

{ #category : #accessing }
GtSmaCCSimulationAnnoucement >> input: aString [
	input := aString
]
