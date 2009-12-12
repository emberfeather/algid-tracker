<cfset events = servEvent.readEvents( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(events.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, events, viewEvent, paginate, filter)#</cfoutput>
