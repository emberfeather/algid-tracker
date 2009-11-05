<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		'ipAddress' = theURL.search('ipAddress'),
		'key' = theURL.search('key'),
		'plugin' = theURL.search('plugin'),
		'search' = theURL.search('search'),
		'timeframe' = theURL.search('timeframe'),
		'userID' = theURL.search('userID')
	} />

<cfset pluginKeys = servEvent.readPluginKeys() />

<cfoutput>
	#viewEvent.filter( pluginKeys, filter )#
</cfoutput>