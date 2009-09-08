<cfset i18n = application.managers.singleton.getI18N() />

<cfset servEvent = application.factories.transient.getServEventForTracker(application.settings.datasources.update, i18n, SESSION.locale) />