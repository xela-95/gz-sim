/*
 * Copyright (C) 2022 Open Source Robotics Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.1
import QtQuick.Window 2.2

Rectangle {
  id: quickStart
  width: 1080
  height: 720
  property var selectedWorld: ""
  property string worldURL: ""

  function changeDefault(checked){
    QuickStartHandler.SetShowDefaultQuickStartOpts(checked);
  }

  function loadWorld(fileURL){
    // Remove "file://" from the QML url.
    var url = fileURL.toString().split("file://")[1]
    quickStart.worldURL = url
    openWorld.enabled = true
    openWorld.Material.background= Material.Green
  }

  function loadFuelWorld(fileName, uploader){
    if (fileName === "Empty World"){
      openWorld.Material.background = Material.Green
      quickStart.worldURL = ""
      openWorld.enabled = true
      quickStart.selectedWorld = "Empty World"
    }
    else {
      // Construct fuel URL
      var fuel_url = "https://app.gazebosim.org/"
      fuel_url += uploader + "/fuel/worlds/" + fileName
      quickStart.worldURL = fuel_url
      openWorld.Material.background = Material.Green
      openWorld.enabled = true
      quickStart.selectedWorld = fileName
    }
  }

  function getWorlds(){
    return "file://"+QuickStartHandler.WorldsPath()
  }

  function getColor(fileName){
    if(fileName === quickStart.selectedWorld)
      return "green";
    return "white";
  }

  RowLayout {
    id: layout
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalTop
    spacing: 0

    ColumnLayout {
      id: localColumn
      Layout.minimumHeight: 100
      Layout.fillWidth: true
      spacing: 0
      Rectangle {
        color: 'transparent'
          Layout.fillWidth: true
          Layout.minimumWidth: 1080
          Layout.preferredWidth: 1080
          Layout.minimumHeight: 150
          Image{
            source: "images/gazebo_horz_pos_topbar.svg"
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignLeft
            y: (parent.height - height) / 2
          }
          Text{
            text: 'v ' + QuickStartHandler.GazeboVersion()
            horizontalAlignment: Image.AlignRight
          }
      }

      Rectangle {
        color: 'transparent'
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.preferredWidth: 700
        Layout.minimumHeight: 400
        RowLayout{
          spacing: 0
          Layout.rightMargin: 20

          ColumnLayout {
            Rectangle {
              Layout.preferredWidth: 720
              Layout.preferredHeight: 450

              color: 'transparent'
              FolderListModel {
                id: folderModel
                showDirs: false
                nameFilters: ["*.png"]
                folder: getWorlds()+ "/thumbnails/"
              }

              Component {
                id: fileDelegate

                FuelThumbnail {
                  id: filePath
                  text: fileName.split('.')[1]
                  uploader: fileName.split('.')[0]
                  width: gridView.cellWidth - 5
                  height: gridView.cellHeight - 5
                  smooth: true
                  source: fileURL
                  color: getColor(fileName.split('.')[1])
                }
              }
              GridView {
                  id: gridView
                  width: parent.width
                  height: parent.height

                  anchors {
                      fill: parent
                      leftMargin: 5
                      topMargin: 5
                  }

                  cellWidth: width / 3
                  cellHeight: height / 2

                  model: folderModel
                  delegate: fileDelegate
                }
              }
            }

              ColumnLayout {
                Layout.rightMargin: 20

                Rectangle {
                  color: "transparent";
                  width: 340; height: 50

                  Label {
                    id: label
                    text: qsTr("Installed worlds")
                    anchors.centerIn: parent
                    color: "#443224"
                    font.pixelSize: 16
                  }
                }

                Rectangle {
                  color: "transparent";
                  width: 340; height: 180;
                    
                  FolderListModel {
                      id: sdfsModel
                      showDirs: false
                      showFiles: true
                      folder: getWorlds()
                      nameFilters: [ "*.sdf" ]
                  }
                  ComboBox {
                    id: comboBox
                    currentIndex : -1
                    model: sdfsModel
                    textRole: 'fileName'
                    width: parent.width
                    onCurrentIndexChanged: quickStart.loadWorld(model.get(currentIndex, 'fileURL'))
                  }
                  MouseArea {
                    onClicked: comboBox.popup.close()
                  }
                }
                Rectangle { color: "transparent"; width: 200; height: 200 }
              }
          }
      }
      Rectangle {
        color: 'transparent'
        Layout.fillWidth: true
        Layout.minimumWidth: 100
        Layout.preferredWidth: 700
        Layout.minimumHeight: 100
      }

        Rectangle {
          color: 'transparent'
          Layout.fillWidth: true
          Layout.preferredWidth: 720
          Layout.minimumHeight: 50
          RowLayout {
            id: skip
            anchors {
                fill: parent
                leftMargin: 10
                topMargin: 10
            }
            CheckBox {
              id: showByDefault
              text: "Don't show again"
              Layout.fillWidth: true
              Layout.leftMargin: 20
              onClicked: {
                quickStart.changeDefault(showByDefault.checked)
              }
            }
            Button {
              id: openWorld
              Layout.fillWidth: true
              Layout.rightMargin: 20
              visible: true
              text: "Run"
              enabled: false
              onClicked: {
                QuickStartHandler.SetStartingWorld(quickStart.worldURL)
                quickStart.Window.window.close()
              }

              Material.background: Material.primary
              ToolTip.visible: hovered
              ToolTip.delay: tooltipDelay
              ToolTip.timeout: tooltipTimeout
              ToolTip.text: qsTr("Run")
            }
          }
        }
    }
  }
}
