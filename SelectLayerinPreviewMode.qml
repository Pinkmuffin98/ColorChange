// Import the standard GUI elements from QTQuick
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.2

// Import the Uranium GUI elements, which are themed for Cura
import UM 1.2 as UM
import Cura 1.0 as Cura


// Dialog from Uranium
// create select layer tool window
UM.Dialog
{
    id: selectLayerWindow

    title: "Select Layer Tool"
    width: 310
    height: 180
    minimumWidth: 310
    minimumHeight: 180
    maximumWidth: 310
    maximumHeight: 180
    modality: Qt.NonModal
    onVisibleChanged:
    {
        if (visible) contentItem.ApplicationWindow.window.flags |= Qt.WindowStaysOnTopHint
    }

    Button
    {
        id: selectLayerButton
        text: "Select Layer"
        property string input
        width: 170
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        onClicked:
        {
            input = layerInput.text
            manager.getTextInput(input)
        }
    }

    Rectangle
    {
        id: displayFrame
        color: "white"
        width: 100
        height: 30
        border.color: "gray"
        border.width: 1
        anchors.top: parent.top
        anchors.topMargin: 45
        anchors.left: selectLayerButton.left

        // regularly check if slider in layer view has been moved
        // update layer input text when slider has been moved
        Timer
        {
            id: update
            interval: 500
            running: true
            repeat: true
            onTriggered:
            {
                if(layerInput.text != (manager.getCurrentLayer + 1).toString())
                    layerInput.text = (manager.getCurrentLayer + 1).toString()
            }
        }

        TextInput
        {
            id: layerInput
            text: (manager.getCurrentLayer + 1).toString()
            property int layNum
            anchors.fill: parent
            anchors.margins: 4

            // stop updating layer input text when text input is used
            onActiveFocusChanged:
            {
                if(activeFocus)
                    update.stop()
            }

            onEditingFinished: update.start()

            // use enter and return keys to set slider to user input layer
            // if input layer is out of range set it to the min or max layer value 
            Keys.onEnterPressed:
            {
                layNum = parseInt(layerInput.text, 10)

                if (layNum > (manager.getMaxLayers + 1)) {
                    layerInput.text = (manager.getMaxLayers + 1).toString()
                    UM.SimulationView.setCurrentLayer(manager.getMaxLayers)
                } else if (layNum < 1) {
                    layerInput.text = "1"
                    UM.SimulationView.setCurrentLayer(0)
                } else
                    UM.SimulationView.setCurrentLayer(layNum - 1)
            }

            Keys.onReturnPressed:
            {
                layNum = parseInt(layerInput.text, 10)

                if (layNum > (manager.getMaxLayers + 1)) {
                    layerInput.text = (manager.getMaxLayers + 1).toString()
                    UM.SimulationView.setCurrentLayer(manager.getMaxLayers)
                } else if (layNum < 1) {
                    layerInput.text = "1"
                    UM.SimulationView.setCurrentLayer(0)
                } else
                    UM.SimulationView.setCurrentLayer(layNum - 1)
            }

            // use up and down keys on keyboard to move up and down the layers
            Keys.onDownPressed:
            {
                if (manager.getCurrentLayer == 0)
                    layerInput.text = (manager.getCurrentLayer + 1).toString()
                else
                    layerInput.text = (manager.getCurrentLayer).toString()
                    UM.SimulationView.setCurrentLayer(manager.getCurrentLayer - 1)
            }

            Keys.onUpPressed:
            {
                if (manager.getCurrentLayer == manager.getMaxLayers)
                    layerInput.text = (manager.getMaxLayers + 1).toString()
                else
                    layerInput.text = (manager.getCurrentLayer + 2).toString()
                    UM.SimulationView.setCurrentLayer(manager.getCurrentLayer + 1)
            }
        }
    }

    // up and down buttons to move up and down the layers
    Button
    {
        id: downButton
        text: ""
        width: 30
        height: 30
        anchors.left: displayFrame.right
        anchors.leftMargin: 5
        anchors.verticalCenter: displayFrame.verticalCenter
        style: ButtonStyle
        {
            label: Item
            {
                UM.RecolorImage
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.round(control.width / 2.5)
                    height: Math.round(control.height / 2.5)
                    sourceSize.height: width
                    color: "black"
                    source: UM.Theme.getIcon("arrow_bottom")
                }
            }
        }
        onClicked:
        {
            if (manager.getCurrentLayer == 0)
                layerInput.text = (manager.getCurrentLayer + 1).toString()
            else
                layerInput.text = (manager.getCurrentLayer).toString()
                UM.SimulationView.setCurrentLayer(manager.getCurrentLayer - 1)
        }
    }

    Button
    {
        id: upButton
        text: ""
        width: 30
        height: 30
        anchors.left: downButton.right
        anchors.leftMargin: 5
        anchors.verticalCenter: displayFrame.verticalCenter
        style: ButtonStyle
        {
            label: Item
            {
                UM.RecolorImage
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.round(control.width / 2.5)
                    height: Math.round(control.height / 2.5)
                    sourceSize.height: width
                    color: "black"
                    source: UM.Theme.getIcon("arrow_top")
                }
            }
        }
        onClicked:
        {
            if (manager.getCurrentLayer == manager.getMaxLayers)
                layerInput.text = (manager.getMaxLayers + 1).toString()
            else
                layerInput.text = (manager.getCurrentLayer + 2).toString()
                UM.SimulationView.setCurrentLayer(manager.getCurrentLayer + 1)
        }
    }

    Rectangle
    {
        id: toolInfoBase
        width: 30
        height: 30
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top

        UM.SimpleButton
        {
            id: infoButton

            anchors.fill: parent
            color: UM.Theme.getColor("icon")
            iconSource: UM.Theme.getIcon("info")
        }

        MouseArea
        {
            id: toolInfoArea
            anchors.fill: parent
            hoverEnabled: toolInfoArea.enabled
            onEntered: tooltip.show()
            onExited: tooltip.hide()
        }
    }

    UM.PointingRectangle
    {
        id: tooltip

        width: 260
        height: label.height + UM.Theme.getSize("tooltip_margins").height * 2
        color: UM.Theme.getColor("tooltip")

        arrowSize: UM.Theme.getSize("default_arrow").width

        opacity: 0

        property alias text: label.text

        function show()
        {
            x = toolInfoBase.x + toolInfoBase.width + 5
            y = toolInfoBase.y + 3

            tooltip.opacity = 1
            target = Qt.point(toolInfoBase.x + 5, toolInfoBase.y + Math.round(UM.Theme.getSize("tooltip_arrow_margins").height / 2))
        }

        function hide()
        {
            tooltip.opacity = 0
        }

        Label
        {
            id: label
            text: "To select a layer use the upper handle of the slider "+
                  "or insert a layer in the text field and press enter. Use " +
                  "the up and down buttons or keys on your key- board " +
                  "to go through the layers. Press the select layer button " +
                  "to insert a color change before the selected layer."
            anchors
            {
                top: parent.top
                topMargin: UM.Theme.getSize("tooltip_margins").height
                left: parent.left
                leftMargin: UM.Theme.getSize("tooltip_margins").width
                right: parent.right
                rightMargin: UM.Theme.getSize("tooltip_margins").width
            }
            wrapMode: Text.Wrap
            textFormat: Text.RichText
            font: UM.Theme.getFont("default")
            color: UM.Theme.getColor("tooltip_text")
            renderType: Text.NativeRendering
        }
    }
}
