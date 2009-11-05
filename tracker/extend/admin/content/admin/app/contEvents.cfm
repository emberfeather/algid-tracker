<cfset events = servEvent.readEvents( filter ) />

<cfset paginate = variables.transport.applicationTransients.getPaginate(events.recordcount, SESSION.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, events, viewEvent, paginate, filter)#</cfoutput>
