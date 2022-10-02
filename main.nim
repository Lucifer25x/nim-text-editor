import nigui
import std/os

app.init()

var window = newWindow("Text Editor")

window.width = 600.scaleToDpi
window.height = 400.scaleToDpi

var container = newLayoutContainer(Layout_Vertical)

window.add(container)

var textArea = newTextArea()
container.add(textArea)

var filePath = ""

proc saveFile = 
    writeFile(filePath, textArea.text)

proc openFile =
    var dialog = newOpenFileDialog()
    dialog.title = "Open File"
    dialog.multiple = false
    # dialog.directory = ""
    dialog.run()
    if dialog.files.len > 0:
        for file in dialog.files:
            filePath = file
            var file_content = readFile(file)
            textArea.text = ""
            textArea.addText(file_content)
            window.title = splitPath(file).tail & " - Text Editor"

window.onKeyDown = proc(event: KeyboardEvent) =
    # Ctrl + Q -> Quit application
    if Key_Q.isDown() and Key_ControlL.isDown():
        app.quit()

    # Ctrl + O -> Open File
    if Key_O.isDown() and Key_ControlL.isDown():
        openFile()

    # Ctrl + S -> Save File
    if Key_S.isDown() and Key_ControlL.isDown():
        if filePath.len > 0:
            saveFile()
        else:
            var dialog = newSaveFileDialog()
            dialog.title = "Save File"
            dialog.run()
            if dialog.file.len > 0:
                filePath = dialog.file
                saveFile()
                window.title = splitPath(filePath).tail & " - Text Editor"

window.show()
app.run()
