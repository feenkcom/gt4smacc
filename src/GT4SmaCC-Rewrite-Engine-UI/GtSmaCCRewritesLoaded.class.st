Class {
	#name : #GtSmaCCRewritesLoaded,
	#superclass : #Announcement,
	#instVars : [
		'rewrites'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #accessing }
GtSmaCCRewritesLoaded >> rewrites [
	^ rewrites
]

{ #category : #accessing }
GtSmaCCRewritesLoaded >> rewrites: anObject [
	rewrites := anObject
]
