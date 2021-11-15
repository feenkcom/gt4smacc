Class {
	#name : #GtSmaCCSearchTypedGroupResult,
	#superclass : #GtSmaCCSearchGroupResult,
	#instVars : [
		'announcer'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'as yet unclassified' }
GtSmaCCSearchTypedGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithTypedGroup: self.
]

{ #category : #'as yet unclassified' }
GtSmaCCSearchTypedGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ aGroupType = self 
		ifTrue: [ self ]
		ifFalse: [ GtSmaCCSearchGroupResult ]
]

{ #category : #accessing }
GtSmaCCSearchTypedGroupResult >> announcer [
	^ announcer
]

{ #category : #initialization }
GtSmaCCSearchTypedGroupResult >> initialize [
	super initialize.
	announcer := Announcer new.
	self subscribe
]

{ #category : #subscription }
GtSmaCCSearchTypedGroupResult >> subscribe [
]
