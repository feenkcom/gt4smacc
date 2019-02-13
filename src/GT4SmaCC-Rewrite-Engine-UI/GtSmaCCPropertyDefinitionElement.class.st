Class {
	#name : #GtSmaCCPropertyDefinitionElement,
	#superclass : #BrAccordion,
	#instVars : [
		'propertyDefinition'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCPropertyDefinitionElement class >> propertyDefinition: aSmaCCRewritePropertyDefinition [
	^ self new
		propertyDefinition: aSmaCCRewritePropertyDefinition;
		yourself
]

{ #category : #accessing }
GtSmaCCPropertyDefinitionElement >> propertyDefinition [
	^ propertyDefinition
]

{ #category : #accessing }
GtSmaCCPropertyDefinitionElement >> propertyDefinition: aSmaCCRewritePropertyDefinition [
	propertyDefinition := aSmaCCRewritePropertyDefinition
]
