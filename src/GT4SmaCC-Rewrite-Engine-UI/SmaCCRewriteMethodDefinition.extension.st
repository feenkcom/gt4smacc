Extension { #name : #SmaCCRewriteMethodDefinition }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteMethodDefinition >> asElement [
	^ GtSmaCCMethodDefinitionElement rewrite: self
]
