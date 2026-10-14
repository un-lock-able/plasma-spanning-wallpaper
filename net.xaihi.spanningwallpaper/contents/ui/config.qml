import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QtControls
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root
    twinFormLayouts: parentLayout

    property string cfg_Image
    property string cfg_ImageDefault

    RowLayout {
        Kirigami.FormData.label: i18nd("plasma_wallpaper_net.xaihi.spanningwallpaper", "Image:")

        QtControls.TextField {
            id: pathField
            Layout.fillWidth: true
            text: root.cfg_Image
            onEditingFinished: root.cfg_Image = text
        }

        QtControls.Button {
            icon.name: "document-open"
            text: i18nd("plasma_wallpaper_net.xaihi.spanningwallpaper", "Choose…")
            onClicked: fileDialog.open()
        }
    }

    FileDialog {
        id: fileDialog
        title: i18nd("plasma_wallpaper_net.xaihi.spanningwallpaper", "Choose Image")
        nameFilters: [i18nd("plasma_wallpaper_net.xaihi.spanningwallpaper", "Image files (*.png *.jpg *.jpeg *.bmp *.webp *.tiff)")]
        onAccepted: {
            root.cfg_Image = selectedFile
            pathField.text = root.cfg_Image
        }
    }
}
