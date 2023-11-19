#!/usr/bin/env python3
import gi
import cheathelper
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib
from threading import Thread
from time import sleep
#Usados para internacionalizacion
import gettext
import locale
from pathlib import Path

_ = gettext.gettext #Alias para no tener que escribir todo

class CheatInterface():

    run_on_main_thread=GLib.idle_add

    def __init__(self): #Se lanza al crear la clase 
        self.createInterface()
        
    def createInterface(self): #Crea la interfaz basica
        self.win=Gtk.ApplicationWindow(title=_("ComandosCheat"), default_width=600, default_height=400) #Le pone el nombre a la ventana creada       
        
        WINDOW_PADDING = 20
        vbox=Gtk.Box(orientation=1, 
                     spacing=6,
                     margin_top= WINDOW_PADDING,
                     margin_end= WINDOW_PADDING,
                     margin_bottom= WINDOW_PADDING,
                     margin_start= WINDOW_PADDING) #Metodo vbox que permite organizar los widgets (con orientacion vertical)
        self.win.add(vbox)
        
        menuBar=Gtk.MenuBar() 
        menu = Gtk.Menu.new()
        menuBar=Gtk.MenuBar() 
        menuBar.set_hexpand(True)
        menuBar.set_pack_direction(Gtk.PackDirection.RTL)
        menuItemOptions=Gtk.MenuItem(label=_("≡"))
        self.menuItemHelp=Gtk.MenuItem(label=_("Ayuda"))
        self.menuItemAbout=Gtk.MenuItem(label=_("Acerca de"))
        menu.append(self.menuItemHelp)
        menu.append(self.menuItemAbout)
        menuItemOptions.set_submenu(menu)
        menuBar.append(menuItemOptions)
        vbox.pack_start(menuBar, False, False, 0)
        
        label=Gtk.Label(label=_("BUSCADOR DE COMANDOS UNIX")) #Creamos una etiqueta que explica lo que se puede hacer
        vbox.pack_start(label, False, False, 0) #Y la anadimos a la caja
        
        vbox2=Gtk.Box(orientation=0, spacing=6, hexpand=True, halign=Gtk.Align.CENTER) #Caja 2
        vbox.pack_start(vbox2, False, False, 0)    
        
        self.searchentry=Gtk.SearchEntry() #BARRA BUSCAR
        self.searchentry.set_placeholder_text(_("Busque aquí"))
        vbox2.pack_start(self.searchentry, False, False, 0) #Anadimos elemento de tipo entry que nos permite mostrar un campo vacio y coger el texto introducido 
        
        self.button=Gtk.Button.new_with_label(_("Buscar")) #Boton buscar que permite al usuario introducir los datos
        vbox2.pack_start(self.button, False, False, 0)

        self.spinner=Gtk.Spinner() #SPINNER
        vbox2.pack_start(self.spinner, False, False, 0)        
                
        self.searchentry2=Gtk.SearchEntry() #BARRA FILTRAR
        self.searchentry2.set_placeholder_text(_("Filtre aquí"))
        vbox2.pack_start(self.searchentry2, False, False, 0)


        self.buttonFilter=Gtk.Button.new_with_label(_("Filtrar")) #BOTON FILTRAR
        vbox2.pack_start(self.buttonFilter, False, False, 0)
        
        self.resetButton=Gtk.Button.new_with_label(_("Restablecer filtro")) #Boton restablecer que permite al usuario eliminar el filtro
        vbox2.pack_start(self.resetButton, False, False, 0)

        self.liststore=Gtk.ListStore(str, str) #LISTSTORE
        self.filterOption=None
        self.filterForOptions=self.liststore.filter_new()
        self.filterForOptions.set_visible_func(self.filterText)

        self.treeview=Gtk.TreeView(model=self.filterForOptions) #TREEVIEW
        renderer_text=Gtk.CellRendererText()
        column_command=Gtk.TreeViewColumn(_("Comando"), renderer_text, text=0)
        self.treeview.append_column(column_command)
        column_description=Gtk.TreeViewColumn(_("Descripción"), renderer_text, text=1)
        self.treeview.append_column(column_description)

        scrollbar=Gtk.ScrolledWindow() #SCROLLBAR
        scrollbar.add(self.treeview)
        
        vbox.pack_start(scrollbar, True, True, 0)

    def resetFilter(self, option):
        self.searchentry2.set_text("")
        self.filterOption = option
        self.filterForOptions.refilter()
        
    def run(self): #Metodo que se ejecuta en el main despues de crear la clase. Permite mostrar la ventana creada en la clase anterior
        self.win.show_all()
        Gtk.main()

    def initSearch(self):
        self.searchentry2.set_text("")
        self.button.set_sensitive(False)
        self.buttonFilter.set_sensitive(False)
        self.searchentry.set_sensitive(False)
        self.searchentry2.set_sensitive(False)
        self.spinner.start()

    def endSearch(self):
        self.button.set_sensitive(True)
        self.buttonFilter.set_sensitive(True)
        self.searchentry.set_sensitive(True)
        self.searchentry2.set_sensitive(True)
        self.spinner.stop()

    def showHelp(self, msg):
        dialog=Gtk.MessageDialog(parent=self.win, flags=0, message_type=Gtk.MessageType.INFO, buttons=Gtk.ButtonsType.OK, text=_("AYUDA"))
        dialog.format_secondary_text(msg)
        dialog.run()
        dialog.destroy()

    def showAbout(self, name, comments, authors):
        aboutDialog=Gtk.AboutDialog()
        aboutDialog.set_name(comments)
        aboutDialog.set_comments(comments)
        aboutDialog.set_authors(authors)
        aboutDialog.connect('response', lambda dialog, data: dialog.destroy())
        aboutDialog.show_all()
	
    def changeFilter(self, entry):
        self.filterOption=entry
        self.filterForOptions.refilter()
     
    def filterText(self, model, iter, data):
        if(self.filterOption is None or self.filterOption == "None"):
            return True
        else:
            if self.filterOption in model[iter][0]:
                return model[iter][0]
    
    def messageError(self, msg):
        dialog=Gtk.MessageDialog(parent=self.win, flags=0, message_type=Gtk.MessageType.ERROR, buttons=Gtk.ButtonsType.OK, text=_("ERROR"))
        dialog.format_secondary_text(msg)
        dialog.run()
        dialog.destroy()

    def quit(self): #Metodo que es llamado cuando se le da al boton de cerrar
        Gtk.main_quit()
    
    def clean(self):
        self.filterOption=None
        self.liststore.clear()

    def updateInfo(self, commands): #Metodo que permite coger el texto introducido y operar con el
        self.clean()    
        for command in commands: #Recorre todas las respuestas al comando y las almacena en strings
            if command.commands: #Quita las leneas que no tienen comandos
                self.liststore.append([command.commands, command.description]) 
            
    def takeEntrySearch(self):
        return self.searchentry.get_text()

    def takeEntryFilter(self):
        return self.searchentry2.get_text()   
    
    def registerHandler(self, handler): #Conecta los botones al controller
        self.button.connect("clicked", handler.searchButtonClicked)
        self.menuItemHelp.connect("activate", handler.helpButtonClicked)
        self.menuItemAbout.connect("activate", handler.aboutButtonClicked)
        self.buttonFilter.connect("clicked", handler.filterButtonClicked)
        self.searchentry.connect("icon-press", handler.removeSearchButtonClicked)
        self.searchentry2.connect("icon-press", handler.removeFilterIconPressed)
        self.win.connect("destroy", handler.quit) #Boton cerrar
        self.searchentry.connect("key-press-event", handler.analyzeKey, "search")
        self.searchentry2.connect("key-press-event", handler.analyzeKey, "filter")
        self.resetButton.connect("clicked", handler.removeFilterButtonClicked)

class CheatController():
    
    def __init__(self, view, model):
        self.view=view
        self.model=model
        self.view.registerHandler(self)
        
    def run(self):    
        self.model.run()
        self.view.run()          

    def quit(self, widget):
        self.model.quit()
        self.view.quit()
        
    def analyzeKey(self, widget, signal, option):
        enterkey = "\x0D"
        if signal.string == enterkey:
            if option == "search":
                self.searchButtonClicked(widget)
            if option == "filter":
                self.filterButtonClicked(widget) 

    def filterButtonClicked(self, widget):
        entry=self.view.takeEntryFilter()
        if not entry:
            entry=None
        self.view.changeFilter(entry)

    def removeSearchButtonClicked(self, widget, widget2, widget3):
        self.view.clean()
    
    def removeFilterButtonClicked(self, widget):
        self.view.resetFilter(None)
            
    def removeFilterIconPressed(self, widget, widget2, widget3):
        self.view.resetFilter(None)

    def helpButtonClicked(self, widget):
        msg=_("BUSQUEDA: Busque un comando sin opciones\nFILTRO: Introduzca la opción por la que quiera filtrar. Para resetear el filtro simplemente pulse la 'x', presione el botón de filtrado sin texto o presione el botón de restablecer filtro.")
        self.view.showHelp(msg)
        
    def aboutButtonClicked(self, widget):
        name = _("ComandosCheat")
        comments = _("Esta aplicación permite buscar comandos UNIX y ver sus distintas opciones.")
        authors = ["Sergio Goyanes Legazpi", "Martín Regueiro Golán", "Pablo Fernández Pérez"]
        self.view.showAbout(name, comments, authors)
    
    def validateEntry(self, entry):
        if not entry:
            self.view.messageError(_("Error: No ha introducido ningún texto"))
            return False
        if ' ' in entry:
            self.view.messageError(_("Error: Formato no válido (tiene espacios)"))
            return False
        return True
        
    def validateCommands(self, commands):
        if commands is None:
            CheatInterface.run_on_main_thread(self.view.messageError, _("Error: Fallo de conexion"))
            return False
        if not commands:
            CheatInterface.run_on_main_thread(self.view.messageError, _("Error: Comando desconocido"))
            return False
        return True    
    
    def searchButtonClicked(self, widget):
        self.entry=self.view.takeEntrySearch()
        if self.validateEntry(self.entry):
            t=Thread(target=self.search)
            t.start()  
              
    def search(self):
        CheatInterface.run_on_main_thread(self.view.initSearch)
        commands=self.model.getCommand(self.entry)
        if self.validateCommands(commands):
            CheatInterface.run_on_main_thread(self.view.updateInfo, commands)
        CheatInterface.run_on_main_thread(self.view.endSearch)           


class CheatModel():
    
    def getCommand(self, command):
        try:
            return cheathelper.get_cheatsheet(command) #Llama al metodo get_cheatsheet del archivo cheathelper.py. Esto nos devuelve una lista
        except Exception as e: #En caso de error -> Excepcion
            print(e)
            return None
    
    def run(self):
        pass
    
    def quit(self):
        pass    
                

if __name__ == "__main__":
    
    mytextdomain='ComandosCheat'
    locale.setlocale(locale.LC_ALL, '')
    LOCALE_DIR = Path(__file__).parent / "locale"
    locale.bindtextdomain(mytextdomain, LOCALE_DIR)
    gettext.bindtextdomain(mytextdomain, LOCALE_DIR)
    gettext.textdomain(mytextdomain)
    
    view=CheatInterface()
    model=CheatModel()
    controller=CheatController(view, model)
    app=controller
    app.run()
