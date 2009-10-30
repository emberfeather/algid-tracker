<cfset viewEvent = application.factories.transient.getViewEventForTracker( transport ) />

<cfset filter = {
		key = theURL.search('key'),
		plugin = theURL.search('plugin'),
		search = theURL.search('search'),
		timeframe = theURL.search('timeframe')
	} />

<cfset events = servEvent.readEvents( filter ) />

<cfset pluginKeys = servEvent.readPluginKeys() />

<cfset paginate = variables.transport.applicationTransients.getPaginate(events.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfset datagridFilter = SESSION.managers.singleton.getAdminDatagridFilter() />

<cfoutput>
	<div class="float-right">
		#paginate.toHTML( theURL )#
	</div>
	#viewEvent.filter( pluginKeys, filter )#
	#viewEvent.list( events, {
		startRow = paginate.getStartRow(),
		numPerPage = paginate.getNumPerPage()
	} )#
	#datagridFilter.toHTML( theURL, { submit = 'update' } )#
</cfoutput>