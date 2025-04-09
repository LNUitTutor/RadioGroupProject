Class {
	#name : 'SpRadioGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'index',
		'whenIndexChangedDo',
		'isEvenEvent',
		'display',
		'columnLayout'
	],
	#category : 'RadioGroupProject-Presenter',
	#package : 'RadioGroupProject',
	#tag : 'Presenter'
}

{ #category : 'specs' }
SpRadioGroupPresenter class >> defaultItems [ 
^ #('Button 1' 'Button 2' 'Button 3')
]

{ #category : 'specs' }
SpRadioGroupPresenter class >> title [ 
^ 'Group of radio buttons'
]

{ #category : 'as yet unclassified' }
SpRadioGroupPresenter >> beDoubleColumn [
columnLayout := #doubleColumnLayout.
self layout: self defaultLayout 
]

{ #category : 'as yet unclassified' }
SpRadioGroupPresenter >> beSingleColumn [
columnLayout := #singleColumnLayout.
self layout: self defaultLayout 
]

{ #category : 'private' }
SpRadioGroupPresenter >> buttonStateChanged [

	buttons withIndexDo: [ :btn :ind |
		btn state ifTrue: [ index := ind ] ].
	isEvenEvent ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].
	isEvenEvent := isEvenEvent not
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> connectPresenters [

| block |
Transcript show: 'connect presenters'; cr.
block := [ self buttonStateChanged ].
buttons do: [ :btn | btn whenChangedDo: block ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> defaultLayout [

	Transcript show: 'default layout'; cr.
	self title = String empty
		ifTrue: [ ^ self perform: columnLayout ]
		ifFalse: [
			^ SpBoxLayout newTopToBottom
				  add: title expand: false;
				  add: (self perform: columnLayout);
				  yourself ]
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> display: aBlock [

	display := aBlock.
	self updateLabels
]

{ #category : 'layout' }
SpRadioGroupPresenter >> doubleColumnLayout [

	| size hBoxLayout vBoxLayout hight |
	Transcript show: 'double layout'; cr.
	hBoxLayout := SpBoxLayout newLeftToRight.
	size := buttons size.
	hight := (size + 1) // 2.
	vBoxLayout := SpBoxLayout newTopToBottom.
	1 to: hight do: [ :i | vBoxLayout add: (buttons at: i) ].
	hBoxLayout add: vBoxLayout.
	vBoxLayout := SpBoxLayout newTopToBottom.
	hight + 1 to: size do: [ :i | vBoxLayout add: (buttons at: i) ].
	size odd ifTrue: [ vBoxLayout add: SpLabelPresenter new ].
	hBoxLayout add: vBoxLayout.
	^ hBoxLayout
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> indexSelected [

	^ index
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> initialize [

Transcript show: 'initialize'; cr.
	index := 1.
	isEvenEvent := false.
	items := self class defaultItems.
	display := [ :object | object asStringOrText ].
	columnLayout := #singleColumnLayout.

super initialize.
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> initializePresenters [

	Transcript show: 'initalize presenters'; cr.
	title := self newLabel.
	title label: self class title.
	self updateButtons
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> itemSelected [

	^ items at: index
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> items: anOrderedCollection [

	| size |
	size := items size.
	items := anOrderedCollection.
	size = anOrderedCollection size
		ifTrue: [ self updateLabels ]
		ifFalse: [ self updateButtons; connectPresenters.
			self layout: self defaultLayout ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> singleColumnLayout [

	| boxLayout |
	Transcript show: 'single layout'; cr.
	boxLayout := SpBoxLayout newTopToBottom.
	buttons do: [ :btn | boxLayout add: btn ].
	^ boxLayout
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> title [

	^ title label
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> title: aString [

	title label: aString.
	self layout: self defaultLayout 
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateButtons [

	| firstButton |
	firstButton := SpRadioButtonPresenter new label:
		               (display value: items first).
	buttons := OrderedCollection with: firstButton.
	items allButFirstDo: [ :object |
		buttons add: (SpRadioButtonPresenter new label: (display value: object)) ].
	firstButton associatedRadioButtons: buttons allButFirst
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateLabels [

	buttons withIndexDo: [ :btn :ind |
		btn label: (display value: (items at: ind)) ]
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> whenIndexChangedDo: aBlock [

	whenIndexChangedDo := aBlock
]
