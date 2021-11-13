Class {
	#name : #GtSmaCCParserSimulationAccept,
	#superclass : #GtSmaCCSimulationAnnoucement,
	#instVars : [
		'results'
	],
	#category : 'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCParserSimulationAccept class >> input: aString results: aCollection [
	^ (self input: aString index: aString size)
		results: aCollection;
		yourself
]

{ #category : #accessing }
GtSmaCCParserSimulationAccept >> results [
	^ results
]

{ #category : #accessing }
GtSmaCCParserSimulationAccept >> results: aCollection [
	results := aCollection
]
