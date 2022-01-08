Extension { #name : #SmaCCRewritePropertyDefinition }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewritePropertyDefinition >> asElement [
	^ GtSmaCCPropertyDefinitionElement rewrite: self
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewritePropertyDefinition >> globalVariableNames [
	^ globalValues keys asSortedCollection
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewritePropertyDefinition >> localVariableNames [
	^ propertyNames asSortedCollection
]
