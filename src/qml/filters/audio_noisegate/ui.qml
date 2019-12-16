/*
 * Copyright (c) 2019 Meltytech, LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Shotcut.Controls 1.0

KeyframableFilter {

    property string lfkey: '0'
    property string hfkey: '1'
    property string threshold: '2'
    property string attack: '3'
    property string hold: '4'
    property string decay: '5'
    property string range: '6'
    property string output: '7'
    property double lfkeyDefault: 33.6
    property double hfkeyDefault: 23520
    property double thresholdDefault: -70
    property double attackDefault: 250.008
    property double holdDefault: 1500.5
    property double decayDefault: 2001
    property double rangeDefault: -90

    keyframableParameters: [lfkey, hfkey, threshold, attack, hold, decay, range]
    startValues: [lfkeyDefault, hfkeyDefault, thresholdDefault, attackDefault, holdDefault, decayDefault, rangeDefault]
    middleValues: [lfkeyDefault, hfkeyDefault, thresholdDefault, attackDefault, holdDefault, decayDefault, rangeDefault]
    endValues: [lfkeyDefault, hfkeyDefault, thresholdDefault, attackDefault, holdDefault, decayDefault, rangeDefault]

    width: 200
    height: 250

    Component.onCompleted: {
        if (filter.isNew) {
            filter.set(lfkey, lfkeyDefault)
            filter.set(hfkey, hfkeyDefault)
            filter.set(threshold, thresholdDefault)
            filter.set(attack, attackDefault)
            filter.set(hold, holdDefault)
            filter.set(decay, decayDefault)
            filter.set(range, rangeDefault)
            filter.savePreset(preset.parameters)
        }
        setControls()
        outputCheckbox.checked = filter.get(output) === '-1'
    }

    function setControls() {
        var position = getPosition()
        blockUpdate = true
        lfkeySlider.value = filter.getDouble(lfkey, position)
        hfkeySlider.value = filter.getDouble(hfkey, position)
        thresholdSlider.value = filter.getDouble(threshold, position)
        attackSlider.value = filter.getDouble(attack, position)
        holdSlider.value = filter.getDouble(hold, position)
        decaySlider.value = filter.getDouble(decay, position)
        rangeSlider.value = filter.getDouble(range, position)
        blockUpdate = false
        enableControls(isSimpleKeyframesActive())
    }

    function enableControls(enabled) {
        lfkeySlider.enabled = hfkeySlider.enabled = thresholdSlider.enabled = thresholdSlider.enabled =
        attackSlider.enabled = holdSlider.enabled = decaySlider.enabled = rangeSlider.enabled = enabled
    }

    function updateSimpleKeyframes() {
        updateFilter(lfkey, lfkeySlider.value, lfkeyKeyframesButton)
        updateFilter(hfkey, hfkeySlider.value, hfkeyKeyframesButton)
        updateFilter(threshold, thresholdSlider.value, thresholdKeyframesButton)
        updateFilter(attack, attackSlider.value, attackKeyframesButton)
        updateFilter(hold, holdSlider.value, holdKeyframesButton)
        updateFilter(decay, decaySlider.value, decayKeyframesButton)
        updateFilter(range, rangeSlider.value, rangeKeyframesButton)
    }

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 4

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
        }
        Preset {
            id: preset
            parameters: [lfkey, hfkey, threshold, attack, hold, decay, range]
            Layout.columnSpan: 3
            onBeforePresetLoaded: {
                resetSimpleKeyframes()
            }
            onPresetSelected: {
                setControls()
                initializeSimpleKeyframes()
            }
        }

        Label {
            text: qsTr('Key Filter: Low Frequency')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: lfkeySlider
            minimumValue: 33.6
            maximumValue: 4800
            stepSize: 0.1
            decimals: 1
            suffix: ' Hz'
            onValueChanged: updateFilter(lfkey, value, lfkeyKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: lfkeySlider.value = lfkeyDefault
        }
        KeyframesButton {
            id: lfkeyKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(lfkey) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, lfkey, lfkeySlider.value)
            }
        }

        Label {
            text: qsTr('Key Filter: High Frequency')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: hfkeySlider
            minimumValue: 240
            maximumValue: 23520
            stepSize: 0.1
            decimals: 1
            suffix: ' Hz'
            onValueChanged: updateFilter(hfkey, value, hfkeyKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: hfkeySlider.value = hfkeyDefault
        }
        KeyframesButton {
            id: hfkeyKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(hfkey) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, hfkey, hfkeySlider.value)
            }
        }

        Label {}
        CheckBox {
            id: outputCheckbox
            Layout.columnSpan: 3
            text: qsTr('Output key only')
            onClicked: filter.set(output, checked? -1 : 0)
        }

        Label {
            text: qsTr('Threshold')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: thresholdSlider
            minimumValue: -70
            maximumValue: 20
            stepSize: 0.1
            decimals: 1
            suffix: ' dB'
            onValueChanged: updateFilter(threshold, value, thresholdKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: thresholdSlider.value = thresholdDefault
        }
        KeyframesButton {
            id: thresholdKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(threshold) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, threshold, thresholdSlider.value)
            }
        }

        Label {
            text: qsTr('Attack')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: attackSlider
            minimumValue: 0.01
            maximumValue: 1000
            stepSize: 1
            suffix: ' ms'
            onValueChanged: updateFilter(attack, value, attackKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: attackSlider.value = attackDefault
        }
        KeyframesButton {
            id: attackKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(attack) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, attack, attackSlider.value)
            }
        }

        Label {
            text: qsTr('Hold')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: holdSlider
            minimumValue: 2
            maximumValue: 2000
            stepSize: 1
            suffix: ' ms'
            onValueChanged: updateFilter(hold, value , holdKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: holsSlider.value = holdDefault
        }
        KeyframesButton {
            id: holdKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(hold) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, hold, holdSlider.value)
            }
        }

        Label {
            text: qsTr('Decay')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: decaySlider
            minimumValue: 2
            maximumValue: 4000
            stepSize: 1
            suffix: ' ms'
            onValueChanged: updateFilter(decay, value, decayKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: decaySlider.value = decayDefault
        }
        KeyframesButton {
            id: decayKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(decay) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, decay, decaySlider.value)
            }
        }

        Label {
            text: qsTr('Range')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: rangeSlider
            minimumValue: -90
            maximumValue: 0
            stepSize: 0.1
            decimals: 1
            suffix: ' dB'
            onValueChanged: updateFilter(range, value, rangeKeyframesButton, getPosition())
        }
        UndoButton {
            onClicked: rangeSlider.value = rangeDefault
        }
        KeyframesButton {
            id: rangeKeyframesButton
            checked: filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(range) > 0
            onToggled: {
                enableControls(true)
                toggleKeyframes(checked, range, rangeSlider.value)
            }
        }

        Item {
            Layout.fillHeight: true;
        }
    }

    Connections {
        target: filter
        onInChanged: updateSimpleKeyframes()
        onOutChanged: updateSimpleKeyframes()
        onAnimateInChanged: updateSimpleKeyframes()
        onAnimateOutChanged: updateSimpleKeyframes()
    }

    Connections {
        target: producer
        onPositionChanged: setControls()
    }
}