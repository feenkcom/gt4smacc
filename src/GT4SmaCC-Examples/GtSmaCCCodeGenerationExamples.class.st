Class {
	#name : #GtSmaCCCodeGenerationExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #'examples - evaluation' }
GtSmaCCCodeGenerationExamples >> arithmeticEvaluation [
	<gtExample>
	<after: #cleanUp>
	| grammar value |
	grammar := '
		<number> : \d+ (\. \d+)?;
		<whitespace> : \s+;
		%left "+" "-";
		%left "*" "/";
		Expression
			: Expression "+" Expression {''1'' + ''3''}
			| Expression ''left'' "-" Expression ''right'' {left - right}
			| Expression ''left'' "*" Expression ''right'' {left * right}
			| Expression ''left'' "/" Expression ''right'' {left / right}
			| "(" Expression ")" {''2''}
			| <number> {''1'' value asNumber}
			;
	'.
	self compileParser: grammar.
	value := self parserClass parse: '1 + 2 - 3 * 4 / 5'.
	self assert: value equals: 3 / 5.
	^ value
]

{ #category : #'examples - evaluation' }
GtSmaCCCodeGenerationExamples >> astGeneration [
	<gtExample>
	<after: #cleanUp>
	| grammar value |
	grammar := '
		%root Root;
		%prefix GtEx;
		%suffix Node;
		%hierarchy Expression (Number BinaryExpression);
		<number> : \d+ (\. \d+)?;
		<whitespace> : \s+;
		%left "+" "-";
		%left "*" "/";
		Script
			: Statement
			| Expression
			;
		Statement
			: Expression ''expression'' ";" ''semicolon'' {{}} 
			;
		Expression
			: Expression ''left'' "+" ''operator'' Expression ''right'' {{BinaryExpression}}
			| Expression ''left'' "-" ''operator'' Expression ''right'' {{BinaryExpression}}
			| Expression ''left'' "*" ''operator'' Expression ''right'' {{BinaryExpression}}
			| Expression ''left'' "/" ''operator'' Expression ''right'' {{BinaryExpression}}
			| "(" ''leftParen'' Expression ")" ''rightParen'' {{Expression}}
			| <number> ''value'' {{Number}}
			;
	'.
	self compileParser: grammar.
	self
		assert: #GtExBinaryExpressionNode asClass superclass name
		equals: #GtExExpressionNode.
	self assert: #GtExExpressionNode asClass superclass name equals: #GtExRootNode.
	self assert: #GtExStatementNode asClass superclass name equals: #GtExRootNode.
	self
		assert: #GtExExpressionNode asClass instVarNames asSortedCollection asArray
		equals: #('leftParens' 'rightParens').
	value := self parserClass parse: '((1 + 2)) - 3 * 4 / 5 ;'.
	self assert: value class name equals: #GtExStatementNode.
	self assert: value expression class name equals: #GtExBinaryExpressionNode.
	self assert: value expression operator value equals: '-'.
	self assert: value expression left leftParens size equals: 2.
	self assert: value expression right operator value equals: '/'.
	^ value
]

{ #category : #cleanup }
GtSmaCCCodeGenerationExamples >> cleanUp [
	RPackage organizer
		packageNamed: self packageName
		ifPresent: [ :package | package removeFromSystem ]
]

{ #category : #private }
GtSmaCCCodeGenerationExamples >> compileParser: aString [
	| compiler |
	compiler := SmaCCGrammarCompiler new.
	compiler codeGenerator defaultCategory: self packageName.
	compiler buildDefinition: aString.
	compiler compileInto: self scannerClassName andParser: self parserClassName
]

{ #category : #'examples - evaluation' }
GtSmaCCCodeGenerationExamples >> glrEvaluation [
	"Code in the {} blocks is evaluated only when we know this production will be used."

	<gtExample>
	<after: #cleanUp>
	| grammar value |
	grammar := '
		%glr;
		<number> : \d+ (\. \d+)?;
		<whitespace> : \s+;
		Expression
			: Left "|" "<" {''1''}
			| Right "|" ">" {''1''}
			;
		Left
			: Left "+" Number {''1'' + ''3''}
			| Left "-" Number {''1'' - ''3''}
			| Left "/" Number {''1'' / ''3''}
			| Number {''1''}
			;
		Right
			: Number "+" Right {''1'' + ''3''}
			| Number "-" Right {''1'' - ''3''}
			| Number "/" Right {''1'' / ''3''}
			| Number {''1''}
			;
		Number
			: <number> {''1'' value asNumber}
			;
	'.
	self compileParser: grammar.
	value := self parserClass parse: '1 / 2 - 2 | <'.
	self assert: value equals: -3 / 2.
	[ self parserClass parse: '1 / 2 - 2 | >'.
	self assert: false ] on: ZeroDivide do: [ :ex |  ].
	^ value
]

{ #category : #'examples - evaluation' }
GtSmaCCCodeGenerationExamples >> glrImmediateEvaluation [
	"Code in the [] blocks is evaluated immediately and may not be used in the final parse."

	<gtExample>
	<after: #cleanUp>
	| grammar value |
	grammar := '
		%glr;
		<number> : \d+ (\. \d+)?;
		<whitespace> : \s+;
		Expression
			: Left "|" "<" [''1'']
			| Right "|" ">" [''1'']
			;
		Left
			: Left "+" Number [''1'' + ''3'']
			| Left "-" Number [''1'' - ''3'']
			| Left "/" Number [''1'' / ''3'']
			| Number [''1'']
			;
		Right
			: Number "+" Right [''1'' + ''3'']
			| Number "-" Right [''1'' - ''3'']
			| Number "/" Right [''1'' / ''3'']
			| Number [''1'']
			;
		Number
			: <number> [''1'' value asNumber]
			;
	'.
	self compileParser: grammar.
	value := self parserClass parse: '1 / 2 - 3 | <'.
	self assert: value equals: -5 / 2.
	value := self parserClass parse: '1 / 2 - 3 | >'.
	self assert: value equals: -1.
	[ self parserClass parse: '1 / 2 - 2 | <'.	"Unlike the {} blocks, the [] block will throw an error here since the division is immediately evaluated before we know if we are parsing the expression as left or right associative"
	self assert: false ] on: ZeroDivide do: [ :ex |  ].
	[ self parserClass parse: '1 / 2 - 2 | >'.
	self assert: false ] on: ZeroDivide do: [ :ex |  ].
	^ grammar
]

{ #category : #private }
GtSmaCCCodeGenerationExamples >> packageName [
	^ 'AAA-SmaCC-AAA'
]

{ #category : #private }
GtSmaCCCodeGenerationExamples >> parserClass [
	^ self parserClassName asSymbol asClass
]

{ #category : #private }
GtSmaCCCodeGenerationExamples >> parserClassName [
	^ 'AAAExampleParser'
]

{ #category : #private }
GtSmaCCCodeGenerationExamples >> scannerClassName [
	^ 'AAAExampleScanner'
]
