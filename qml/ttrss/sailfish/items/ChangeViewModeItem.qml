/*
 * This file is part of TTRss, a Tiny Tiny RSS Reader App
 * for MeeGo Harmattan and Sailfish OS.
 * Copyright (C) 2012–2014  Hauke Schade
 *
 * TTRss is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * TTRss is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with TTRss; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or see
 * http://www.gnu.org/licenses/.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

MenuItem {
    signal updateView

    text: switch(settings.viewMode) {
          case 'all_articles':
              qsTr('Show: all')
              break
          case 'adaptive':
              qsTr('Show: adaptive')
              break
          case 'marked':
              qsTr('Show: marked')
              break
          case 'updated':
              qsTr('Show: updated')
              break
          case 'unread':
          default:
              qsTr('Show: unread')
          }

    onClicked: {
        pageStack.push(selectorPage)
    }

    Component {
        id: selectorPage

        Page {
            SilicaListView {
                id: listView
                anchors.fill: parent

                header: PageHeader {
                    title: qsTr("Show")
                }

                model: ListModel {
                    id: viewModeModel
                }

                delegate: ListItem {
                    id: listItem
                    Label {
                        anchors.fill: parent
                        anchors.margins: Theme.paddingMedium
                        text: model.title
                        color: listItem.highlighted ? Theme.highlightColor
                                                    : Theme.primaryColor
                    }

                    onClicked: {
                        if (settings.viewMode !== model.value) {
                            // update settings
                            settings.viewMode = model.value

                            // update backend
                            var ttrss = rootWindow.getTTRSS()
                            ttrss.setViewMode(model.value)

                            // inform about change
                            updateView()
                        }
                        pageStack.pop()
                    }
                }

                VerticalScrollDecorator { }
            }

            Component.onCompleted: {
                var ttrss = rootWindow.getTTRSS()
                var modes = ttrss.getSupportedViewModes()
                for (var i = 0; i < modes.length; ++i) {
                    var title
                    switch(modes[i]) {
                    case 'all_articles':
                        title = qsTr('All')
                        break
                    case 'adaptive':
                        title = qsTr('Adaptive')
                        break
                    case 'marked':
                        title = qsTr('Marked')
                        break
                    case 'updated':
                        title = qsTr('Updated')
                        break
                    case 'unread':
                    default:
                        title = qsTr('Unread')
                    }

                    viewModeModel.append({
                                             title: title,
                                             value: modes[i]
                                         })
                }
            }
        }
    }
}
