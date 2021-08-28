Class {
	#name : 'GtSmaCCGrammarItemChanged',
	#superclass : 'GtSmaCCGrammarAnnouncement',
	#instVars : [
		'item'
	],
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : 'instance creation' }
GtSmaCCGrammarItemChanged class >> forItem: aGrammarItem [
	^ self new
		item: aGrammarItem;
		yourself
]

{ #category : 'accessing' }
GtSmaCCGrammarItemChanged >> grammar [
	^ item grammar
]

{ #category : 'accessing' }
GtSmaCCGrammarItemChanged >> item [
	^ item
]

{ #category : 'accessing' }
GtSmaCCGrammarItemChanged >> item: aGrammarItem [
	item := aGrammarItem
]
