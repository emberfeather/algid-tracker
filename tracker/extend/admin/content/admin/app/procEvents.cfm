<cfset i18n = application.managers.singleton.getI18N() />

<cfset servEvent = application.factories.transient.getServEventForTracker(application.app.getDSUpdate(), i18n, SESSION.locale) />