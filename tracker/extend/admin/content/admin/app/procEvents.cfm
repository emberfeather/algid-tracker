<cfset i18n = application.managers.singleton.getI18N() />

<cfset servEvent = application.managers.transient.getServEventForTracker(application.settings.datasources.update, i18n, SESSION.locale) />