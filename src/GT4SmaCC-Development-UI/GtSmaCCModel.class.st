Class {
	#name : 'GtSmaCCModel',
	#superclass : 'Object',
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : 'announcer' }
GtSmaCCModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'accessing' }
GtSmaCCModel >> grammar [
	self subclassResponsibility
]

{ #category : 'testing' }
GtSmaCCModel >> isDirective [
	^ false
]

{ #category : 'testing' }
GtSmaCCModel >> isProductionRule [
	^ false
]

{ #category : 'testing' }
GtSmaCCModel >> isTokenRule [
	^ false
]

{ #category : 'testing' }
GtSmaCCModel >> isValid [
	^ true
]

{ #category : 'accessing' }
GtSmaCCModel >> ruleNamed: aString [
	^ self grammar ruleNamed: aString
]
