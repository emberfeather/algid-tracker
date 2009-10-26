<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		plugin = theURL.search('plugin'),
		search = theURL.search('search'),
		timeframe = theURL.search('timeframe')
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfset pluginKeys = servEvent.readPluginKeys(  ) />

<cfoutput>
	#viewEvent.filter( pluginKeys, filter )#
	#viewEvent.list( events )#
</cfoutput>