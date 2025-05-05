Class {
	#name : #GtSmaCCQueryExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> allNodes [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
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
	<return: #GtSmaCCNodeQuery>
	| nameNodes |
	nameNodes := self allNodes @ #name <- ''.
	self assert: nameNodes notEmpty.
	^ nameNodes
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> andQuery [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| ast productions tokens empty all anded |
	ast := self grammarAST.
	productions := ast / SmaCCProductionRuleNode.
	tokens := ast / SmaCCTokenRuleNode.
	empty := productions & tokens.
	all := ast / ''.
	anded := all & productions.
	self assert: productions notEmpty.
	self assert: tokens notEmpty.
	self assert: empty isEmpty.
	self assert: anded size equals: productions size.
	^ anded
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> grammarAST [
	<gtExample>
	<return: #SmaCCGrammarDefinitionNode>
	^ SmaCCDefinitionParser definitionAST
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsAST [
	<gtExample>
	<return: #JSModuleNode>
	^ JSParser
		parse: '
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
	<return: #GtSmaCCNodeQuery>
	| expressions |
	expressions := self jsAST // #JSCallExpressionNode.
	self assert: expressions size = 5.
	^ expressions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsCallsWith10AsArg [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| calls |
	calls := ((self jsAST // 'literal') @ 'value' <- '10') \\ 'callexpression'.
	self assert: calls size = 2.
	^ calls
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsExpressionsFoundInASubnodeExpressionOfAnIfStatement [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| ifExpressions |
	ifExpressions := self jsAST // 'ifstatement' / 'expression'.
	self assert: ifExpressions size = 1.
	self assert: (ifExpressions anyOne isKindOf: JSBinaryExpressionNode).
	^ ifExpressions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsExpressionsFoundInTheVariableExpressionOfAnIfStatement [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| ifExpressions |
	ifExpressions := self jsAST // 'ifstatement' /@ 'expression'.
	self assert: ifExpressions size = 1.
	self assert: (ifExpressions anyOne isKindOf: JSBinaryExpressionNode).
	^ ifExpressions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsFunctions [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| functions |
	functions := self jsAST // 'function'.
	self assert: functions size = 2.
	self assert: functions notEmpty.
	self assert: functions isEmpty not.
	self assert: (functions allSatisfy: [ :each | each isKindOf: JSFunctionNode ]).
	^ functions
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsLiterals [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| calls |
	calls := self jsAST // 'literal'.
	self assert: calls size equals: 9.
	^ calls
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsLiteralsWithValue10 [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| calls |
	calls := (self jsAST // 'literal') @ 'value' <- '10'.
	self assert: calls size = 2.
	^ calls
]

{ #category : #'js examples' }
GtSmaCCQueryExamples >> jsRecursiveFibCalls [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| calls |
	calls := self jsAST // 'function' // 'callexpression'.
	self assert: calls size = 2.
	^ calls
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> orQuery [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| ast productions tokens both all |
	ast := self grammarAST.
	productions := ast / SmaCCProductionRuleNode.
	tokens := ast / SmaCCTokenRuleNode.
	both := productions | tokens.
	all := ast / ''.
	self assert: productions notEmpty.
	self assert: tokens notEmpty.
	self assert: both size equals: productions size + tokens size.
	self assert: (all | productions) size equals: all size.
	^ both
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> rulesThatUseTerm [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| rules |
	rules := ((self grammarAST // 'productionsymbol') @ 'name' <- #Term)
			\\ 'productionrule'.
	self assert: rules size > 1.
	^ rules
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> rulesWithTerm [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| rules |
	rules := (self grammarAST // 'productionrule') @ 'name' <- 'Term'.
	self assert: rules size > 2.
	^ rules
]

{ #category : #'grammar examples' }
GtSmaCCQueryExamples >> termRule [
	<gtExample>
	<return: #GtSmaCCNodeQuery>
	| rules |
	rules := (self grammarAST // 'productionrule') @ 'name' <- #Term.
	self assert: rules size = 1.
	^ rules
]
