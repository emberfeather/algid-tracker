<cfset paginate = variables.transport.applicationTransients.getPaginate(events.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfset datagridFilter = SESSION.managers.singleton.getAdminDatagridFilter() />

<cfoutput>
	<div class="float-right">
		#paginate.toHTML( theURL )#
	</div>
	#viewEvent.list( events, {
		startRow = paginate.getStartRow(),
		numPerPage = paginate.getNumPerPage()
	} )#
	#datagridFilter.toHTML( theURL, { submit = 'update' } )#
</cfoutput>