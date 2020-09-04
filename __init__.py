from . import ColorChange

from UM.i18n import i18nCatalog
i18n_catalog = i18nCatalog("ColorChange")

def getMetaData():
    return {
        "type": "extension",
        "plugin":
        {
            "name": "Color Change",
            "author": "Julia Wenker and Esra Gueney",
            "version": "1.0.0",
            "supported_sdk_versions": ["6.0.0","6.1.0","6.2.0","6.3.0","7.0.0","7.1.0"],
            "description": i18n_catalog.i18nc("Description of plugin : "," Print multicolored prints with a single extruder. The plugin was developed in the context of the software practical course Multimodal Media Madness [M3] under Prof. Dr. Jan Borchers at RWTH-Aachen. ")
        }
    }

def register(app):
    return {"extension": ColorChange.ColorChange()}
