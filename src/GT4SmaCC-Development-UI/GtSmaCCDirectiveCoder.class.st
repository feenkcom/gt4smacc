Class {
	#name : #GtSmaCCDirectiveCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #private }
GtSmaCCDirectiveCoder >> collapsedText [
	| text |
	text := ('%' , self directiveName) asRopedText.
	GtSmaCCStyler
		formatDirective: text;
		formatDirectiveKeyword: text.
	^ text
]

{ #category : #private }
GtSmaCCDirectiveCoder >> directiveName [
	^ grammarItem directiveName
]

{ #category : #private }
GtSmaCCDirectiveCoder >> referencesFilterAtCursor [
	| ast interval |
	ast := self ast.
	interval := self selectedSourceInterval.
	interval isNil
		ifTrue: [ ^ nil ].
	ast isHierarchyDirective
		ifTrue: [ ast names
				do: [ :each | 
					(self isInterval: interval inside: each)
						ifTrue: [ ^ GtSmaCCNodeReferencesFilter name: each source ] ].
			(self isInterval: interval inside: ast superclass)
				ifTrue: [ ^ GtSmaCCNodeReferencesFilter name: ast superclass source ] ].
	ast isIgnoreDirective
		ifTrue: [ ast names
				do: [ :each | 
					(self isInterval: interval inside: each)
						ifTrue: [ ^ GtSmaCCVariableReferencesFilter name: '''' , each source , '''' ] ] ].
	ast isAssociativeDirective
		ifTrue: [ ast symbols
				do: [ :each | 
					(self isInterval: interval inside: each)
						ifTrue: [ ^ GtSmaCCDefinitionReferencesFilter name: each source ] ] ].
	ast isIdDirective
		ifTrue: [ ast names
				do: [ :each | 
					(self isInterval: interval inside: each)
						ifTrue: [ ^ GtSmaCCDefinitionReferencesFilter name: each source ] ] ].
	^ nil
]
