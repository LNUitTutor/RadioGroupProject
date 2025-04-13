"
I am a presener for reuse. I hold a title and a group of radio buttons. I can help to create and to manage a group of <SpRadioButtonPresenter>s.

###Instance Variables
   title:   `a SpLabelPresenter` holds the caption of the group
	items:   `an OrderedCollection` of objects that are displayed as radio buttons
	buttons: `an OrderedCollection` of radio buttons
	display: `a BlockClosure` an unary block defines the way to display the items
	columnCount: `an Integer` between 1 and 4 - the number of columns that the buttons are divided into
	index:   `an Integer` between 1 and buttons size - the indes of the selected button
	whenIndexChangedDo:   `a BlockClosure` an unary block - the event handler
	whenColumnsChangedDo: `a BlockClosure` an unary block - the event handler
	isEvenEvent: `a Boolean` helper variable

###Public API

- `beSingleColumn`, `beDoubleColumn`, `beTripleColumn`, `beQuatroColumn` changes the count of columns of the buttons. The single column is set by default.
- `display: anUnaryBloc` sets a block to define the way to display the items
- `title: aString` sets the caption of the group of the buttons
- `whenColumnsChangedDo: anUnaryBloc` sets the event handler. The `columnsCount` will pass to the block
- `whenIndexChangedDo: anUnaryBloc` sets the event handler. The `index` will pass to the block
- `items: aCollection` changes the collection of objects that are displayed as radio buttons
- `addItem: anObject` adds the item to the collection of objects that are displayed as radio buttons
- `itemSelected` returns the object that corresponds to the selected button
- `columnCount`, `indexSelected`, `title` are simple getters

To create an instance use `SpRadioGroupPresenter class >> on: aCollection` or `SpPresenter >> instantiate: SpRadioGroupPresenter on: aCollection`. For example
```language=Pharo
 | group |
 group := (SpRadioGroupPresenter on: 'ABCDEFGH') title: 'Choose a letter'; beDoubleColumn.
 group open
```
By using `SpRadioGroupPresenter new` you will get `SpRadioGroupPresenter on: #( 'Button 1' 'Button 2' 'Button 3' )`
"
Class {
	#name : 'SpRadioGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'title',
		'items',
		'buttons',
		'display',
		'columnCount',
		'index',
		'whenIndexChangedDo',
		'whenColumnsChangedDo',
		'whenItemsChangedDo',
		'isEvenEvent'
	],
	#category : 'RadioGroupProject-Presenter',
	#package : 'RadioGroupProject',
	#tag : 'Presenter'
}

{ #category : 'specs' }
SpRadioGroupPresenter class >> defaultItems [

	^ #( 'Button 1' 'Button 2' 'Button 3' )
]

{ #category : 'specs' }
SpRadioGroupPresenter class >> title [

	^ 'Group of radio buttons'
]

{ #category : 'accessing - model' }
SpRadioGroupPresenter >> addItem: anObject [
	"Add the item to the collection of objects that are displayed as radio buttons"

	items add: anObject.
	self updateButtons.
	(buttons at: index) state: true.
	self
		connectPresenters;
		updateCurrentLayout;
		itemsChanged
]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> beDoubleColumn [
	"Place the buttons to two vertical columns.
	 Can trigger whenColumnsChangedDo event"

	columnCount = 2 ifTrue: [ ^ self ].
	columnCount := 2.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged

]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> beQuatroColumn [
	"Place the buttons to four vertical columns.
	 Can trigger whenColumnsChangedDo event"

	columnCount = 4 ifTrue: [ ^ self ].
	columnCount := 4.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged
]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> beSingleColumn [
	"Place the buttons to a vertical column.
	 Can trigger whenColumnsChangedDo event"

	columnCount = 1 ifTrue: [ ^ self ].
	columnCount := 1.
	self layout: (self conditionalLayout: [ self singleColumnLayout ]).
	self columnsChanged

]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> beTripleColumn [
	"Place the buttons to three vertical columns.
	 Can trigger whenColumnsChangedDo event"

	columnCount = 3 ifTrue: [ ^ self ].
	columnCount := 3.
	self layout: (self conditionalLayout: [ self multipleColumnLayout ]).
	self columnsChanged
]

{ #category : 'private' }
SpRadioGroupPresenter >> buttonStateChanged [
	"Find the index of the selected button.
	 Can trigger the whenIndexChangedDo event"

	buttons withIndexDo: [ :btn :ind |
		btn state ifTrue: [ index := ind ] ].
	isEvenEvent ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].
	isEvenEvent := isEvenEvent not
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> columnCount [
	"Get the number of columns that the buttons are divided into"

	^ columnCount
]

{ #category : 'private' }
SpRadioGroupPresenter >> columnsChanged [
	"Trigger the whenColumnsChangedDo event"

	whenColumnsChangedDo ifNotNil: [ whenColumnsChangedDo value: columnCount ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> conditionalLayout: aBlock [
	"Add a SpLabelPresenter for the nonempty title above the buttons"

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
	block := [ self buttonStateChanged ].
	buttons do: [ :btn | btn whenChangedDo: block ]
]

{ #category : 'private' }
SpRadioGroupPresenter >> correctIndexToFirst [

	index := 1.
	whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> defaultLayout [

   ^ SpBoxLayout newTopToBottom
        add: title expand: false;
        add: self singleColumnLayout;
        yourself

]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> display: aBlock [
	"set a block to define the way to display the items"

	display := aBlock.
	self updateLabels
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> indexSelected [
	"Get the index of the selected button"

	^ index
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> initialize [

	index := 1.
	isEvenEvent := false.
	items ifNil: [ items := self class defaultItems ].
	display := [ :object | object asStringOrText ].
	columnCount := 1.

	super initialize
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> initializePresenters [

	title := self newLabel.
	title label: self class title.
	self updateButtons
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> itemSelected [
	"Get the object of the selected button"

	^ items at: index
]

{ #category : 'accessing - model' }
SpRadioGroupPresenter >> items: aCollection [
	"Change the collection of objects that are displayed as radio buttons"

	| size |
	size := items size.
	items := aCollection asOrderedCollection.
	size = aCollection size
		ifTrue: [ self updateLabels ]
		ifFalse: [ self updateButtons; connectPresenters; updateCurrentLayout; correctIndexToFirst ].
	self itemsChanged
]

{ #category : 'private' }
SpRadioGroupPresenter >> itemsChanged [
	"Trigger the whenItemsChangedDo event"

	whenItemsChangedDo ifNotNil: [ whenItemsChangedDo value ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> multipleColumnLayout [
	"Put proportional parts of the buttons into columnCount vertical SpBoxLayouts.
	 Filled up the last one with empty SpLabelPresenter if needed"

	| size hBoxLayout vBoxLayout high begin end |
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
SpRadioGroupPresenter >> removeItem: anObject [
	"Remove the item from the collection of objects that are displayed as radio buttons"

	| keepIndex |
	keepIndex := anObject ~= self itemSelected.
	items remove: anObject.
	self updateButtons.
	keepIndex
		ifTrue: [
			(buttons at: index) state: true.
			self
				connectPresenters;
				updateCurrentLayout ]
		ifFalse: [
			self
				connectPresenters;
				updateCurrentLayout;
				correctIndexToFirst ].
	self itemsChanged
]

{ #category : 'accessing - model' }
SpRadioGroupPresenter >> setModelBeforeInitialization: aCollection [
	"Set the collection of objects that will be displayed as radio buttons"
	
   items := aCollection asOrderedCollection

]

{ #category : 'layout' }
SpRadioGroupPresenter >> singleColumnLayout [
	"Put each button to the vertical SpBoxLayout"

	| boxLayout |
	boxLayout := SpBoxLayout newTopToBottom.
	buttons do: [ :btn | boxLayout add: btn ].
	^ boxLayout
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> title [
	"Get the title of the button's group"

	^ title label
]

{ #category : 'api - customization' }
SpRadioGroupPresenter >> title: aString [
	"set the caption of the group of the buttons"

	title label: aString.
	self updateCurrentLayout 
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateButtons [
	"Build the collection of radio buttons accordingly to the items collection"

	| firstButton |
	firstButton := self newRadioButton.
	buttons := OrderedCollection with: firstButton.
	items allButFirstDo: [ :object | buttons add: self newRadioButton ].
	firstButton associatedRadioButtons: buttons allButFirst.
	self updateLabels
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateCurrentLayout [
	"Helper method to refresh the layout"

columnCount = 1
	ifTrue: [ self layout: (self conditionalLayout: [ self singleColumnLayout ]) ]
	ifFalse: [ self layout: (self conditionalLayout: [ self multipleColumnLayout ]) ]
]

{ #category : 'private' }
SpRadioGroupPresenter >> updateLabels [
	"Helper method to refresh labels of the buttons"

	buttons withIndexDo: [ :btn :ind |
		btn label: (display value: (items at: ind)) ]
]

{ #category : 'api - events' }
SpRadioGroupPresenter >> whenColumnsChangedDo: aBlock [
	"Set the whenColumnsChangedDo event handler"

	whenColumnsChangedDo := aBlock
]

{ #category : 'api - events' }
SpRadioGroupPresenter >> whenIndexChangedDo: aBlock [
	"Set the whenIndexChangedDo event handler"

	whenIndexChangedDo := aBlock
]

{ #category : 'api - events' }
SpRadioGroupPresenter >> whenItemsChangedDo: aBlock [
	"Set the whenItemsChangedDo event handler"

	whenItemsChangedDo := aBlock
]
