Class {
	#name : 'SpRadioGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'index',
		'whenIndexChangedDo',
		'whenColumnsChangedDo',
		'isEvenEvent',
		'display',
		'columnCount'
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

	columnCount = 2 ifTrue: [ ^ self ].
	columnCount := 2.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged

]

{ #category : 'as yet unclassified' }
SpRadioGroupPresenter >> beQuatroColumn [

	columnCount = 4 ifTrue: [ ^ self ].
	columnCount := 4.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged
]

{ #category : 'as yet unclassified' }
SpRadioGroupPresenter >> beSingleColumn [

	columnCount = 1 ifTrue: [ ^ self ].
	columnCount := 1.
	self layout: (self conditionalLayout: [ self singleColumnLayout ]).
	self columnsChanged

]

{ #category : 'as yet unclassified' }
SpRadioGroupPresenter >> beTripleColumn [

	columnCount = 3 ifTrue: [ ^ self ].
	columnCount := 3.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged
]

{ #category : 'private' }
SpRadioGroupPresenter >> buttonStateChanged [

	buttons withIndexDo: [ :btn :ind |
		btn state ifTrue: [ index := ind ] ].
	isEvenEvent ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].
	isEvenEvent := isEvenEvent not
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> columnCount [

	^ columnCount
]

{ #category : 'private' }
SpRadioGroupPresenter >> columnsChanged [

	whenColumnsChangedDo ifNotNil: [ whenColumnsChangedDo value: columnCount ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> conditionalLayout: aBlock [

	Transcript show: 'conditional layout'; cr.
	self title = String empty
		ifTrue: [ ^ aBlock value ]
		ifFalse: [
			^ SpBoxLayout newTopToBottom
				  add: title expand: false;
				  add: aBlock value;
				  yourself ]
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
	^ self conditionalLayout: [ self singleColumnLayout ]
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> display: aBlock [

	display := aBlock.
	self updateLabels
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
	items ifNil: [ items := self class defaultItems ].
	display := [ :object | object asStringOrText ].
	columnCount := 1.

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

{ #category : 'accessing - model' }
SpRadioGroupPresenter >> items: aCollection [

	| size |
	size := items size.
	items := aCollection asOrderedCollection.
	size = aCollection size
		ifTrue: [ self updateLabels ]
		ifFalse: [ self updateButtons; connectPresenters; updateCurrentLayout ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> multipleColumnLayout [

	| size hBoxLayout vBoxLayout high begin end |
	Transcript show: 'multiple layout ', columnCount printString; cr.
	hBoxLayout := SpBoxLayout newLeftToRight.
	size := buttons size.
	high := size + columnCount - 1 // columnCount.
	begin := 1 - high.
	end := 0.
	columnCount timesRepeat: [
		vBoxLayout := SpBoxLayout newTopToBottom.
		begin := begin + high.
		end := end + high.
		begin to: (end min: size) do: [ :i | vBoxLayout add: (buttons at: i) ].
		hBoxLayout add: vBoxLayout ].
	end - size timesRepeat: [ vBoxLayout add: SpLabelPresenter new ].
	^ hBoxLayout
]

{ #category : 'accessing - model' }
SpRadioGroupPresenter >> setModelBeforeInitialization: aCollection [
	Transcript show: 'set model before'; cr.
   items := aCollection asOrderedCollection

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
SpRadioGroupPresenter >> updateCurrentLayout [

columnCount = 1
	ifTrue: [ self layout: self defaultLayout ]
	ifFalse: [ self layout: (self conditionalLayout: [ self multipleColumnLayout ]) ]
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateLabels [

	buttons withIndexDo: [ :btn :ind |
		btn label: (display value: (items at: ind)) ]
]

{ #category : 'api - events' }
SpRadioGroupPresenter >> whenColumnsChangedDo: aBlock [

	whenColumnsChangedDo := aBlock
]

{ #category : 'api - events' }
SpRadioGroupPresenter >> whenIndexChangedDo: aBlock [

	whenIndexChangedDo := aBlock
]
