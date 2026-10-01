pragma Singleton
import QtQuick

QtObject {
    readonly property color background: "{{colors.background.default.hex}}"
    readonly property color surface: "{{colors.surface.default.hex}}"
    readonly property color surfaceContainer: "{{colors.surface_container.default.hex}}"
    readonly property color primary: "{{colors.primary.default.hex}}"
    readonly property color primaryText: "{{colors.on_primary.default.hex}}"
    readonly property color secondary: "{{colors.secondary.default.hex}}"
    readonly property color text: "{{colors.on_surface.default.hex}}"
    readonly property color outline: "{{colors.outline.default.hex}}"
    readonly property color error: "{{colors.error.default.hex}}"
}
