# Diseño software

<!-- ## Notas para el desarrollo de este documento
En este fichero debeis documentar el diseño software de la práctica.

> :warning: El diseño en un elemento "vivo". No olvideis actualizarlo
> a medida que cambia durante la realización de la práctica.

> :warning: Recordad que el diseño debe separar _vista_ y
> _estado/modelo_.
	 

El lenguaje de modelado es UML y debeis usar Mermaid para incluir los
diagramas dentro de este documento. Por ejemplo:

```mermaid
classDiagram
    class Model {
	}
	class View {
	}
	View ..> Gtk : << uses >>
	class Gtk
	<<package>> Gtk
```
-->
Diagrama Estático:
```mermaid
classDiagram
    CheatController ..> CheatInterface : << updates >>
    CheatController ..> CheatModel : << uses >>
    class CheatModel{
        +getCommand(self, command) Sequence~CheatEntry~
	+run(self)
        +quit(self)
    }  
    class CheatController{
    	+view
    	+model
	+entry
        +__init__(self, view, model)
        +run(self)   
        +quit(self, widget)
        +filterButtonClicked(self, widget)
        +removeSearchButtonClicked(self, widget, widget2, widget3)
	+removeFilterButtonClicked(self, widget)
        +removeFilterIconPressed(self, widget, widget2, widget3)
        +helpButtonClicked(self, widget)
	+aboutButtonClicked(self, widget)
        +validateEntry(self, entry)
        +validateCommands(self, commands)
        +searchButtonClicked(self, widget)
        +search(self)
	+analyzeKey(self, widget, signal, option)
    }  
    class CheatInterface{
        +win
        +searchEntry
        +searchEntry2
	+button
	+buttonFilter
	+resetButton
	+menuItemHelp
	+menuItemAbout
	+spinner
        +liststore
        +treeview
        +filterOption
        +filterForOptions
	+__init__(self, model)
	+createInterface(self)
        +resetFilter(self, option) 
   	+run(self)
    	+initSearch(self)
    	+endSearch(self)
    	+showHelp(self, msg)
    	+changeFilter(self, entry)
    	+filterText(self, model, iter, data)
    	+messageError(self, msg)
    	+quit(self)
    	+clean(self)
    	+updateInfo(self, commands)
    	+takeEntrySearch(self)
    	+takeEntryFilter(self)
    	+registerHandler(self, handler)
    }
    CheatInterface ..> Gtk : << uses >>
	class Gtk
	<<package>> Gtk
```
Diagrama Dinámico:
```mermaid
sequenceDiagram
Actor User
activate Main
    User->>Main: 
    Main->>CheatInterface:_init_()
    activate CheatInterface
    CheatInterface->>CheatInterface:createInterface()
    deactivate CheatInterface
    Main->>CheatController:_init_()
    activate CheatController
    CheatController->>CheatInterface:registerHandler()
    deactivate CheatController
    activate CheatInterface
    Main->>CheatController:run()
    activate CheatController
    CheatController->>CheatInterface:run()
    CheatController->>CheatModel:run()
    deactivate CheatController
    activate CheatInterface
    User->>CheatInterface:on button clicked()
    activate CheatInterface
    CheatInterface->>CheatController: searchButtonClicked()
    CheatController->>CheatInterface: takeEntrySearch()
    CheatInterface-->>CheatController: self.searchentry.get_text()
    deactivate CheatInterface
    activate CheatController
    CheatController->>CheatController: validateEntry()
    CheatController->>CheatController':<<Thread>>
    deactivate CheatController
    activate CheatController'
    CheatController'->>CheatInterface: initSearch()
    activate CheatInterface
    CheatController'->>CheatModel: getCommand()
    activate CheatModel
    CheatModel-->>CheatController': commands
    deactivate CheatModel
    CheatController'->>CheatController': validateCommands()
    CheatController'->>CheatInterface: updateInfo()
    CheatController'->>CheatInterface: endSearch()
    deactivate CheatInterface
    deactivate CheatController'
    
    User->>CheatInterface:on buttonFilter clicked()
    activate CheatInterface
    CheatInterface->>CheatController: filterButtonClicked()
    activate CheatController
    CheatController->>CheatInterface: takeEntryFilter()
    CheatInterface-->>CheatController: entry
    CheatController->>CheatInterface: changeFilter()
    deactivate CheatController
    deactivate CheatInterface
    
    User->>CheatInterface:on resetButton clicked()
    activate CheatInterface
    CheatInterface->>CheatController: removeFilterButtonClicked()
    activate CheatController
    CheatController->>CheatInterface: resetFilter()
    deactivate CheatController
    deactivate CheatInterface
    
    User->>CheatInterface:on menuItemHelp activated()
    activate CheatInterface
    CheatInterface->>CheatController: helpButtonClicked()
    activate CheatController
    CheatController->>CheatInterface: showHelp()
    deactivate CheatController
    deactivate CheatInterface
    
    User->>CheatInterface:on menuItemAbout activated()
    activate CheatInterface
    CheatInterface->>CheatController: aboutButtonClicked()
    activate CheatController
    CheatController->>CheatInterface: showAbout()
    deactivate CheatController
    deactivate CheatInterface
    
    User->>CheatInterface:on win destroyed()
    activate CheatInterface
    CheatInterface->>CheatController:quit()
    activate CheatController
    CheatController->>CheatInterface:quit()
    deactivate CheatInterface
    CheatController->>CheatModel:quit()
    deactivate CheatController
    
deactivate Main
```
