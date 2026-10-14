import QtQuick
import QtQuick.Window
import org.kde.plasma.plasmoid

WallpaperItem {
    id: root

    // Bounding box of all monitors, in logical pixels, independent of this screen.
    readonly property rect screensBox: {
        const screens = Qt.application.screens
        let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity
        for (let i = 0; i < screens.length; i++) {
            const s = screens[i]
            minX = Math.min(minX, s.virtualX)
            minY = Math.min(minY, s.virtualY)
            maxX = Math.max(maxX, s.virtualX + s.width)
            maxY = Math.max(maxY, s.virtualY + s.height)
        }
        return Qt.rect(minX, minY, maxX - minX, maxY - minY)
    }

    Item {
        anchors.fill: parent
        clip: true

        Image {
            source: root.configuration.Image
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            width: root.screensBox.width
            height: root.screensBox.height
            sourceSize: Qt.size(root.screensBox.width * Screen.devicePixelRatio,
                                 root.screensBox.height * Screen.devicePixelRatio)

            // Shift so this screen's slice of the shared canvas lands at (0, 0).
            x: -(Screen.virtualX - root.screensBox.x)
            y: -(Screen.virtualY - root.screensBox.y)
        }
    }
}
