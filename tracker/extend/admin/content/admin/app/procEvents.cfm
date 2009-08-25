<cfset i18n = application.managers.singleton.getI18N() />

<cfset servEvent = createObject('component', 'plugins.tracker.inc.service.servEvent').init(application.settings.datasources.update, i18n, SESSION.locale) />