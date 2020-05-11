Class {
	#name : #GtSmaCCQueryExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> allNodes [
	<gtExample>
	| allNodes count |
	allNodes := self grammarAST // ''.
	count := 0.
	self grammarAST allNodesDo: [ :each | count := count + 1 ].
	self assert: allNodes size = count.
	^ allNodes
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> allNodesWithNameToken [
	<gtExample>
	| nameNodes |
	nameNodes := self allNodes @ #name <- ''.
	self assert: nameNodes notEmpty.
	^ nameNodes
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> grammarAST [
	<gtExample>
	^ SmaCCDefinitionParser definitionAST
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsAST [
	<gtExample>
	^ JSParser
		parse:
			'
function fib1(a) {
	if (a <= 1) return 1;
	return fib1(a - 1) + fib1(a - 2); 
}
function fib2(a) { 
  var a = 1, b = 0, temp;
  while (num >= 0){
    temp = a;
    a = a + b;
    b = temp;
    num--;
  }
  return b;
}
console.log(fib1(10) - fib2(10));
	'
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsCallExpressionNodes [
	<gtExample>
	| expressions |
	expressions := self jsAST // #JSCallExpressionNode.
	self assert: expressions size = 5.
	^ expressions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsCallsWith10AsArg [
	<gtExample>
	| calls |
	calls := self jsAST // 'literal' @ 'value' <- '10' \\ 'callexpression'.
	self assert: calls size = 2.
	^ calls
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsFunctions [
	<gtExample>
	| functions |
	functions := self jsAST // 'function'.
	self assert: functions size = 2.
	self assert: functions notEmpty.
	self assert: functions isEmpty not.
	self
		assert: (functions allSatisfy: [ :each | each isKindOf: JSFunctionNode ]).
	^ functions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsIfExpressions [
	<gtExample>
	| ifExpressions |
	ifExpressions := self jsAST // 'ifstatement' /@ 'expression'.
	self assert: ifExpressions size = 1.
	self assert: (ifExpressions anyOne isKindOf: JSBinaryExpressionNode).
	^ ifExpressions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsRecursiveFibCalls [
	<gtExample>
	| calls |
	calls := self jsAST // 'function' // 'callexpression'.
	self assert: calls size = 2.
	^ calls
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> rulesThatUseTerm [
	<gtExample>
	| rules |
	rules := self grammarAST // 'productionsymbol' @ 'name' <- #Term \\ 'productionrule'.
	self assert: rules size > 1.
	^ rules
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> rulesWithTerm [
	<gtExample>
	| rules |
	rules := self grammarAST // 'productionrule' @ 'name' <- 'Term'.
	self assert: rules size > 2.
	^ rules
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> termRule [
	<gtExample>
	| rules |
	rules := self grammarAST // 'productionrule' @ 'name' <- #Term.
	self assert: rules size = 1.
	^ rules
]
