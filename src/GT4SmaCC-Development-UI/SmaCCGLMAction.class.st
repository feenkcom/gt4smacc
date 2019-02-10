Class {
	#name : #SmaCCGLMAction,
	#superclass : #GLMAction,
	#instVars : [
		'isButton',
		'isMenu'
	],
	#classVars : [
		'ShowPrecedenceConflicts'
	],
	#category : #'GT4SmaCC-Development-UI'
}

{ #category : #'initialize-release' }
SmaCCGLMAction >> initialize [
	super initialize.
	isButton := false.
	isMenu := true
]

{ #category : #accessing }
SmaCCGLMAction >> isButton [
	^ isButton
]

{ #category : #accessing }
SmaCCGLMAction >> isButton: anObject [
	isButton := anObject
]

{ #category : #accessing }
SmaCCGLMAction >> isMenu [
	^ isMenu
]

{ #category : #accessing }
SmaCCGLMAction >> isMenu: anObject [
	isMenu := anObject
]
