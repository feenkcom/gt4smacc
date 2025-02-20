Extension { #name : #SmaCCRewriteResult }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteResult class >> leFromJsonV4Dictionary: aDictionary [
	^ self fromSocketString: (aDictionary at: #socketString)
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteResult class >> leJsonV4MappingFor: aNeoJSONMapper [
	aNeoJSONMapper
		for: self
		do: [ :mapping | 
			mapping
				mapProperty: #__type
				getter: [ :each | each class leJsonV4Name ]
				setter: [ :each | self error: 'Objects should not be read here' ].
			mapping
				mapProperty: #socketString
				getter: [ :each | each asSocketString ]
				setter: [ :each | self fromSocketString: each ] ]
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteResult class >> leJsonV4Name [
	^ #smaccRewriteResult
]
