Class {
	#name : #GtSmaCCSimulator,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'rule',
		'simulator'
	],
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCSimulator class >> on: aRule [
	^ self new
		rule: aRule;
		yourself
]

{ #category : #accessing }
GtSmaCCSimulator >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #private }
GtSmaCCSimulator >> buildSimulator [
	self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCSimulator >> grammar [
	^ rule grammar
]

{ #category : #accessing }
GtSmaCCSimulator >> rule [
	^ rule
]

{ #category : #'initialize-release' }
GtSmaCCSimulator >> rule: aRule [
	rule := aRule.
	self buildSimulator
]

{ #category : #accessing }
GtSmaCCSimulator >> ruleName [
	^ rule name
]

{ #category : #running }
GtSmaCCSimulator >> simulateOn: aString [
	self subclassResponsibility
]
