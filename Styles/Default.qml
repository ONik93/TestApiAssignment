pragma Singleton
import QtQuick 2.15

QtObject {
    readonly property FontLoader theme_font: FontLoader {
        source: "qrc:/Assets/fonts/Inter-Light.ttf"
    }

    //General
    readonly property color elementActiveClr: "black"
    readonly property color elementDefaultClr: "#CECECE"

    //Text
    readonly property int textPointSizeCaption: 18
    readonly property int textPointSizeRegular: 12
    readonly property int textPointSizeUserContact: 10

    //Field
    readonly property int fieldHeight: 48
    readonly property int fieldBorderWidth: 1
    readonly property int fieldBorderRadius: 2
}



//QtObject {
//    readonly property FontLoader theme_font: FontLoader {
//        source: "qrc:/Assets/fonts/GothamPro.ttf"
//    }

//    readonly property QtObject buttonPrimary: QtObject {
//        readonly property color background: "transparent"
//        readonly property color border: "#18A0FB"
//        readonly property color text: "white"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: "#18A0FB"
//            readonly property color border: "#18A0FB"
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//    readonly property QtObject buttonSolidBlue: QtObject {
//        readonly property color background: "#18A0FB"
//        readonly property color border: "#18A0FB"
//        readonly property color text: "white"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: "#18A0FB"
//            readonly property color border: "#18A0FB"
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//    readonly property QtObject buttonMacroRec: QtObject {
//        readonly property color background: "transparent"
//        readonly property color border: "#FF2574"
//        readonly property color text: "white"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: "#FF2574"
//            readonly property color border: "#FF2574"
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//    readonly property QtObject button: QtObject {
//        readonly property color background: "transparent"
//        readonly property color border: "#1D283A"
//        readonly property color text: "white"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: Qt.rgba(45, 61, 87, 0.07) // "#1D283A"
//            readonly property color border: "#1D283A"
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//    readonly property QtObject button0: QtObject {
//        readonly property color background: "#1D283A"
//        readonly property color border: Qt.rgba(45, 61, 87, 0.07)
//        readonly property color text: "white"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: Qt.rgba(45, 61, 87, 0.07)
//            readonly property color border: Qt.rgba(45, 61, 87, 0.07)
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//	readonly property QtObject button1: QtObject {
//		readonly property color background: "#48556A"
//		readonly property color border: "#48556A"
//		readonly property color text: "white"
//		readonly property QtObject hovered: QtObject {
//			readonly property color background: "#48556A"
//			readonly property color border: "#18A0FB"
//			readonly property color text: "white"
//		}
//		readonly property QtObject disabled: QtObject {
//			readonly property color background: "#48556A"
//			readonly property color border: "#48556A"
//			readonly property color text: "white"
//		}
//	}
//    readonly property QtObject buttonGlass: QtObject {
//        readonly property color background: "transparent"
//        readonly property color border: "transparent"
//        readonly property color text: "Grey"
//        readonly property QtObject hovered: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "transparent"
//            readonly property color text: "white"
//        }
//        readonly property QtObject disabled: QtObject {
//            readonly property color background: "transparent"
//            readonly property color border: "grey"
//            readonly property color text: "grey"
//        }
//    }
//	readonly property QtObject buttonGlass1: QtObject {
//		readonly property color background: "transparent"
//		readonly property color border: "#111C2E"
//		readonly property color text: "Grey"
//		readonly property QtObject hovered: QtObject {
//			readonly property color background: Qt.rgba(29, 40, 58, 0.3)
//			readonly property color border: "#111C2E"
//			readonly property color text: "white"
//		}
//		readonly property QtObject disabled: QtObject {
//			readonly property color background: "transparent"
//			readonly property color border: "grey"
//			readonly property color text: "grey"
//		}
//	}
//	readonly property color background: "transparent"

//    readonly property font font10: Qt.font({family: "Gotham Pro", pixelSize: 10, styleName: "Regular", weight: Font.Normal})
//    readonly property font font14: Qt.font({family: "Gotham Pro", pixelSize: 14, styleName: "Regular",weight: Font.Bold})
//    readonly property font font16: Qt.font({family: "Gotham Pro", pixelSize: 16, styleName: "Regular",weight: Font.Normal})
//    readonly property font font24: Qt.font({family: "Gotham Pro", pixelSize: 24, styleName: "Regular",weight: Font.Normal})
//}

			// font.family: "Gotham Pro"
			// font.styleName: "Regular"
