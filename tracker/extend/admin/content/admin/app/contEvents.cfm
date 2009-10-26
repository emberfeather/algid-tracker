<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		plugin = theURL.search('plugin'),
		search = theURL.search('search'),
		timeframe = theURL.search('timeframe')
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfset pluginKeys = servEvent.readPluginKeys() />

<cfset paginate = variables.transport.applicationTransients.getPaginate(events.recordcount, theURL.searchID('num'), theURL.searchID('onPage')) />

<cfoutput>
	<div class="float-right">
		#paginate.toHTML( theURL )#
	</div>
	#viewEvent.filter( pluginKeys, filter )#
	#viewEvent.list( events, {
		startRow = paginate.getStartRow(),
		numPerPage = paginate.getNumPerPage()
	} )#
</cfoutput>