Extension { #name : #YAMLParseNode }

{ #category : #'*GT4SmaCC-Inspector' }
YAMLParseNode >> asJsonString [
	^ String
		streamContents: [ :aStream | 
			| writer |
			writer := NeoJSONWriter on: aStream.
			writer prettyPrint: true.
			writer nextPut: self object ]
]

{ #category : #'*GT4SmaCC-Inspector' }
YAMLParseNode >> gtJSONFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		text: [ self asJsonString asRopedText ];
		styler: JSONParser gtStyler
]

{ #category : #'*GT4SmaCC-Inspector' }
YAMLParseNode >> gtObjectFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Object';
		items: [ {'self' -> self object} ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray or: [ each value isKindOf: OrderedCollection ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value;
		expandUpTo: 2
]
