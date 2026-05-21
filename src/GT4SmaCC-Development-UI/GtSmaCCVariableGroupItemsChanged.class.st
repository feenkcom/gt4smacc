Class {
	#name : #GtSmaCCVariableGroupItemsChanged,
	#superclass : #Announcement,
	#instVars : [
		'groupResult'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtSmaCCVariableGroupItemsChanged >> groupResult [
	^ groupResult
]

{ #category : #accessing }
GtSmaCCVariableGroupItemsChanged >> groupResult: anObject [
	groupResult := anObject
]
