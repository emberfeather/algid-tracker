<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		search = theURL.search('search'),
		timeframe = theURL.search('timeframe')
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfoutput>
	#viewEvent.filter( filter )#
	#viewEvent.list( events )#
</cfoutput>