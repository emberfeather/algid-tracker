<cfset viewEvent = transport.theApplication.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		'ipAddress' = theURL.search('ipAddress'),
		'key' = theURL.search('key'),
		'plugin' = theURL.search('plugin'),
		'search' = theURL.search('search'),
		'timeframe' = theURL.search('timeframe'),
		'userID' = theURL.search('userID')
	} />

<cfset pluginKeys = servEvent.getPluginKeys() />

<cfoutput>
	#viewEvent.filter( filter, pluginKeys )#
</cfoutput>